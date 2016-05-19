//
//  PBPastebinAccount.h
//  Pastebin
//
//  Created by pixfid on 21.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNIRest.h"
#import "ResourcesManager.h"
//--------------------------
#import "PBPaste.h"

@interface PBPastebinAccount : NSObject {
    NSString *userName;
    NSString *userPassword;
    NSString *userSessionId;
    NSString *developerKey;
}

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *userPassword;
@property(nonatomic, copy) NSString *userSessionId;
@property(nonatomic, copy) NSString *developerKey;

//---------------------------
+ (id)getInstance;

- (id)init;

- (NSString *)getUserName;

- (NSString *)getUserPassword;

- (NSString *)getUserSessionId;

- (NSString *)getDeveloperKey;

- (void)login;

- (void)reInit;

//---------------------------
- (NSString *)paste:(PBPaste *)params;

- (NSString *)pasteA:(PBPaste *)params;

- (NSString *)pasteL:(PBPaste *)params;

//---------------------------
- (BOOL)alreadyLogin;

- (NSDictionary *)getAccountDetails;

- (NSArray *)getPastes;

@end
