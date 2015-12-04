//
//  NonEnglishViewController.h
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NonEnglishViewController : UIViewController



@property NSString* subMenu;
@property(nonatomic, copy) NSString *transit;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@end
