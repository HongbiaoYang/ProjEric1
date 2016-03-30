//
//  AppDelegate.h
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

