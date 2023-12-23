DESCRIPTION = "Alltesta initialization script and service"
LICENSE = "CLOSED"

inherit systemd

FILESEXTRAPATHS:prepend:${PN}-service := "${THISDIR}/files:"

PACKAGES =+ "${PN}-service"
SYSTEMD_SERVICE:${PN}-service = "alltesta-init.service"
SYSTEMD_PACKAGES = "${PN}-service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN}-service += "bash"


SRC_URI = "file://alltesta-init.sh"
SRC_URI:append = " file://device-get-serial.py"
SRC_URI:append = " file://config.yaml"
SRC_URI:append = " file://alltesta-init.service"

S = "${WORKDIR}"


do_install:append() {
    install -d ${D}${bindir}/
    install -m 0755 ${WORKDIR}/alltesta-init.sh ${D}${bindir}/

    install -m 0755 ${WORKDIR}/device-get-serial.py ${D}${bindir}/

    install -d ${D}/etc/rancher/k3s/
    install -m 0755 ${WORKDIR}/config.yaml ${D}/etc/rancher/k3s/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/alltesta-init.service ${D}${systemd_unitdir}/system/
}


FILES:${PN}-service = " \
    ${bindir}/alltesta-init.sh \
    ${bindir}/device-get-serial.py \
    /etc/rancher/k3s/config.yaml \
    ${systemd_unitdir}/system/alltesta-init.service \
"