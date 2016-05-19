//
//  ResourcesManager.h
//  Pastebin
//
//  Created by pixfid on 14.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourcesManager : NSObject {
    NSDictionary *syntaxTable;
}

@property(nonatomic, retain) NSDictionary *syntaxTable;

+ (id)getInstance;

- (id)init;

- (void)loadResources;

- (NSUserDefaults *)getUserDefaults;

- (NSString *)getSyntax:(NSString *)value;

- (NSDictionary *)table;

- (NSDictionary *)expireDate;

- (NSDictionary *)pasteType;

- (NSString *)getExpireDate:(NSString *)value;

- (NSString *)getPasteType:(NSString *)value;

@end
