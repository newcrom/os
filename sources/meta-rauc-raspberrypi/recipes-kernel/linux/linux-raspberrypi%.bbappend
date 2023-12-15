FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit rauc-integration

SRC_URI:append = " file://rauc.cfg"
CMDLINE:remove = "root=/dev/mmcblk0p2"
