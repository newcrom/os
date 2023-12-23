DESCRIPTION = "wiringPi 2.50"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend:${PN} := "${THISDIR}/files:"

SRC_URI = "file://libwiringPi.so"
SRC_URI:append = "file://libwiringPiDev.so"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/lib

    cp ${WORKDIR}/libwiringPi.so ${D}/usr/lib
    cp ${WORKDIR}/libwiringPiDev.so ${D}/usr/lib
}

FILES:${PN} += "/usr/lib/libwiringPi.so"
FILES:${PN} += "/usr/lib/libwiringPiDev.so"