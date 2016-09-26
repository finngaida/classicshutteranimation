include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ClassicShutterAnimation
ClassicShutterAnimation_FILES = Tweak.xm
ClassicShutterAnimation_FRAMEWORKS = UIKit Foundation
ClassicShutterAnimation_PRIVATEFRAMEWORKS = CameraUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += classicshutteranimation
include $(THEOS_MAKE_PATH)/aggregate.mk
