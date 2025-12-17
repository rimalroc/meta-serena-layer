This README file contains information on the contents of the meta-serena-layer layer.


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



# cross Compile the scripts to control

```
sudo apt install gcc-aarch64-linux-gnu
cd src
make

```

This creates the following utilities

| Utility          | Controls              | Interface          | Scope |
| ---------------- | --------------------- | ------------------ | ----- |
| `gpio_toggle`    | AXI GPIO (PL)         | MMIO               | PL    |
| `ps_gpio_toggle` | PS GPIO (MIO)         | Linux GPIO (gpiod) | PS    |
| `mempeek`        | Arbitrary MMIO        | `/dev/mem`         | PS/PL |
| `myaccip_uio`    | Custom accelerator IP | UIO                | PL    |

- gpio_toggle

Controls an AXI GPIO instantiated in the programmable logic (PL).
Uses memory-mapped I/O to configure direction and toggle output pins.
Primarily intended for validating AXI connectivity, clocks, and PL GPIO behavior.

- ps_gpio_toggle

Controls PS GPIOs connected to MIO pins using the Linux GPIO subsystem.
Operates through the kernel GPIO driver (libgpiod), not via MMIO.
Useful for validating PS pinmux and basic board-level I/O.

- mempeek

Generic MMIO read/write utility using /dev/mem.
Allows direct access to arbitrary physical addresses for bring-up and debugging.

⚠️ Warning: Incorrect access can crash or hang the system. Use only during development.

- myaccip_uio

Userspace access tool for the custom accelerator IP via UIO.
Maps the accelerator’s register space through /dev/uioX and supports structured register access.
Preferred alternative to /dev/mem once the UIO kernel module is loaded.

## myaccip usage
```
gcc -O2 -Wall -o myaccip_uio myaccip_uio.c

./myaccip_uio /dev/uio4 read version
./myaccip_uio /dev/uio4 read status
./myaccip_uio /dev/uio4 write control 0x1
./myaccip_uio /dev/uio4 dump
```

# connect through ssh
The default configuration is dhcp, so if you connect point to point and don't provide dhcp server you can set fixed IP.

Using the serial terminal
```
sudo ip addr add 192.168.1.11/24 dev end0
sudo ip link set end0 down
sudo ip link set end0 up
```

> if connecting from windows make sure to allow connection from firewall and configure ip and submask properly

# Check the firmware module is accesible

Quick Bring-Up Checks (using /dev/mem)

Confirm the device is enumerated by Linux
```
ls /sys/bus/platform/devices | grep -i myaccip
```

The device should appear (e.g. 80020000.myaccip).
If it does not, the hardware description / device tree is not loaded.

Verify the physical address and size
```
hexdump -Cv /sys/bus/platform/devices/80020000.myaccip/of_node/reg
```

Confirm the base address (e.g. 0x80020000) and register window size.

Check that /dev/mem is available
```
ls -l /dev/mem
```

Must be present and accessible as root.

Perform a simple register read
```
devmem 0x80020000 32
```

A stable, non-faulting read indicates the address is reachable.

Write and read back a control register
```
devmem 0x80020004 32 0x1
devmem 0x80020004 32
```

Matching readback confirms basic MMIO access.

Control the device using a test utility
```
./mempeek
```

Successful operation here confirms clocks, resets, and AXI connectivity.

⚠️ Warning: /dev/mem bypasses all driver safety checks. Writing incorrect addresses can hang or crash the system. Use only for bring-up and debugging.

# Build kernel module
The file ` recipes-core/images/petalinux-image-minimal.bbappend` intentionally comments the kernel module to prove how to build the module afterwards and load it. you can uncomment it and rerun the building of the image from scratch or...

In the bitbake environment
```
bitbake -c cleansstate myaccip-uio-noirq
bitbake myaccip-uio-noirq
```
> will typically build it in something like `./tmp/work/refdes_xu3_st3_xczu2cg-xilinx-linux/myaccip-uio-noirq/1.0/packages-split/kernel-module-uio-myaccip-noirq-6.6.40-xilinx-ga0c9f2b17023/usr/lib/modules/6.6.40-xilinx-ga0c9f2b17023/updates/uio_myaccip_noirq.ko`

copy the `uio_myaccip_noirq.ko` to `/lib/modules/6.6.40-xilinx-*/` and load the modules

```
ls -l /dev/uio*
modprobe uio
modprobe /lib/modules/6.6.40-xilinx-*/uio_myaccip_noirq.ko
lsmod
ls -l /dev/uio*
```

You should see a new /dev/uio, that's your module.
Now you can use the `myaccip_uio` utility.