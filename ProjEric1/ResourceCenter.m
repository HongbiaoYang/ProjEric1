//
//  ResourceCenter.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/23/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ResourceCenter.h"
#import "TTSItemStruct.h"
#import "DBManager.h"
#import <AVFoundation/AVSpeechSynthesis.h>



@implementation ResourceCenter

@synthesize synthesizer;
@synthesize imgViewSound;
@synthesize iconSound;

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
        // init synthesizer
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        [self setTalkSpeed:0.2f];

        // init db
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"projEric.sql"];

        // init animation resources
        UIImage *frame = [UIImage imageNamed:@"sound0.png"];
        CGRect rect = CGRectMake(0,0,frame.size.width, frame.size.height);

        imgViewSound = [[UIImageView alloc] initWithFrame:rect];
        imgViewSound.animationImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"sound0.png"],
                [UIImage imageNamed:@"sound1.png"],
                [UIImage imageNamed:@"sound2.png"],
                [UIImage imageNamed:@"sound3.png"], nil];
        imgViewSound.image = frame;

        imgViewSound.animationDuration = 1.0f;
        imgViewSound.animationRepeatCount = 1;
//        [imgViewSound startAnimating];

        iconSound = [[UIBarButtonItem alloc] initWithCustomView:imgViewSound];

        // init some other global variable.
        [self setTransit:@"para"];
    }

    return self;
}

- (void)SpeakOut:(NSString *)text {
    if ([[self synthesizer] isSpeaking]) {
        [[self synthesizer] stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }

    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setRate:[self talkSpeed]];
    [[self synthesizer] speakUtterance:utterance];


    [[self imgViewSound] startAnimating];
}

+ (CGSize)screenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void)dealloc {


}




@end
