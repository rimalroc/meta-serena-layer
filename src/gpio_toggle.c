#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>

/* From kernel uapi: include/uapi/linux/gpio.h */
#include <linux/gpio.h>

#define GPIO_CHIP_DEV    "/dev/gpiochip1"   /* PL AXI GPIO */
#define GPIO_LINE_OFFSET 0                  /* the only line on this chip */

int main(void)
{
    int chip_fd, ret;
    struct gpiochip_info cinfo;
    struct gpiohandle_request req;
    struct gpiohandle_data data;

    chip_fd = open(GPIO_CHIP_DEV, O_RDONLY);
    if (chip_fd < 0) {
        perror("open gpiochip");
        return EXIT_FAILURE;
    }

    /* Optional: query chip info */
    memset(&cinfo, 0, sizeof(cinfo));
    ret = ioctl(chip_fd, GPIO_GET_CHIPINFO_IOCTL, &cinfo);
    if (ret < 0) {
        perror("GPIO_GET_CHIPINFO_IOCTL");
        close(chip_fd);
        return EXIT_FAILURE;
    }
    printf("Chip: %s, label: %s, lines: %u\n",
           cinfo.name, cinfo.label, cinfo.lines);

    /* Request one line as OUTPUT, default low */
    memset(&req, 0, sizeof(req));
    req.lineoffsets[0] = GPIO_LINE_OFFSET;
    req.flags = GPIOHANDLE_REQUEST_OUTPUT;
    req.lines = 1;
    req.default_values[0] = 0;
    snprintf(req.consumer_label, sizeof(req.consumer_label),
             "axi-gpio-test");

    ret = ioctl(chip_fd, GPIO_GET_LINEHANDLE_IOCTL, &req);
    if (ret < 0) {
        perror("GPIO_GET_LINEHANDLE_IOCTL");
        close(chip_fd);
        return EXIT_FAILURE;
    }

    printf("Controlling line %d on %s\n",
           GPIO_LINE_OFFSET, GPIO_CHIP_DEV);

    /* Drive LOW */
    memset(&data, 0, sizeof(data));
    data.values[0] = 0;
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    if (ret < 0) perror("SET low"); else printf("Set LOW\n");
    sleep(1);

    /* Drive HIGH */
    data.values[0] = 1;
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    if (ret < 0) perror("SET high"); else printf("Set HIGH\n");
    sleep(1);

    /* Drive LOW again */
    data.values[0] = 0;
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    if (ret < 0) perror("SET low again"); else printf("Set LOW again\n");

    close(req.fd);
    close(chip_fd);
    return EXIT_SUCCESS;
}
