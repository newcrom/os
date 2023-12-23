DESCRIPTION = "Alltesta initialization script and service"
LICENSE = "CLOSED"

# Prepend the current directory's files directory to FILESEXTRAPATHS
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "alltesta-init.service"

SRC_URI = "file://alltesta-init.sh \
           file://alltesta-init.service"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/local/bin
    install -m 0755 ${WORKDIR}/alltesta-init.sh ${D}/usr/local/bin/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/alltesta-init.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} += "/usr/local/bin/alltesta-init.sh \
                /etc/systemd/system/alltesta-init.service"
