//
//  HomeViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/1/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "HomeViewController.h"
#import "ResourceCenter.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "EmergencyTableViewController.h"
#import "MoreMenuTableViewController.h"
#import "DBManager.h"



@interface HomeViewController ()

@property(nonatomic, strong) DBManager *dbManager;
@end

@implementation HomeViewController {
    ResourceCenter *sharedCenter;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
#if defined (LITE)
    NSLog(@"Lite Version");
#else
    NSLog(@"Full Version");
#endif
    
    // change the appearance depending on the login status
    ////---- disable the login requirement for now
   /* if ([sharedCenter fbLogin] || [sharedCenter ggLogin]) {
        [[self paraButton] setAlpha:1.0];
        [[self fixButton] setAlpha:1.0];
    } else  {
        [[self paraButton] setAlpha:0.5];
        [[self fixButton] setAlpha:0.5];
    }*/

}


- (IBAction)SingleTapAnywhere:(id)sender {
    if ([self doubleTapped]) {
        self.doubleTapped = NO;
        return;
    }

    [sharedCenter SpeakOut:@"please double tap to make a selection"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

//    if ((gestureRecognizer == [self paraDoubleTap] || gestureRecognizer == [self fixDoubleTap]) && touch.tapCount == 2) {
    if (touch.tapCount == 2) {
        NSLog(@"para/fixed double tapped");

        if ([sharedCenter fbLogin] || [sharedCenter ggLogin]) {
            NSLog(@"para/fixed logged");
            return YES;
        } else {
            [self DisplayLoginRequireDialog];
            self.doubleTapped = YES;
            [sharedCenter SpeakOut:@"You need to login to unlock this function"];
        }
    } else {

        return NO;
    }

    return YES;
}

- (void)DisplayLoginRequireDialog {
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Please Login"
                                                     message:@"You need to login to continue!"
                                                    delegate:self
                                           cancelButtonTitle:@"Go to Login" otherButtonTitles:@"Cancel", nil];

    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = 201;

    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 201) {
        // 1st Other Button

        if (buttonIndex == 0) {
            NSLog(@"go login");
            [self settingPage:self];

        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // change background and bar color
    self.view.backgroundColor = [UIColor blackColor];   // view bg color
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];    // top nav bar color
    
    self.navigationController.toolbar.barTintColor = [UIColor yellowColor];     // button toolbar color

    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    self.YesItem.title = @"Yes      \u2714";
    self.NoItem.title = @"No      \u2716";
    self.MoreItem.title = @"More      \u2605";

    // gesture recognizer related
    [[self tutSingleTap] requireGestureRecognizerToFail:[self tutDoubleTap]];
    [[self paraSingleTap] requireGestureRecognizerToFail:[self paraDoubleTap]];
    [[self fixSingleTap] requireGestureRecognizerToFail:[self fixDoubleTap]];

    ////---- comment these two line will disable the function:
    // - (BOOL)gestureRecognizer:(UIGestureRecognizer *) shouldReceiveTouch:(UITouch *)
    /*[self paraDoubleTap].delegate = self;
    [self fixDoubleTap].delegate = self;*/


    sharedCenter = [ResourceCenter sharedResource];

    // set transit to para by default, in the very first page
    [sharedCenter setTransit:@"para"];


    // add right up corner icons: setting and emergency
    UIImage *imgEmergency = [UIImage imageNamed:@"emergency_ico"];
    UIButton *btnEmergency = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmergency.bounds = CGRectMake(0, 0, imgEmergency.size.width, imgEmergency.size.height);
    [btnEmergency setImage:imgEmergency forState:UIControlStateNormal];
    UIBarButtonItem *iconEmergency = [[UIBarButtonItem alloc] initWithCustomView:btnEmergency];
    [btnEmergency addTarget:self action:@selector(emergencyPage:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *icoSetting = [[UIBarButtonItem alloc]
            initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingPage:)];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:28.0];
    NSDictionary *fontDict = @{NSFontAttributeName:customFont};
    [icoSetting setTitleTextAttributes:fontDict forState:UIControlStateNormal];


    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: icoSetting, iconEmergency, nil]];

 /*   // google login stuff
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;

    if ([sharedCenter isFbLogged] == NO && [sharedCenter isGgLogged] == NO) {
        [self DisplayLoginDialog];
    }*/

}

