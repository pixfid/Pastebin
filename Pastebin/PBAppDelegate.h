//
//  PBAppDelegate.h
//  Pastebin
//
//  Created by pixfid on 15.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNUserNotification.h"
#import "OBMenuBarWindow.h"
#import "SettingsWindowController.h"
#import "PBPastebinAccount.h"

@class OBMenuBarWindow;
@class SettingsWindowController;

@interface PBAppDelegate : NSObject <NSApplicationDelegate, CNUserNotificationCenterDelegate> {
@private
    SettingsWindowController *settingsWindow;
}

@property(assign) IBOutlet OBMenuBarWindow *window;
@property(weak) IBOutlet NSComboBox *codeFormat;
@property(weak) IBOutlet NSComboBox *expireDate;
@property(weak) IBOutlet NSComboBox *pasteType;
@property(weak) IBOutlet NSTextField *name;
@property(unsafe_unretained) IBOutlet NSTextView *codeView;
@property(strong) IBOutlet NSMenu *menu;


@property(nonatomic, assign) CGFloat arrowWidth;
@property(nonatomic, assign) CGFloat arrowHeight;

- (IBAction)showSettings:(id)sender;

- (void)postNotify:(NSString *)url;

- (void)errorNotify:(NSString *)notifyMessage notifyTitle:(NSString *)notifyTitle notifySubTitle:(NSString *)notifySubTitle;
@end
