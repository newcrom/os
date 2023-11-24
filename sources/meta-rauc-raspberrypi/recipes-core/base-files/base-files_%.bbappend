#Add a mount point for a shared data partition
dirs755 += "/data"

do_install_append () {
   install -d ${D}/data/var
   install -d ${D}/data/etc
}