//
//  PBPaste.h
//  Pastebin
//
//  Created by pixfid on 21.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBPaste : NSObject {
    NSString *pasteName;
    NSString *pasteText;
    NSString *pasteLang;
    NSString *pasteExpDate;
    NSString *pasteType;
}

@property(nonatomic, copy) NSString *pasteName;
@property(nonatomic, copy) NSString *pasteText;
@property(nonatomic, copy) NSString *pasteLang;
@property(nonatomic, copy) NSString *pasteExpDate;
@property(nonatomic, copy) NSString *pasteType;

- (id)init;

- (NSString *)getPasteName;

- (NSString *)getPasteText;

- (NSString *)getPasteLang;

- (NSString *)getPasteExpDate;

- (NSString *)getPasteType;

@end
