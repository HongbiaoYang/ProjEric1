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

@interface ResourceCenter : NSObject {

    AVSpeechSynthesizer *synthesizer;
}
@property AVSpeechSynthesizer *synthesizer;
@property float talkSpeed;

 +(id) sharedResource;

 -(void)SpeakOut:(NSString *)text;
+ (CGSize)screenSize;


@end
