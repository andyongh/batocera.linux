################################################################################
#
# batocera shaders
#
################################################################################

BATOCERA_SHADERS_VERSION = 1.0
BATOCERA_SHADERS_SOURCE=
BATOCERA_SHADERS_DEPENDENCIES= glsl-shaders

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_X86)$(BR2_PACKAGE_BATOCERA_TARGET_X86_64_ANY),y)
	BATOCERA_GPU_SYSTEM=x86
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RISCV),y)
	BATOCERA_GPU_SYSTEM=riscv
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_BCM2835)$(BR2_PACKAGE_BATOCERA_TARGET_BCM2836)$(BR2_PACKAGE_BATOCERA_TARGET_BCM2837),y)
	BATOCERA_GPU_SYSTEM=vc4
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_BCM2711),y)
	BATOCERA_GPU_SYSTEM=vc5
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_XU4),y)
	BATOCERA_GPU_SYSTEM=mali-t628
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812)$(BR2_PACKAGE_BATOCERA_TARGET_S905),y)
	BATOCERA_GPU_SYSTEM=mali-450
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S912),y)
	BATOCERA_GPU_SYSTEM=mali-t820
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S905GEN2)$(BR2_PACKAGE_BATOCERA_TARGET_S905GEN3),y)
	BATOCERA_GPU_SYSTEM=mali-g31
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
	BATOCERA_GPU_SYSTEM=mali-g52
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3128)$(BR2_PACKAGE_BATOCERA_TARGET_RK3328),y)
	BATOCERA_GPU_SYSTEM=mali-400
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3288),y)
	BATOCERA_GPU_SYSTEM=mali-t760
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3399),y)
	BATOCERA_GPU_SYSTEM=mali-t860
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3568),y)
	BATOCERA_GPU_SYSTEM=mali-g52
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3588),y)
	BATOCERA_GPU_SYSTEM=mali-g610
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_H3),y)
	BATOCERA_GPU_SYSTEM=mali-400
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_H5),y)
	BATOCERA_GPU_SYSTEM=mali-450
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_H6),y)
	BATOCERA_GPU_SYSTEM=mali-t720
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_H616),y)
	BATOCERA_GPU_SYSTEM=mali-g31
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ODIN),y)
	BATOCERA_GPU_SYSTEM=adreno-630
endif

BATOCERA_SHADERS_DIRIN=$(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/retroarch/shaders/batocera-shaders/configs

ifeq ($(BATOCERA_GPU_SYSTEM),x86)
	BATOCERA_SHADERS_SETS=sharp-bilinear-simple retro scanlines enhanced curvature zfast flatten-glow mega-bezel mega-bezel-lite mega-bezel-ultralite
else
	BATOCERA_SHADERS_SETS=sharp-bilinear-simple retro scanlines enhanced curvature zfast flatten-glow
endif

define BATOCERA_SHADERS_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/batocera/shaders/bezel/Mega_Bezel/Presets
	cp -R $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/retroarch/shaders/batocera-shaders/presets-batocera/* $(TARGET_DIR)/usr/share/batocera/shaders/bezel/Mega_Bezel/Presets

	# general
    mkdir -p $(TARGET_DIR)/usr/share/batocera/shaders/configs
	cp $(BATOCERA_SHADERS_DIRIN)/rendering-defaults.yml           $(TARGET_DIR)/usr/share/batocera/shaders/configs/
	if test -e $(BATOCERA_SHADERS_DIRIN)/rendering-defaults-$(BATOCERA_GPU_SYSTEM).yml; then \
		cp $(BATOCERA_SHADERS_DIRIN)/rendering-defaults-$(BATOCERA_GPU_SYSTEM).yml $(TARGET_DIR)/usr/share/batocera/shaders/configs/rendering-defaults-arch.yml; \
	fi

	# sets
	for set in $(BATOCERA_SHADERS_SETS); do \
		mkdir -p $(TARGET_DIR)/usr/share/batocera/shaders/configs/$$set; \
		cp $(BATOCERA_SHADERS_DIRIN)/$$set/rendering-defaults.yml     $(TARGET_DIR)/usr/share/batocera/shaders/configs/$$set/; \
		if test -e $(BATOCERA_SHADERS_DIRIN)/$$set/rendering-defaults-$(BATOCERA_GPU_SYSTEM).yml; then \
			cp $(BATOCERA_SHADERS_DIRIN)/$$set/rendering-defaults-$(BATOCERA_GPU_SYSTEM).yml $(TARGET_DIR)/usr/share/batocera/shaders/configs/$$set/rendering-defaults-arch.yml; \
		fi \
	done
endef

$(eval $(generic-package))
