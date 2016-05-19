//
//  SettingsWindowController.m
//  Pastebin
//
//  Created by pixfid on 15.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "SettingsWindowController.h"

@interface SettingsWindowController () {
}
@end

@implementation SettingsWindowController {
@private
    ResourcesManager *rm;
    NSUserDefaults *defaults;
}

#define helperAppBundleIdentifier @"com.commonsoft.Pastebin-Helper"
#define terminateNotification @"TERMINATEHELPER"

@synthesize launchAtLoginButton;

- (id)initWithWindowNibName:(NSString *)nibBundleOrNil {
    self = [super initWithWindowNibName:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)awakeFromNib {
    rm = [ResourcesManager getInstance];
    defaults = [rm getUserDefaults];
    if (defaults) {
        NSString *api_dev_key = [defaults valueForKey:@"api_dev_key"];
        if (api_dev_key) {
            [_devApi setStringValue:api_dev_key];
        }
        NSString *api_user_name = [defaults valueForKey:@"api_user_name"];
        if (api_user_name) {
            [_userName setStringValue:api_user_name];
        }
        NSString *api_user_password = [defaults valueForKey:@"api_user_password"];
        if (api_user_password) {
            [_userPassword setStringValue:api_user_password];
        }

        NSInteger auto_login_enabled = [defaults integerForKey:@"auto_login_enabled"];

        switch (auto_login_enabled) {
            case 0:
                [launchAtLoginButton selectSegmentWithTag:1];
                break;
            case 1:
                [launchAtLoginButton selectSegmentWithTag:0];
            default:
                break;
        }
    }
}

- (IBAction)toggleLaunchAtLogin:(id)sender {
    NSSegmentedControl *control = (NSSegmentedControl *) sender;
    NSInteger clickedSegment = [control selectedSegment];
    defaults = [rm getUserDefaults];

    if (clickedSegment == 0) { // ON
        // Turn on launch at login
        [defaults setInteger:1 forKey:@"auto_login_enabled"];
        if (!SMLoginItemSetEnabled((__bridge CFStringRef) helperAppBundleIdentifier, YES)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Couldn't add Helper App to launch at login item list."];
            [alert runModal];
        }
    }
    if (clickedSegment == 1) { // OFF

        // Turn off launch at login
        [defaults setInteger:0 forKey:@"auto_login_enabled"];
        if (!SMLoginItemSetEnabled((__bridge CFStringRef) helperAppBundleIdentifier, NO)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Couldn't remove Helper App from launch at login item list."];
            [alert runModal];
        }

    }
}

- (IBAction)save:(id)sender {
    rm = [ResourcesManager getInstance];
    defaults = [rm getUserDefaults];
    if (defaults) {
        [defaults setValue:[_devApi stringValue] forKey:@"api_dev_key"];
        [defaults setValue:[_userName stringValue] forKey:@"api_user_name"];
        [defaults setValue:[_userPassword stringValue] forKey:@"api_user_password"];
    }
    [[PBPastebinAccount getInstance] reInit];
    [self close];
}

- (void)windowDidLoad {
    [super windowDidLoad];

}

@end
