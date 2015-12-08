//
//  VisionViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/20/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBManager;

@interface VisionViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *VisionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *VisonImage;
@property NSString *subMenu;
@property NSMutableArray  *categories, *itemsEmergency, *itemsGetting, *itemsRiding, *itemsSafety, *itemsResponse;
@property NSInteger level, index1, index2;

@end
