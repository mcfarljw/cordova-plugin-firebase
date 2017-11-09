#import <Cordova/CDVPlugin.h>

@interface FirebasePlugin : CDVPlugin

- (void)getId:(CDVInvokedUrlCommand*)command;
- (void)getToken:(CDVInvokedUrlCommand*)command;
- (void)logEvent:(CDVInvokedUrlCommand*)command;
- (void)setUserId:(CDVInvokedUrlCommand*)command;

@end
