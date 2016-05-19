//
//  ResourcesManager.m
//  Pastebin
//
//  Created by pixfid on 14.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "ResourcesManager.h"

@implementation ResourcesManager

@synthesize syntaxTable;

+ (id)getInstance {
    static ResourcesManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadResources];
    }
    return self;
}

- (void)loadResources {

    NSString *syntaxTablePath = [[NSBundle mainBundle] pathForResource:@"api_paste_format" ofType:@"plist"];
    if (syntaxTablePath) {
        syntaxTable = [NSDictionary dictionaryWithContentsOfFile:syntaxTablePath];
    }
}

- (NSUserDefaults *)getUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

- (NSString *)getSyntax:(NSString *)value {
    return [[syntaxTable allKeysForObject:value] lastObject];
}

- (NSDictionary *)table {
    return syntaxTable;
}

- (NSDictionary *)expireDate {
    NSDictionary *api_paste_expire_date = @{
            @"N" : @"Never",
            @"10M" : @"10 Minutes",
            @"1H" : @"1 Hour",
            @"1D" : @"1 Day",
            @"1W" : @"1 Week",
            @"2W" : @"2 Weeks",
            @"1M" : @"1 Month"
    };
    return api_paste_expire_date;
}

- (NSString *)getExpireDate:(NSString *)value {
    return [[[self expireDate] allKeysForObject:value] lastObject];
}

- (NSDictionary *)pasteType {
    NSDictionary *api_paste_private = @{
            @"0" : @"Public",
            @"1" : @"Unlisted",
            @"2" : @"Private"
    };
    return api_paste_private;
}

- (NSString *)getPasteType:(NSString *)value {
    return [[[self pasteType] allKeysForObject:value] lastObject];
}

@end
