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

- (instancetype)initItemWithText:(NSString *)text {

    self = [super init];
    if (self) {
        self.title = text;
        self.text = text;
        self.image = @"customize.png";
        self.imageV = @"added";

    }
    return self;
}

@end


