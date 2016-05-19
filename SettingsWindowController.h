//
//  SettingsWindowController.h
//  Pastebin
//
//  Created by pixfid on 15.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ResourcesManager.h"
#import <ServiceManagement/ServiceManagement.h>
#import "PBPastebinAccount.h"

@interface SettingsWindowController : NSWindowController {

}
@property(weak) IBOutlet NSTextField *devApi;
@property(weak) IBOutlet NSTextField *userName;
@property(weak) IBOutlet NSSecureTextField *userPassword;
@property(assign) IBOutlet NSSegmentedControl *launchAtLoginButton;

- (IBAction)toggleLaunchAtLogin:(id)sender;
@end
