//
//  SlideTutorialViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/3/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBManager;

@interface SlideTutorialViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *ProgressImg;
@property (weak, nonatomic) IBOutlet UIButton *PreviousBtn;
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;
@property (weak, nonatomic) IBOutlet UIButton *SkipBtn;
@property (weak, nonatomic) IBOutlet UILabel *DescText;
@property (weak, nonatomic) IBOutlet UIImageView *ScreenImg;


@property(nonatomic, copy) NSString *from;

@end
