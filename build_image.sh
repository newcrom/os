bash
cd ~/os
. sources/poky/oe-init-build-env build
git pull

MACHINE="raspberrypi3-64" bitbake core-image-full-cmdline
aws s3 cp tmp/deploy/images/raspberrypi3-64/core-image-full-cmdline-raspberrypi3-64.rootfs.wic.bz2 s3://newcrom-build-server/