/*

- (void)DisplayLoginDialog {
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Please Login"
                                                     message:@" Login to Continue!"
                                                    delegate:self
                                           cancelButtonTitle:@"Facebook Login" otherButtonTitles:@"Google Login", nil];

    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = 201;

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 201) {
        // 1st Other Button

        if (buttonIndex == 0) {

            NSLog(@"fb login");

            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

            [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
                   fromViewController:self
                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                     if (error || result.isCancelled) {
                         NSLog(@"FB login error || cancelled");
                         [self DisplayLoginDialog];

                     } else {
                         NSLog(@"FB Logged in");

                         [sharedCenter updateFBLoginStatus:YES];
                         [self prepareDataForServerFB];
                     }
                 }];
        } else if (buttonIndex == 1) {
            // google login

            [[GIDSignIn sharedInstance] signIn];
        }
    }

}

// after google login
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {


    if (error != nil) {
        NSLog(@"GG login error || cancelled");
        [self DisplayLoginDialog];
    }

    // update gg status in both db and variable
    [sharedCenter updateGGLoginStatus:YES];

    // send the data to server
    NSString *fullName = user.profile.name;
    NSString *email = user.profile.email;

//    NSLog(@"did SignIn in homeview: %@ %@ ggloged %@ %@", fullName, email, [sharedCenter ggLogin], error);
    NSLog(@"did signin in homeview");

    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];

    safeSet(jsonable, @"name", fullName);
    safeSet(jsonable, @"email", email);
    safeSet(jsonable, @"platform", @"google");

    [self sendDataToServer:jsonable];
}


- (void)prepareDataForServerFB {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id, name, email, gender, friends" forKey:@"fields"];


    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
            startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                [self handleDataRequestFB:result Error:error];
            }];
}


- (void)handleDataRequestFB:(id)result Error:(NSError *)error {
    if (error == nil) {
        NSLog(@"result=%@", result);
        NSString *email = result[@"email"];
        NSString *name = result[@"name"];

        NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
        safeSet(jsonable, @"name", name);
        safeSet(jsonable, @"email", email);
        safeSet(jsonable, @"platform", @"facebook");

        [self sendDataToServer:jsonable];
    }

}

- (void)sendDataToServer:(NSMutableDictionary *)jsonable {


    NSString *dbAddress = [kBaseURL stringByAppendingPathComponent:kCollection];

    NSURL* url = [NSURL URLWithString:dbAddress]; //1

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST"; //2


    NSData* data = [NSJSONSerialization dataWithJSONObject:jsonable options:0 error:NULL]; //3

    request.HTTPBody = data;

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4

    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
                if (!error) {
                    NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
                    NSLog(@"responseArray=%@", responseArray);
                }
            }];

    [dataTask resume];

}*/

-(void) settingPage:(id)sender {
    [sharedCenter SpeakOut:@"setting"];

    SettingViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

-(void) emergencyPage:(id)sender {
    [sharedCenter SpeakOut:@"emergency"];

    EmergencyTableViewController *eViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"emergency"];
    [self.navigationController pushViewController:eViewController animated:YES];
}

- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"para"] || [[segue identifier]isEqualToString:@"fixed"]) {

        MainViewController *destViewController = [segue destinationViewController];
        destViewController.transit = [segue identifier];
        sharedCenter.transit = [segue identifier];

    } else if ([[segue identifier] isEqualToString:@"homeMore"]) {
        MoreMenuTableViewController *destViewController = [segue destinationViewController];
        destViewController.from = [segue identifier];
    }
    
//    NSLog(@"segue in home = %@", [segue identifier]);

    
}


@end
