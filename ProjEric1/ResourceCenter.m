//
//  ResourceCenter.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/23/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ResourceCenter.h"
#import <AVFoundation/AVSpeechSynthesis.h>



@implementation ResourceCenter

@synthesize synthesizer;

+ (id)sharedResource {
    static ResourceCenter *sharedResource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedResource = [[self alloc] init];
    });
    return sharedResource;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        [self setTalkSpeed:0.2f];
    }

    return self;
}

- (void)SpeakOut:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:[self talkSpeed]];
    [[self synthesizer] speakUtterance:utterance];
}

+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}




- (void)dealloc {


}


@end
