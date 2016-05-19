//
//  PBAppDelegate.m
//  Pastebin
//
//  Created by pixfid on 15.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "PBAppDelegate.h"

@interface PBAppDelegate () {
    OBMenuBarWindow *_statusItemPopup;
    ResourcesManager *rm;
    PBPastebinAccount *account;

}
@property(strong) CNUserNotificationCenter *notificationCenter;

@end

@implementation PBAppDelegate

#define helperAppBundleIdentifier @"com.commonsoft.Pastebin-Helper"
#define terminateNotification @"TERMINATEHELPER"

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.menuBarIcon = [NSImage imageNamed:@"menubariconblack"];
    self.window.highlightedMenuBarIcon = [NSImage imageNamed:@"menubaricongrey"];
    self.window.hasMenuBarIcon = YES;
    self.window.attachedToMenuBar = YES;
    self.window.isDetachable = YES;
    self.arrowWidth = 20;
    self.arrowHeight = 10;
    //
    self.notificationCenter = [CNUserNotificationCenter defaultUserNotificationCenter];
    self.notificationCenter.delegate = self;
    //
    BOOL startedAtLogin = NO;

    NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in apps) {
        if ([app.bundleIdentifier isEqualToString:helperAppBundleIdentifier]) startedAtLogin = YES;
    }

    if (startedAtLogin) {
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:terminateNotification
                                                                       object:[[NSBundle mainBundle] bundleIdentifier]];
    }
    //
    account = [PBPastebinAccount getInstance];
    [account login];
}

- (void)setArrowWidth:(CGFloat)width {
    self.window.arrowSize = NSMakeSize(width, self.window.arrowSize.height);
}

- (void)setArrowHeight:(CGFloat)height {
    self.window.arrowSize = NSMakeSize(self.window.arrowSize.width, height);
}

- (IBAction)handleShowMenu:(id)sender {
    [NSMenu popUpContextMenu:_menu
                   withEvent:[NSApp currentEvent]
                     forView:sender];
}

- (IBAction)checkPrivate:(id)sender {
    NSInteger index = [_pasteType indexOfSelectedItem];
    if (index == 2) {
        account = [PBPastebinAccount getInstance];
        if (![account alreadyLogin]) {
            [self errorNotify:@"You must login before you can post private pastes!" notifyTitle:@"ERROR" notifySubTitle:@""];
        }
    }
}

- (void)awakeFromNib {
    rm = [ResourcesManager getInstance];
    [_codeFormat addItemsWithObjectValues:[[rm table] allValues]];
    [_pasteType addItemsWithObjectValues:[[rm pasteType] allValues]];
    [_expireDate addItemsWithObjectValues:[[rm expireDate] allValues]];
}

- (IBAction)post:(id)sender {
    @autoreleasepool {
        NSInteger length = [[[_codeView textStorage] string] length];
        if (length > 0) {
            account = [PBPastebinAccount getInstance];
            PBPaste *paste = [[PBPaste alloc] init];
            [paste setPasteName:[_name stringValue]];
            [paste setPasteText:[[_codeView textStorage] string]];
            [paste setPasteLang:[rm getSyntax:[_codeFormat objectValueOfSelectedItem] != nil ? [_codeFormat objectValueOfSelectedItem] : @"None"]];
            [paste setPasteExpDate:[rm getExpireDate:[_expireDate objectValueOfSelectedItem] != nil ? [_expireDate objectValueOfSelectedItem] : @"Never"]];
            [paste setPasteType:[rm getPasteType:[_pasteType objectValueOfSelectedItem] != nil ? [_pasteType objectValueOfSelectedItem] : @"Public"]];
            NSString *response = [account paste:paste];
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] setString:response forType:NSStringPboardType];
            [self postNotify:response];
            NSLog(@"%@", response);
            [[self window] close];
        } else {
            [self errorNotify:@"Your paste can not be empty!" notifyTitle:@"ERROR" notifySubTitle:@""];
        }
    }
}

- (IBAction)showSettings:(id)sender {
    if (!settingsWindow) {
        settingsWindow = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindowController"];
    }
    [settingsWindow showWindow:self];
}

- (void)postNotify:(NSString *)url {
    CNUserNotification *notification = [CNUserNotification new];
    notification.title = @"Complete";
    notification.subtitle = @"Link copied to clipboard";
    notification.informativeText = url;
    notification.feature.dismissDelayTime = 6;
    notification.feature.bannerImage = [NSApp applicationIconImage];
    notification.soundName = CNUserNotificationDefaultSound;
    notification.userInfo = @{@"openThisURLBecauseItsAwesome" : url};
    [self.notificationCenter deliverNotification:notification];
}

- (void)errorNotify:(NSString *)notifyMessage notifyTitle:(NSString *)notifyTitle notifySubTitle:(NSString *)notifySubTitle {

    CNUserNotification *notification = [CNUserNotification new];
    notification.title = notifyTitle;
    notification.subtitle = notifySubTitle;
    notification.informativeText = notifyMessage;
    notification.feature.dismissDelayTime = 6;
    notification.feature.bannerImage = [NSApp applicationIconImage];
    notification.soundName = CNUserNotificationErrorSound;
    [self.notificationCenter deliverNotification:notification];
}

#pragma mark - CNUserNotification Delegate

- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification {
    //    NSLog(@"userNotificationCenter:didActivateNotification: %@", notification);
    NSString *urlToOpen = [notification.userInfo objectForKey:@"openThisURLBecauseItsAwesome"];
    if (urlToOpen && ![urlToOpen isEqualToString:@""]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlToOpen]];
    }
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification {
    //    NSLog(@"userNotificationCenter:didDeliverNotification: %@", notification);
}

- (IBAction)clear:(id)sender {
    [_codeView setString:@""];
}

@end
