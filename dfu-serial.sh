#!/bin/bash

HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

BOARD=mimxrt1050_evk
TTY=/dev/ttyUSB2
BAUD=115200

(
        cd $HERE/..

        if [ -z "$1" ]; then
                west build -p always -b $BOARD -d build_bl \
                bootloader/mcuboot/boot/zephyr

                west build -p always -b $BOARD -d build_dfu_serial \
                zephyr/samples/subsys/mgmt/mcumgr/smp_svr -- \
                -DOVERLAY_CONFIG='overlay-serial.conf' -DCONFIG_BOOTLOADER_MCUBOOT=y \
                -DCONFIG_MCUBOOT_SIGNATURE_KEY_FILE=\"bootloader/mcuboot/root-rsa-2048.pem\" \
                -DCONFIG_IMG_ERASE_PROGRESSIVELY=y

                west flash -d build_bl
                west flash -d build_dfu_serial

                sleep 2
        fi

        mcumgr --conntype serial --connstring "$TTY,baud=$BAUD" image list
        mcumgr --conntype serial --connstring "$TTY,baud=$BAUD" image upload \
        build_dfu_serial/zephyr/zephyr.signed.bin
)

