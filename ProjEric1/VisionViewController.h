//
//  VisionViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 9/20/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisionViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSArray *elementToParse;
}

@property (weak, nonatomic) IBOutlet UILabel *VisionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *VisonImage;
@property NSString *subMenu;
@property NSMutableArray  *categories, *itemsEmergency, *itemsGetting, *itemsRiding, *itemsSafety;
@property NSInteger level, index1, index2;

@end
