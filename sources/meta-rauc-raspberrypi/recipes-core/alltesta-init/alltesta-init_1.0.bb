DESCRIPTION = "Alltesta initialization script and service"
LICENSE = "CLOSED"

inherit systemd

FILESEXTRAPATHS:prepend:${PN}-service := "${THISDIR}/files:"

PACKAGES =+ "${PN}-service"
SYSTEMD_SERVICE:${PN}-service = "alltesta-init.service"
SYSTEMD_PACKAGES = "${PN}-service"
SYSTEMD_AUTO_ENABLE = "enable"


SRC_URI:append = "file://alltesta-init.sh"
SRC_URI:append = "file://alltesta-init.service"

S = "${WORKDIR}"


do_install:append() {
    install -d ${D}${bindir}/
    install -m 0755 ${WORKDIR}/alltesta-init.sh ${D}${bindir}/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/alltesta-init.service ${D}${systemd_unitdir}/system/
}


FILES:${PN}-service = " \
    ${bindir}/alltesta-init.sh \
    ${systemd_unitdir}/system/alltesta-init.service \
"