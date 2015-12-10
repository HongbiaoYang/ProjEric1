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

    // set transit to para by default, in the very first page
    [sharedCenter setTransit:@"para"];

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

    sharedCenter = [ResourceCenter sharedResource];

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



    // premium stuff
    self.dbManager = [sharedCenter dbManager];
    // get array with or without user input items
    NSString *query = [[NSString alloc] initWithFormat:@"select fieldValue from appInfo where fieldKey = 'startTime'"];

    NSArray *arrInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    long startTime =  [[[arrInfo objectAtIndex:0] objectAtIndex:0] intValue];

    if (startTime == 0) {
        long now = (long) [[NSDate date] timeIntervalSince1970];
        NSString *query = [NSString stringWithFormat:
                @"update appInfo set fieldValue='%d' where fieldKey='startTime';", now];

        // Execute the query.
        [self.dbManager executeQuery:query];

        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else{
            NSLog(@"Could not execute the query.");
        }

        startTime = now;
    }

    long interval = (long) [[NSDate date] timeIntervalSince1970] - startTime;

//    NSLog(@"now= %ld intervel=%ld", startTime, interval);

    if (interval < 24 * 60 * 60) {
//    if (interval < 24 ) {

        int remain = 24 * 60 * 60 - interval;
        
        int hour = remain / (60*60);
        int second = remain % 60;
        int minute = (remain - hour * 60 * 60)/60;

        NSString *message = [[NSString alloc] initWithFormat:
                @"Your trial has %d hours, %d minutes, %d seconds remaining", hour, minute, second];

        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"\u231B Trial Version"
                                                         message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];

        alert.alertViewStyle = UIAlertViewStyleDefault;
        alert.tag = 200;


        [alert show];
    } else {

        [self displayAlertView];

    }
}

- (void)displayAlertView {
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"\u26D4 Trial Version"
                                                     message:@" Your trial has expired!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];

    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = 404;


    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 404) {
        // 1st Other Button

        if (buttonIndex == 0) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                    @"http://projectericutk.blogspot.com/p/welcome-to-project-eric.html"]];

            NSLog(@"you are expired=%ld tag=%d", (long)buttonIndex, alertView.tag);


            [self displayAlertView];

        }
    }

}


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
