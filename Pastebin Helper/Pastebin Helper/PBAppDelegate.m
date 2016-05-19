//
//  PBAppDelegate.m
//  Pastebin Helper
//
//  Created by pixfid on 22.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "PBAppDelegate.h"

@implementation PBAppDelegate

#define mainAppBundleIdentifier @"com.commonsoft.Pastebin"
#define mainAppName @"Pastebin"
#define terminateNotification @"TERMINATEHELPER"


@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // Check if main app is already running;
    // If yes, do nothing and terminate helper app
    BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running) {
        if ([[app bundleIdentifier] isEqualToString:mainAppBundleIdentifier]) {
            alreadyRunning = YES;
        }
    }

    if (alreadyRunning) {
        // Main app is already running,
        // Meaning that the helper was launched via SMLoginItemSetEnabled, kill the helper
        [self killApp];
    } else {
        // Register Observer
        // So that main app can later notify helper to terminate
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(killApp)
                                                                name:terminateNotification // Can be any string, but shouldn't be nil
                                                              object:mainAppBundleIdentifier];

        // Launch main app
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSArray *p = [path pathComponents];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:mainAppName];
        NSString *mainAppPath = [NSString pathWithComponents:pathComponents];
        [[NSWorkspace sharedWorkspace] launchApplication:mainAppPath];
    }
}

// Terminates helper app
// Called by main app after main app has checked if helper app is still running
// This allows main app to determine whether it was launched at login or not
// For complete documentation see http://blog.timschroeder.net/2014/01/25/detecting-launch-at-login-revisited/
- (void)killApp {
    [NSApp terminate:nil];
}


@end
