//
//  PBPastebinAccount.m
//  Pastebin
//
//  Created by pixfid on 21.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "PBPastebinAccount.h"
#import "XMLDictionary.h"

@implementation PBPastebinAccount

NSString *apiKey = @"b7d07cc2908bcd6346361fb48004fcfe";
ResourcesManager *rm;

@synthesize userName;
@synthesize userPassword;
@synthesize userSessionId;
@synthesize developerKey;

+ (id)getInstance {

    static PBPastebinAccount *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        rm = [ResourcesManager getInstance];
        NSUserDefaults *defaults = [rm getUserDefaults];
        developerKey = [defaults valueForKey:@"api_dev_key"];

        if (!developerKey) {
            developerKey = apiKey;
        }
        if (developerKey.length == 0) {
            developerKey = apiKey;
        }
        userName = [defaults valueForKey:@"api_user_name"];
        userPassword = [defaults valueForKey:@"api_user_password"];
    }
    return self;
}

- (NSString *)getUserName {
    return userName;
}

- (NSString *)getUserPassword {
    return userPassword;
}

- (NSString *)getUserSessionId {
    NSLog(@"sessionId: %@", userSessionId);
    return userSessionId;
}

- (NSString *)getDeveloperKey {
    return developerKey;
}


- (void)login {

    if ([self getUserSessionId] != nil) {
        NSLog(@"Already logged in.");
        return;
    }
    if ([self getUserName] == nil || [self getUserPassword] == nil) {
        NSLog(@"Username or password null.");
        return;
    }
    if ([self getDeveloperKey] == nil || [[self getDeveloperKey] length] == 0) {
        NSLog(@"Developer key is missing.");
        return;
    }
    NSDictionary *headers = @{@"accept" : @"application/json"};
    NSDictionary *parameters = @{
            @"api_dev_key" : [self getDeveloperKey],
            @"api_user_name" : [self getUserName],
            @"api_user_password" : [self getUserPassword],
    };

    UNIHTTPStringResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"http://pastebin.com/api/api_login.php"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asString];

    if ([[response body] rangeOfString:@"Bad"].location == NSNotFound) {
        NSLog(@"Response: %@", [response body]);
        [self setUserSessionId:[response body]];
    }
}

- (void)reInit {
    if (![self alreadyLogin]) {
        rm = [ResourcesManager getInstance];
        NSUserDefaults *defaults = [rm getUserDefaults];
        developerKey = [defaults valueForKey:@"api_dev_key"];

        if (!developerKey) {
            developerKey = apiKey;
        }
        if (developerKey.length == 0) {
            developerKey = apiKey;
        }
        userName = [defaults valueForKey:@"api_user_name"];
        userPassword = [defaults valueForKey:@"api_user_password"];
        [self login];
    }
}

- (NSString *)paste:(PBPaste *)params {

    if ([self getUserSessionId] == nil) {
        return [self pasteA:params];
    } else {
        return [self pasteL:params];
    }
}


- (NSString *)pasteA:(PBPaste *)params {

    NSDictionary *headers = @{@"accept" : @"application/json"};
    NSDictionary *parameters = @{
            @"api_dev_key" : [self getDeveloperKey],
            @"api_option" : @"paste",
            @"api_paste_code" : [params getPasteText],
            @"api_paste_name" : [params getPasteName],
            @"api_paste_private" : [params getPasteType],
            @"api_paste_expire_date" : [params getPasteExpDate],
            @"api_paste_format" : [params getPasteLang]
    };

    UNIHTTPStringResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"http://pastebin.com/api/api_post.php"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asString];
    return [response body];
}

- (NSString *)pasteL:(PBPaste *)params {

    NSDictionary *headers = @{@"accept" : @"application/json"};
    NSDictionary *parameters = @{
            @"api_dev_key" : [self getDeveloperKey],
            @"api_option" : @"paste",
            @"api_paste_code" : [params getPasteText],
            @"api_paste_name" : [params getPasteName],
            @"api_paste_private" : [params getPasteType],
            @"api_paste_expire_date" : [params getPasteExpDate],
            @"api_paste_format" : [params getPasteLang],
            @"api_user_key" : [self getUserSessionId]
    };

    UNIHTTPStringResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"http://pastebin.com/api/api_post.php"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asString];
    return [response body];
}

- (BOOL)alreadyLogin {
    return [self userSessionId] != nil || [[self userSessionId] length] != 0;
}

- (NSDictionary *)getAccountDetails {

    if ([self getUserName] == nil || [self getUserPassword] == nil) {
        NSLog(@"Username or password null.");
        return nil;
    }
    if ([self getDeveloperKey] == nil || [[self getDeveloperKey] length] == 0) {
        NSLog(@"Developer key is missing.");
        return nil;
    }

    NSDictionary *headers = @{@"accept" : @"application/json"};
    NSDictionary *parameters = @{
            @"api_dev_key" : [self getDeveloperKey],
            @"api_user_key" : [self getUserSessionId],
            @"api_option" : @"userdetails"};

    UNIHTTPStringResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"http://pastebin.com/api/api_post.php"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asString];
    return [[XMLDictionaryParser sharedInstance] dictionaryWithString:[response body]];
}

- (NSArray *)getPastes {
    //TODO fix this.
    return nil;
}

@end
