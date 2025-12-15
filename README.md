This README file contains information on the contents of the meta-serena-layer layer.

Please see the corresponding sections below for details.

Dependencies
============

  URI: <first dependency>
  branch: <branch name>

  URI: <second dependency>
  branch: <branch name>

  .
  .
  .

Patches
=======

Please submit any patches against the meta-serena-layer layer to the xxxx mailing list (xxxx@zzzz.org)
and cc: the maintainer:

Maintainer: XXX YYYYYY <xxx.yyyyyy@zzzzz.com>

Table of Contents
=================

  I. Adding the meta-serena-layer layer to your build
 II. Misc


I. Adding the meta-serena-layer layer to your build
=================================================
After adding the enclustra layers
Run 'bitbake-layers add-layer meta-serena-layer'

II. Misc
========

--- replace with specific information about the meta-serena-layer layer ---


add this layer by running

```
bitbake-layers add-layer ../meta-serena-layer

```


# cross Compile

```
sudo apt install gcc-aarch64-linux-gnu
aarch64-linux-gnu-gcc -O2 -Wall gpio_toggle.c -o gpio_toggle
```

# connect through ssh

```
sudo ip addr add 192.168.1.11/24 dev end0
sudo ip link set end0 down
sudo ip link set end0 up
```

if connecting from windows make sure to allow connection from firewall and configure ip and submask properly

## myaccip usage
```
gcc -O2 -Wall -o myaccip_uio myaccip_uio.c

./myaccip_uio /dev/uio0 read version
./myaccip_uio /dev/uio0 read status
./myaccip_uio /dev/uio0 write control 0x1
./myaccip_uio /dev/uio0 dump
```