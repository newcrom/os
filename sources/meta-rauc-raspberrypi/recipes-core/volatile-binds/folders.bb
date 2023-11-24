SUMMARY = "Edit project directory structure"
LICENSE = "MIT"
PV = "1.0"

S = "${WORKDIR}"

inherit allarch

do_install () {
        install -d ${D}/data/var
}

FILES_${PN} = "/data/var"