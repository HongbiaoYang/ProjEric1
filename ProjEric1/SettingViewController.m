//
//  SettingViewController.m
//  ProjEric1
//
//  Created by hongbiao yang on 10/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SettingViewController.h"
#import "ResourceCenter.h"
#import "DBManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

#define safeSet(d,k,v) if (v) d[k] = v;

static NSString* const kPort = @"3009";
static NSString* const kCollection = @"eric";


ResourceCenter *sharedCenter;

@interface SettingViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrInfo;


@end



@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // UI work
    self.view.backgroundColor = [UIColor blackColor];
    self.SpeedSlider.continuous = YES;

    // all initialization work
    [self initPrep];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // change the appearance depending on the login status
    if ([sharedCenter fbLogin]) {
        [[self fbLoginBtn] setAlpha:0.3];
    } else  {
        [[self fbLoginBtn] setAlpha:1.0];
    }
    
    // change the appearance depending on the login status
    if ([sharedCenter ggLogin]) {
        [[self ggLoginBtn] setAlpha:0.3];
    } else  {
        [[self ggLoginBtn] setAlpha:1.0];
    }

    
    
    
}

- (void)initPrep {

    // initialize the sharedCenter singleton and db stuff
    sharedCenter = [ResourceCenter sharedResource];
    self.dbManager = [sharedCenter dbManager];

    float speedValueFromDB = [sharedCenter loadSpeedFromDB];

    [sharedCenter setTalkSpeed:speedValueFromDB];
    self.SpeedSlider.value = [sharedCenter talkSpeed];
    self.speedDisplay.text = [NSString stringWithFormat:@"Talking Speed(%.2f)", [sharedCenter talkSpeed]];


    // update FB login text
    NSString *fbBtnText = [sharedCenter isFbLogged] == YES ? @"Facebook Logout" : @"Facebook Login";
    [self.fbLoginBtn setTitle:fbBtnText forState:UIControlStateNormal];


    NSString *ggBtnText = [sharedCenter isGgLogged] == YES ? @"Google Logout" : @"Google Login";
    [self.ggLoginBtn setTitle:ggBtnText forState:UIControlStateNormal];

    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;


//    NSLog(@"fb login=%@ %@", fbBtnText, [sharedCenter fbLogin]);

}


// after google login
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

    if (error != nil) {
        NSLog(@"GG login error || cancelled");
        return;
    }

    // update gg status in both db and variable
    if (sharedCenter.ggLogin == NO) {
        [[self ggLoginBtn] setTitle:@"Google Logout" forState:UIControlStateNormal];

        // update fb status in both db and variable
        [sharedCenter updateGGLoginStatus:YES];
    }

    // send the data to server
    NSString *fullName = user.profile.name;
    NSString *email = user.profile.email;

    NSLog(@"did SignIn in setting");

    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];

    safeSet(jsonable, @"name", fullName);
    safeSet(jsonable, @"email", email);
    safeSet(jsonable, @"platform", @"google");

    [self sendDataToServer:jsonable];
}

- (IBAction)ggLoginClicked:(id)sender {
    if (sharedCenter.ggLogin == YES) {
        [self displayLogoutConf:@"Google"];
        return;
    }

    [[GIDSignIn sharedInstance] signIn];
}


// Once the button is clicked, show the login dialog    
- (IBAction)fbLoginClicked:(id)sender {

    if (sharedCenter.fbLogin == YES) {
        [self displayLogoutConf:@"Facebook"];
        return;
    }

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
    fromViewController:self
    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self handleLoginResult];
         }
     }];
}

- (void)displayLogoutConf:(NSString *)type {

    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Log Out"
                                                     message:[NSString stringWithFormat:
                                                             @"Are you sure you want to logout %@?", type]
                                                    delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];

    alert.alertViewStyle = UIAlertViewStyleDefault;

    if ([type isEqualToString:@"Facebook"]) {
        alert.tag = 202;    // logout facebook
    } else {
        alert.tag = 203;    // logout google
    }

    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 202) { // logout facebook
        // 1st Other Button

        NSLog(@"btn clicked %d", buttonIndex);
        if (buttonIndex == 0) {
            [self handleFBLogout];
        } else {
            return;
        }
    } else if (alertView.tag == 203) {  // logout google

        if (buttonIndex == 0) {
            [self handleGGLogout];
        } else {
            return;
        }
    }

}

- (void)handleGGLogout {

    if (sharedCenter.ggLogin == YES) {
        [[self ggLoginBtn] setTitle:@"Google Login" forState:UIControlStateNormal];
        [[self ggLoginBtn]setAlpha:1.0];
        [sharedCenter updateGGLoginStatus:NO];
        [[GIDSignIn sharedInstance] signOut];

    }
}

// handle logout
- (void)handleFBLogout {
    if (sharedCenter.fbLogin == YES) {
        [[self fbLoginBtn] setTitle:@"Facebook Login" forState:UIControlStateNormal];
        [[self fbLoginBtn]setAlpha:1.0];
        [sharedCenter updateFBLoginStatus:NO];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
}

// handle login
-(void) handleLoginResult {

    if (sharedCenter.fbLogin == NO) {
        [[self fbLoginBtn] setTitle:@"Facebook Logout" forState:UIControlStateNormal];

        // update fb status in both db and variable
        [sharedCenter updateFBLoginStatus:YES];
        [self prepareDataForServerFB];
    }
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

    // server URL is decided on by 'server'

    NSString *dbAddress = [NSString stringWithFormat:@"http://%@:%@/%@", [sharedCenter server], kPort, kCollection];

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


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}



- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"exit the view");
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"update appInfo set fieldValue='%.4f' where fieldKey='speakSpeed';", self.SpeedSlider.value];

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

    [super viewWillDisappear:animated];

}

- (IBAction)speedChange:(id)sender {

    NSLog(@"speed=%3f", self.SpeedSlider.value);
    
    [sharedCenter setTalkSpeed:self.SpeedSlider.value];
    self.speedDisplay.text = [NSString stringWithFormat:@"Talking Speed(%.2f)", self.SpeedSlider.value];
    
}


- (IBAction)speakWithTestSpeed:(id)sender {
    [sharedCenter SpeakOut:@"Hello, welcome to project eric"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
