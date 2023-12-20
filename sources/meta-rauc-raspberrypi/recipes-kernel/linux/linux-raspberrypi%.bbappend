FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit rauc-integration

SRC_URI:append = " file://rauc.cfg"
SRC_URI:append = " file://wifi.cfg"
CMDLINE:remove = "root=/dev/mmcblk0p2"
