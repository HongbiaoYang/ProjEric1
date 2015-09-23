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
    }

    return self;
}

- (void)SpeakOut:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:0.3f];
    [[self synthesizer] speakUtterance:utterance];
}

- (void)dealloc {


}


@end
