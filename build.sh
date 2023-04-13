#!/bin/bash

HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

BOARD=mimxrt1050_evk

(
        cd $HERE/..

        if [ -z "$1" ]; then
                west build -b $BOARD -d build_bl bootloader/mcuboot/boot/zephyr \
                -DCONFIG_IMG_ERASE_PROGRESSIVELY=y

                west build -b $BOARD -d build zephyr/samples/subsys/usb/dfu -- \
                -DCONFIG_MCUBOOT_SIGNATURE_KEY_FILE=\"bootloader/mcuboot/root-rsa-2048.pem\" \
                -DCONFIG_SHELL=y \
                -DCONFIG_FLASH_SHELL=y \
                -DCONFIG_FLASH_MAP=y \
                -DCONFIG_IMG_ERASE_PROGRESSIVELY=y \
                -DCONFIG_ASSERT=y

                west build -b $BOARD -d build_hello_world zephyr/samples/hello_world -- \
                -DCONFIG_MCUBOOT_SIGNATURE_KEY_FILE=\"bootloader/mcuboot/root-rsa-2048.pem\" \
                -DCONFIG_BOOTLOADER_MCUBOOT=y

                west flash -d build_bl
                west flash -d build
        fi
)
