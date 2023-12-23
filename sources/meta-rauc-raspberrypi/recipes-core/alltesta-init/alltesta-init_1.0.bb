DESCRIPTION = "Alltesta initialization script and service"
LICENSE = "CLOSED"

inherit systemd

PACKAGES =+ "${PN}-service"
SYSTEMD_SERVICE:${PN}}-service = "alltesta-init.service"
SYSTEMD_PACKAGES = "${PN}-service"
SYSTEMD_AUTO_ENABLE = "enable"


SRC_URI = "file://alltesta-init.sh \
           file://alltesta-init.service"


do_install:append() {
    install -d ${D}/usr/local/bin
    install -m 0755 ${WORKDIR}/alltesta-init.sh ${D}${bindir}/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/alltesta-init.service ${D}${systemd_unitdir}/system/
}

FILES:${PN}-service = " \
    ${bindir}/alltesta-init.sh \
    ${systemd_unitdir}/system/alltesta-init.service \
"