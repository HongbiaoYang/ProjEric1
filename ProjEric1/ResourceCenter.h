//
//  ResourceCenter.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/23/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class AVSpeechSynthesizer;
@class DBManager;

@interface ResourceCenter : NSObject {

//    AVSpeechSynthesizer *synthesizer;
//    UIBarButtonItem *iconSound;
//    UIImageView *imgViewSound;
}

@property UIBarButtonItem *iconSound;
@property UIImageView *imgViewSound;
@property AVSpeechSynthesizer *synthesizer;
@property float talkSpeed;

@property(nonatomic, strong) DBManager *dbManager;

@property(nonatomic, copy) NSString *transit;

+(id) sharedResource;

-(void)SpeakOut:(NSString *)text;
-(void)SpeakContinue:(NSString *)text;

+ (CGSize)screenSize;
+ (UIColor *)colorFromHexString:(NSString *)hexString;


@end
