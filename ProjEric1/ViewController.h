//
//  ViewController.h
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVSpeechSynthesizer;

@interface ViewController : UIViewController


@property AVSpeechSynthesizer *synthesizer;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@end

