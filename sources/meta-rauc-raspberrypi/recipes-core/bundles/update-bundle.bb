DESCRIPTION = "Bundle generator"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "RaspberryPiCM3+"
RAUC_BUNDLE_VERSION = "v20231125"
RAUC_BUNDLE_DESCRIPTION = "Alltesta Bundle"
RAUC_BUNDLE_SLOTS = "rootfs" 
RAUC_SLOT_rootfs = "core-image-minimal"
RAUC_SLOT_rootfs[fstype] = "ext4"

RAUC_KEY_FILE = "${THISDIR}/files/development-1.key.pem"
RAUC_CERT_FILE = "${THISDIR}/files/development-1.cert.pem"
