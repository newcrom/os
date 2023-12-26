bash
cd ~/os
. sources/poky/oe-init-build-env build
git pull

MACHINE="raspberrypi3-64" bitbake update-bundle
aws s3 cp tmp/deploy/images/raspberrypi3-64/update-bundle-raspberrypi3-64.raucb s3://get.chrom.app/