#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Магия для скрытия экрана на скриншотах и записях
  UIWindow *window = self.window;
  if (window != nil) {
      UITextField *field = [[UITextField alloc] init];
      field.secureTextEntry = YES;
      [window addSubview:field];
      [field.centerYAnchor constraintEqualToAnchor:window.centerYAnchor].active = YES;
      [field.centerXAnchor constraintEqualToAnchor:window.centerXAnchor].active = YES;
      [window.layer.superlayer addSublayer:field.layer];
      [[field.layer.sublayers firstObject] addSublayer:window.layer];
  }

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
