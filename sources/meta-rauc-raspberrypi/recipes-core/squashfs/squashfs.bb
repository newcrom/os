LICENSE = "MIT"

inherit overlayfs overlayfs-etc

OVERLAYFS_ETC_MOUNT_POINT = "/data"
OVERLAYFS_ETC_DEVICE = "/dev/mmcblk0p4"
OVERLAYFS_ETC_FSTYPE = "ext4"
OVERLAYFS_ETC_USE_ORIG_INIT_NAME = "0"

# systemd provides home.mount unit
OVERLAYFS_MOUNT_POINT[home] = "/data"
OVERLAYFS_WRITABLE_PATHS[home] = "/home"

# systemd provides var-lib-cloud.mount unit
OVERLAYFS_MOUNT_POINT[var-lib] = "/data"
OVERLAYFS_WRITABLE_PATHS[var-lib] = "/var/lib/"



OVERLAYFS_MOUNT_POINT[data] ?= "/data"