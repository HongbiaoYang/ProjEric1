//
//  TutorialStruct.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "TutorialStruct.h"

@implementation TutorialStruct


- (instancetype)initStructWithText:(NSString *)text picture:(NSString *)picture
                           gesture:(NSString *)gesture voice:(NSString*)voice  {
    [self setText:text];
    [self setPicture:picture];
    [self setVoice:voice];
    [self setGesture:gesture];

    return self;
}


@end
