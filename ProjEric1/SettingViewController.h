//
//  SettingViewController.h
//  ProjEric1
//
//  Created by hongbiao yang on 10/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GIDSignIn.h>

@interface SettingViewController : UIViewController<GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UISlider *SpeedSlider;
@property (weak, nonatomic) IBOutlet UILabel *speedDisplay;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *ggLoginBtn;

@end
