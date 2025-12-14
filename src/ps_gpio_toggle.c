#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>

#include <linux/gpio.h>   /* from your toolchain's kernel headers */

#define GPIO_CHIP_DEV      "/dev/gpiochip2"  /* ZynqMP PS GPIO */
#define LED0_LINE_OFFSET   42                /* MIO42 */
#define LED1_LINE_OFFSET   43                /* MIO43 */

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

    memset(&cinfo, 0, sizeof(cinfo));
    ret = ioctl(chip_fd, GPIO_GET_CHIPINFO_IOCTL, &cinfo);
    if (ret < 0) {
        perror("GPIO_GET_CHIPINFO_IOCTL");
        close(chip_fd);
        return EXIT_FAILURE;
    }
    printf("Chip: %s, label: %s, lines: %u\n",
           cinfo.name, cinfo.label, cinfo.lines);

    memset(&req, 0, sizeof(req));
    req.lines = 2;
    req.lineoffsets[0] = LED0_LINE_OFFSET;
    req.lineoffsets[1] = LED1_LINE_OFFSET;
    req.flags = GPIOHANDLE_REQUEST_OUTPUT;
    req.default_values[0] = 0;   /* LED0 off */
    req.default_values[1] = 0;   /* LED1 off */
    snprintf(req.consumer_label, sizeof(req.consumer_label),
             "ps-leds-test");

    ret = ioctl(chip_fd, GPIO_GET_LINEHANDLE_IOCTL, &req);
    if (ret < 0) {
        perror("GPIO_GET_LINEHANDLE_IOCTL");
        close(chip_fd);
        return EXIT_FAILURE;
    }

    printf("Controlling MIO%d and MIO%d via %s\n",
           LED0_LINE_OFFSET, LED1_LINE_OFFSET, GPIO_CHIP_DEV);

    memset(&data, 0, sizeof(data));

    /* Both OFF */
    data.values[0] = 0;
    data.values[1] = 0;
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    if (ret < 0) perror("SET both low");
    printf("Both LEDs OFF\n");
    sleep(1);

    /* Both ON */
    data.values[0] = 1;
    data.values[1] = 1;
    ret = ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    if (ret < 0) perror("SET both high");
    printf("Both LEDs ON\n");
    sleep(1);

    /* Alternate blink a few times */
    for (int i = 0; i < 5; ++i) {
        data.values[0] = 1;
        data.values[1] = 0;
        ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
        printf("LED0 ON, LED1 OFF\n");
        usleep(300000);

        data.values[0] = 0;
        data.values[1] = 1;
        ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
        printf("LED0 OFF, LED1 ON\n");
        usleep(300000);
    }

    /* Finish both OFF */
    data.values[0] = 0;
    data.values[1] = 0;
    ioctl(req.fd, GPIOHANDLE_SET_LINE_VALUES_IOCTL, &data);
    printf("Both LEDs OFF (done)\n");

    close(req.fd);
    close(chip_fd);
    return EXIT_SUCCESS;
}
