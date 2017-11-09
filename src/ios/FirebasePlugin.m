#import <Cordova/CDVPlugin.h>
#import "FirebasePlugin.h"
#import "Firebase.h"
@import FirebaseAnalytics;
@import FirebaseInstanceID;

@implementation FirebasePlugin

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];

}

- (void)finishLaunching:(NSNotification *)notification
{
    [FIRApp configure];
}

- (void)getId:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
                    [[FIRInstanceID instanceID] token]];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getToken:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
                    [[FIRInstanceID instanceID] token]];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logEvent:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString* name = [command.arguments objectAtIndex:0];
        NSDictionary* parameters = [command.arguments objectAtIndex:1];

        [FIRAnalytics logEventWithName:name parameters:parameters];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)setUserId:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSString* id = [command.arguments objectAtIndex:0];

        [FIRAnalytics setUserID:id];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
