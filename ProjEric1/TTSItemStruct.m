//
//  TTSItemStruct.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 7/30/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "TTSItemStruct.h"

@implementation TTSItemStruct

@synthesize title;
@synthesize titulo;
@synthesize text;
@synthesize texto;
@synthesize image;
@synthesize imageV;

- (instancetype)initItemWithText:(NSString *)iText {

    self = [super init];
    if (self) {
        self.title = iText;
        self.text = iText;
        self.image = @"customize.png";
        self.imageV = @"customize.png";
        self.color = @"00ffff";
        self.customize = @"added";

    }
    return self;
}

@end


