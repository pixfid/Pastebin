//
//  PBNetwork.h
//  Pastebin
//
//  Created by pixfid on 18.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <uuid/uuid.h>

@interface PBNetwork : NSObject
+ (id)getInstance;

- (id)init;

- (BOOL)networkReachability;
@end
