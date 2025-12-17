// SPDX-License-Identifier: GPL-2.0
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <linux/ioport.h>
#include <linux/uio_driver.h>

struct myaccip_uio {
    struct uio_info info;
};

static int myaccip_uio_probe(struct platform_device *pdev)
{
    struct resource *res;
    struct myaccip_uio *priv;

    priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
    if (!priv)
        return -ENOMEM;

    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
    if (!res) {
        dev_err(&pdev->dev, "no IORESOURCE_MEM\n");
        return -ENODEV;
    }

    priv->info.name = dev_name(&pdev->dev);
    priv->info.version = "noirq-uio-1.0";
    priv->info.irq = UIO_IRQ_NONE;

    priv->info.mem[0].name = "regs";
    priv->info.mem[0].addr = res->start;
    priv->info.mem[0].size = resource_size(res);
    priv->info.mem[0].memtype = UIO_MEM_PHYS;

    platform_set_drvdata(pdev, priv);
    return uio_register_device(&pdev->dev, &priv->info);
}

static int myaccip_uio_remove(struct platform_device *pdev)
{
    struct myaccip_uio *priv = platform_get_drvdata(pdev);
    uio_unregister_device(&priv->info);
    return 0;
}

static const struct of_device_id myaccip_uio_of_match[] = {
    { .compatible = "xlnx,myaccip-2.0" },
    { /* sentinel */ }
};
MODULE_DEVICE_TABLE(of, myaccip_uio_of_match);

static struct platform_driver myaccip_uio_driver = {
    .probe  = myaccip_uio_probe,
    .remove = myaccip_uio_remove,
    .driver = {
        .name = "uio-myaccip-noirq",
        .of_match_table = myaccip_uio_of_match,
    },
};

module_platform_driver(myaccip_uio_driver);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("No-IRQ UIO driver for xlnx,myaccip-2.0");
