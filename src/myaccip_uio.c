#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

enum {
    REG_VERSION  = 0x00,
    REG_CONTROL  = 0x04,
    REG_STATUS   = 0x08,
    REG_CFG0     = 0x0C,
};

static inline uint32_t mmio_read32(volatile uint8_t *base, uint32_t off)
{
    return *(volatile uint32_t *)(base + off);
}

static inline void mmio_write32(volatile uint8_t *base, uint32_t off, uint32_t v)
{
    *(volatile uint32_t *)(base + off) = v;
}

static int parse_reg(const char *s, uint32_t *off_out)
{
    if (!strcmp(s, "version")) { *off_out = REG_VERSION; return 0; }
    if (!strcmp(s, "control")) { *off_out = REG_CONTROL; return 0; }
    if (!strcmp(s, "status"))  { *off_out = REG_STATUS;  return 0; }
    if (!strcmp(s, "cfg0"))    { *off_out = REG_CFG0;    return 0; }

    /* Allow numeric offsets: "0x08" */
    char *end = NULL;
    unsigned long v = strtoul(s, &end, 0);
    if (end && *end == '\0') {
        *off_out = (uint32_t)v;
        return 0;
    }
    return -1;
}

static void usage(const char *p)
{
    fprintf(stderr,
        "Usage:\n"
        "  %s /dev/uioX read  <regname|offset>\n"
        "  %s /dev/uioX write <regname|offset> <value>\n"
        "  %s /dev/uioX dump\n"
        "\n"
        "Reg names: version, control, status, cfg0\n"
        "Offsets may be numeric (e.g. 0x10).\n",
        p, p, p);
}

int main(int argc, char **argv)
{
    if (argc < 3) { usage(argv[0]); return 2; }

    const char *uio = argv[1];
    const char *cmd = argv[2];

    int fd = open(uio, O_RDWR | O_SYNC);
    if (fd < 0) {
        fprintf(stderr, "open(%s) failed: %s\n", uio, strerror(errno));
        return 1;
    }

    /* Map one page. If your map is larger, increase to sysfs map0/size. */
    size_t map_size = 0x1000;

    volatile uint8_t *base = mmap(NULL, map_size, PROT_READ | PROT_WRITE,
                                  MAP_SHARED, fd, 0);
    if (base == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        close(fd);
        return 1;
    }

    if (!strcmp(cmd, "read")) {
        if (argc != 4) { usage(argv[0]); return 2; }
        uint32_t off;
        if (parse_reg(argv[3], &off) != 0) {
            fprintf(stderr, "Unknown reg '%s'\n", argv[3]);
            return 2;
        }
        uint32_t v = mmio_read32(base, off);
        printf("read  [0x%02" PRIx32 "] = 0x%08" PRIx32 "\n", off, v);

    } else if (!strcmp(cmd, "write")) {
        if (argc != 5) { usage(argv[0]); return 2; }
        uint32_t off;
        if (parse_reg(argv[3], &off) != 0) {
            fprintf(stderr, "Unknown reg '%s'\n", argv[3]);
            return 2;
        }
        uint32_t v = (uint32_t)strtoul(argv[4], NULL, 0);
        mmio_write32(base, off, v);
        uint32_t rb = mmio_read32(base, off);
        printf("write [0x%02" PRIx32 "] = 0x%08" PRIx32 " (readback 0x%08" PRIx32 ")\n",
               off, v, rb);

    } else if (!strcmp(cmd, "dump")) {
        /* Dump the first 64 32-bit regs (0x00..0xFC) */
        for (unsigned i = 0; i < 64; i++) {
            uint32_t off = i * 4;
            uint32_t v = mmio_read32(base, off);
            printf("R[%02u] @0x%02" PRIx32 " = 0x%08" PRIx32 "\n", i, off, v);
        }

    } else {
        usage(argv[0]);
        return 2;
    }

    /* IRQ placeholder:
     * When you later enable uio_pdrv_genirq, you will typically:
     *   uint32_t irqcount;
     *   read(fd, &irqcount, sizeof(irqcount));  // blocks until IRQ
     *   ... ack/clear in your device regs ...
     *   write(fd, &irqcount, sizeof(irqcount)); // re-enable (driver-specific)
     */

    munmap((void *)base, map_size);
    close(fd);
    return 0;
}
