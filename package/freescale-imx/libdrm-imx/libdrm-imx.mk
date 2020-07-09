################################################################################
#
# libdrm-imx
#
################################################################################

LIBDRM_IMX_VERSION = rel_imx_5.4.24_2.1.0
LIBDRM_IMX_SITE = https://source.codeaurora.org/external/imx/libdrm-imx
LIBDRM_IMX_SITE_METHOD = git
LIBDRM_IMX_LICENSE = GPL-2.0+
LIBDRM_IMX_DEPENDENCIES += host-automake host-autoconf host-libtool host-xutil_util-macros

LIBDRM_IMX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS)

ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
LIBDRM_IMX_TARGET_NAME = $(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX))
else
ifeq ($(BR2_aarch64),y)
LIBDRM_IMX_TARGET_NAME = aarch64-buildroot-linux-gnu
else
LIBDRM_IMX_TARGET_NAME = arm-buildroot-linux-gnueabihf
endif
endif

define LIBDRM_IMX_CONFIGURE_CMDS
	cd $(@D) && $(LIBDRM_IMX_MAKE_ENV) \
	./autogen.sh --disable-vc4 --enable-vivante-experimental-api --disable-freedreno \
	--disable-vmwgfx --disable-nouveau --disable-amdgpu --disable-radeon \
	--disable-intel --enable-etnaviv-experimental-api --host=$(LIBDRM_IMX_TARGET_NAME)
endef

define LIBDRM_IMX_BUILD_CMDS
	$(LIBDRM_IMX_MAKE_ENV) $(MAKE) $(TARGET_MAKE_OPTS) -C $(@D)
endef

define LIBDRM_IMX_INSTALL_TARGET_CMDS
	cp $(@D)/.libs/libdrm.so.2.4.0 $(TARGET_DIR)/usr/lib/
	cd $(TARGET_DIR)/usr/lib/ && ln -s libdrm.so.2.4.0 libdrm.so
	cd $(TARGET_DIR)/usr/lib/ && ln -s libdrm.so.2.4.0 libdrm.so.2
endef

$(eval $(generic-package))
