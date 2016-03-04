Docker Create Centos Image
==========================
This script is an opionated way to create a base docker container using
yum from a CentOS base machine.

This assumes that you have a running CentOS machine.

Steps:
======
1. Boot to a CentOS 6 machine
2. Clone this repo
3. Run the script
4. Note the location of the tar.gz file
5. Copy this file locally off the host
6. Import this tar ball into docker (Example)
   This would import the image with the tag name `codylane:centos6`.
```
cat centos6.tar.gz | docker import - codylane:centos6
```
7. Or you can use scratch using a docker file
```
   FROM scratch
   ADD $(basename centos6.tar.gz) /
```
