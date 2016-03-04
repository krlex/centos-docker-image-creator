#!/bin/bash

OS_VER=6

DISTRIB="centos"

TARGET_DIR="/var/tmp/${DISTRIB}${OS_VER}"

ARCH="${ARCH:-$(uname -m)}"

PACKAGES="bind-utils
gcc
git
keyutils
make
openssh-clients
openssh-server
tar
vim
wget
which
yum"

rpm -q yum-utils || yum install -y yum-utils

mkdir -p $TARGET_DIR
mkdir -p "$TARGET_DIR/var/lib/rpm"

mkdir -m 755 "$TARGET_DIR"/dev
mknod -m 600 "$TARGET_DIR"/dev/console c 5 1
mknod -m 600 "$TARGET_DIR"/dev/initctl p
mknod -m 666 "$TARGET_DIR"/dev/full c 1 7
mknod -m 666 "$TARGET_DIR"/dev/null c 1 3
mknod -m 666 "$TARGET_DIR"/dev/ptmx c 5 2
mknod -m 666 "$TARGET_DIR"/dev/random c 1 8
mknod -m 666 "$TARGET_DIR"/dev/tty c 5 0
mknod -m 666 "$TARGET_DIR"/dev/tty0 c 4 0
mknod -m 666 "$TARGET_DIR"/dev/urandom c 1 9
mknod -m 666 "$TARGET_DIR"/dev/zero c 1 5

rpm --root "$TARGET_DIR" --initdb

yumdownloader --destdir=/var/tmp centos-release

rpm --root $TARGET_DIR -ivh --nodeps /var/tmp/centos-release*.rpm

YUM_BASE_OPTS="yum -c /etc/yum.conf --installroot $TARGET_DIR"

YUM_OPTS="$YUM_BASE_OPTS install -y"

for PKG in $PACKAGES
do
	YUM_OPTS="$YUM_OPTS $PKG"
done

eval "$YUM_OPTS"

cat > $TARGET_DIR/etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=localhost.localdomain
EOF

YUM_OPTS="$YUM_BASE_OPTS -y clean all"

eval $YUM_OPTS

rm -rf $TARGET_DIR/usr/share/{man,doc,info,gnome/help}
rm -rf $TARGET_DIR/usr/share/cracklib
rm -rf $TARGET_DIR/usr/share/i18n
rm -rf $TARGET_DIR/var/cache/yum

mkdir -p --mode=0755 "$target"/var/cache/yum

cp $TARGET_DIR/etc/skel/.bash* $TARGET_DIR/

tar czf $DISTRIB${OS_VER}.tar.gz -C $TARGET_DIR .
