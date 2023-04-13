#!/bin/bash

HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

BOARD=mimxrt1050_evk

reset()
{
        JLinkExe -nogui 1 -if swd -speed auto -device MCIMXRT1052 \
        -CommanderScript $HERE/test.jlink > /dev/null
        sleep 10
}

(
        cd $HERE/..
        for i in $(seq 20); do
                echo "Run $i of 20"
                for j in $(seq 4); do
                        echo "Transfer $j of 4"
                        if ! sudo dfu-util --alt 1 --download build_hello_world/zephyr/zephyr.signed.bin; then
                                echo "dfu-util failed"
                                exit 1
                        fi
                done
                echo "Apply update"
                reset
                echo "Revert update"
                reset
        done
)
