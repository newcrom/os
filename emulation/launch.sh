#!/bin/bash


qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a53 \
    -D ./log.txt \
    -append "$(cat /home/ssm-user/os/build/tmp/deploy/images/raspberrypi3-64/bootfiles/cmdline.txt)" \
    -dtb  /home/ssm-user/os/build/tmp/deploy/images/raspberrypi3-64/bcm2710-rpi-3-b-plus.dtb \
    -drive format=raw,file=/home/ssm-user/os/build/tmp/deploy/images/raspberrypi3-64/core-image-full-cmdline-raspberrypi3-64.rootfs-20231122164440.ext4 \
    -kernel /home/ssm-user/os/build/tmp/deploy/images/raspberrypi3-64/Image-raspberrypi3-64.bin \
    -m 1G -smp 4 \
    -nographic
