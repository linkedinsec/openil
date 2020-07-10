################################################################################
#
# wayland-protocols-imx
#
################################################################################

WAYLAND_PROTOCOLS_IMX_VERSION = rel_imx_5.4.24_2.1.0
WAYLAND_PROTOCOLS_IMX_SITE = https://source.codeaurora.org/external/imx/wayland-protocols-imx
WAYLAND_PROTOCOLS_IMX_SITE_METHOD = git
WAYLAND_PROTOCOLS_IMX_LICENSE = GPL-2.0+
WAYLAND_PROTOCOLS_IMX_DEPENDENCIES += host-automake host-autoconf host-libtool host-xutil_util-macros

WAYLAND_PROTOCOLS_IMX_MAKE_ENV = \
        $(TARGET_MAKE_ENV) \
        $(TARGET_CONFIGURE_OPTS) \
        $(TARGET_CONFIGURE_ARGS)

ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
WAYLAND_PROTOCOLS_IMX_TARGET_NAME = $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX))
else
ifeq ($(BR2_aarch64),y)
WAYLAND_PROTOCOLS_IMX_TARGET_NAME = aarch64-buildroot-linux-gnu
else
WAYLAND_PROTOCOLS_IMX_TARGET_NAME = arm-buildroot-linux-gnueabihf
endif
endif

define WAYLAND_PROTOCOLS_IMX_CONFIGURE_CMDS
	cd $(@D) && $(WAYLAND_PROTOCOLS_IMX_MAKE_ENV) \
	./autogen.sh --host=$(WAYLAND_PROTOCOLS_IMX_TARGET_NAME)
endef

define WAYLAND_PROTOCOLS_IMX_INSTALL_TARGET_CMDS
        $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
