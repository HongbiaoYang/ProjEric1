//
//  HomeViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/1/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@class DBManager;

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *paraSingleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fixSingleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tutSingleTap;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *paraDoubleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *fixDoubleTap;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tutDoubleTap;

//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property(nonatomic, strong) id kBaseURL;
@property(nonatomic, copy) NSString *kLocations;
@end
