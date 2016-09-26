include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ClassicShutterAnimation
ClassicShutterAnimation_FILES = FGARootListController.m
ClassicShutterAnimation_INSTALL_PATH = /Library/PreferenceBundles
ClassicShutterAnimation_FRAMEWORKS = UIKit
ClassicShutterAnimation_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ClassicShutterAnimation.plist$(ECHO_END)
