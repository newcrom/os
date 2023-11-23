#!/bin/bash


qemu-system-aarch64 \
    -M raspi3b \
    -cpu cortex-a72 \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -dtb bcm2710-rpi-3-b-plus.dtb \
    -sd disk.img \
    -kernel /home/ssm-user/os/build/tmp/deploy/images/raspberrypi3-64/core-image-full-cmdline-raspberrypi3-64.rootfs-20231122164440.ext4 \
    -m 1G -smp 4 \
    -serial stdio \
    -usb -device usb-mouse -device usb-kbd \
	-device usb-net,netdev=net0 \
	-netdev user,id=net0,hostfwd=tcp::5555-:22 \
