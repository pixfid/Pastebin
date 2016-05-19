//
//  PBPaste.m
//  Pastebin
//
//  Created by pixfid on 21.05.14.
//  Copyright (c) 2014 commonsoft. All rights reserved.
//

#import "PBPaste.h"

@implementation PBPaste

@synthesize pasteName;
@synthesize pasteText;
@synthesize pasteLang;
@synthesize pasteExpDate;
@synthesize pasteType;

- (id)init {
    self = [super init];
    if (self) {
        //todo?
    }
    return self;
}

- (NSString *)getPasteName {
    return pasteName;
}

- (NSString *)getPasteText {
    return pasteText;
}

- (NSString *)getPasteLang {
    return pasteLang;
}

- (NSString *)getPasteExpDate {
    return pasteExpDate;
}

- (NSString *)getPasteType {
    return pasteType;
}

@end
