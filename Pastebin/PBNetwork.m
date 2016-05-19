//
//  PBNetwork.m
//  Pastebin
//
//  Created by pixfid on 18.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "PBNetwork.h"

@implementation PBNetwork

+ (id)getInstance {
    static PBNetwork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (BOOL)networkReachability {
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;

    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"google.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);

    return !(!receivedFlags || (flags == 0));
}

@end
