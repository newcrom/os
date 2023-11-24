

# # systemd provides home.mount unit
# OVERLAYFS_MOUNT_POINT[home] = "/data"
# OVERLAYFS_WRITABLE_PATHS[home] = "/home"
#
# # systemd provides var-lib.mount unit
# OVERLAYFS_MOUNT_POINT[var-lib] = "/data"
# OVERLAYFS_WRITABLE_PATHS[var-lib] = "/var/lib/"
#
# OVERLAYFS_MOUNT_POINT[data] ?= "/data"