TARGET = iphone:clang::13.0
ARCHS = arm64 arm64e

SYSROOT = $(THEOS)/sdks/iPhoneOS13.6.sdk

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HomeScreenQuickActionsSettings

$(BUNDLE_NAME)_FILES = HomeScreenQuickActionsRootSettings.mm HomeScreenQuickActionsSearchableListController.mm HomeScreenQuickActionsApplicationSpecificQuickActions.mm HomeScreenQuickActionsRenameSettings.mm
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)
