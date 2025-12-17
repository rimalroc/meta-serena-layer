#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define BASE_ADDR  0x80020000UL
#define MAP_SIZE   0x1000          /* adjust if your register window is larger */

static inline uint32_t mmio_read32(volatile uint8_t *base, uint32_t off)
{
    return *(volatile uint32_t *)(base + off);
}

static inline void mmio_write32(volatile uint8_t *base, uint32_t off, uint32_t v)
{
    *(volatile uint32_t *)(base + off) = v;
}

int main(int argc, char **argv)
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open(/dev/mem)");
        return 1;
    }

    volatile uint8_t *base = mmap(NULL, MAP_SIZE,
                                  PROT_READ | PROT_WRITE,
                                  MAP_SHARED, fd, BASE_ADDR);
    if (base == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 1;
    }

    printf("VERSION  @0x00 = 0x%08" PRIx32 "\n", mmio_read32(base, 0x00));
    printf("STATUS   @0x08 = 0x%08" PRIx32 "\n", mmio_read32(base, 0x08));

    printf("Writing CONTROL = 0x1\n");
    mmio_write32(base, 0x04, 0x1);
    printf("CONTROL  readback = 0x%08" PRIx32 "\n", mmio_read32(base, 0x04));
    usleep(500000);
    mmio_write32(base, 0x04, 0x0);
    printf("CONTROL  readback = 0x%08" PRIx32 "\n", mmio_read32(base, 0x04));
    usleep(300000);
    munmap((void *)base, MAP_SIZE);
    close(fd);
    return 0;
}
