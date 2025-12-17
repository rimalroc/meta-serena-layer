SUMMARY = "No-IRQ UIO driver for myaccip"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "file://uio_myaccip_noirq.c \
           file://Makefile \
"

S = "${WORKDIR}"

# Ensure the module loads on boot (optional but usually desired)
KERNEL_MODULE_AUTOLOAD:${PN} = "uio_myaccip_noirq"

# If you prefer manual load, omit the line above.