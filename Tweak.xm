#import <UIKit/UIKit.h>

typedef enum {
    FGCameraModePhoto = 0,
    FGCameraModeVideo = 1,
    FGCameraModeSlomo = 2,
    FGCameraModePanorama = 3,
    FGCameraModeSquare = 4,
    FGCameraModeTimelapse = 5
} FGCameraMode;

@interface CUShutterButton : UIButton
- (void)shoot;
- (id)currentMode;
@end

// MARK: Settings
static NSString *const kFGAPreferencesDomain = @"de.finngaida.classicshutteranimation";
static NSString *const kFGAPreferencesEnabledKey = @"enabled";

@interface NSUserDefaults (Private)
- (instancetype)_initWithSuiteName:(NSString *)suiteName container:(NSURL *)container;
- (BOOL)boolForKey:(NSString *)key;
@end

NSUserDefaults *userDefaults;

%ctor {
    userDefaults = [[NSUserDefaults alloc] _initWithSuiteName:kFGAPreferencesDomain container:[NSURL URLWithString:@"/var/mobile"]];
    [userDefaults registerDefaults:@{kFGAPreferencesEnabledKey: @YES}];
}

%hook CAMBottomBar

- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    
    if ([userDefaults boolForKey:kFGAPreferencesEnabledKey]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            CUShutterButton *button = [self performSelector:@selector(shutterButton)];
            [button addTarget:button action:@selector(shoot) forControlEvents:UIControlEventTouchUpInside];
            
            %log([UIApplication sharedApplication], self, button);
            
        });
        
    }
    
    return self;
}

%end

%hook CUShutterButton

%new
- (id)currentMode {
    return [[[[UIApplication sharedApplication] delegate] performSelector:@selector(viewfinderViewController)] performSelector:@selector(_currentMode)];
}

%new
- (void)shoot {
    
    if ([self performSelector:@selector(currentMode)] == 0 || [self performSelector:@selector(currentMode)] == 0) {
        
        UIView *view = [[[[UIApplication sharedApplication] keyWindow] subviews][0] subviews][0];
        %log(self, view);
        
        CATransition *shutterAnimation = [CATransition animation];
        [shutterAnimation setDuration:0.6];
        
        shutterAnimation.timingFunction = (CAMediaTimingFunction *)UIViewAnimationCurveEaseInOut;
        [shutterAnimation setType:@"cameraIris"];
        [shutterAnimation setValue:@"cameraIris" forKey:@"cameraIris"];
        CALayer *cameraShutter = [[CALayer alloc]init];
        [cameraShutter setBounds:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        
        [view.layer addSublayer:cameraShutter];
        [view.layer addAnimation:shutterAnimation forKey:@"cameraIris"];
        
    }
}

%end