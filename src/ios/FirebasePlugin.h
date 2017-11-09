#import <Cordova/CDVPlugin.h>

@interface FirebasePlugin : CDVPlugin

- (void)echo:(CDVInvokedUrlCommand*)command;

@end
