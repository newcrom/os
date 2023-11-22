FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://raspberrypi-rauc.rules"

do_install:append:rpi() {
    install -m 0644 ${WORKDIR}/raspberrypi-rauc.rules ${D}${sysconfdir}/udev/mount.blacklist.d/
}
