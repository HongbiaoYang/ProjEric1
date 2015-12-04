//
//  MainViewController.m
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "MainViewController.h"
#import "HearingViewController.h"
#import "ResourceCenter.h"
#import "SettingViewController.h"
#import "MoreMenuTableViewController.h"
#import "CognitiveTableViewController.h"
#import "EmergencyTableViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>


@interface MainViewController () {
    ResourceCenter *sharedCenter;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];

    self.navigationController.toolbar.barTintColor = [UIColor yellowColor];

    // determine the page title according to source segue
    if ([[self transit] isEqualToString:@"para"]) {
        self.navigationItem.title = @"Para Transit";
    } else {
        self.navigationItem.title = @"Fixed Transit";
    }

    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    sharedCenter = [ResourceCenter sharedResource];


    // add right up corner icons:     // add right up corner icons: setting and emergency
    UIImage *imgEmergency = [UIImage imageNamed:@"emergency_ico"];
    UIButton *btnEmergency = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmergency.bounds = CGRectMake(0, 0, imgEmergency.size.width, imgEmergency.size.height);
    [btnEmergency setImage:imgEmergency forState:UIControlStateNormal];
    UIBarButtonItem *iconEmergency = [[UIBarButtonItem alloc] initWithCustomView:btnEmergency];
    [btnEmergency addTarget:self action:@selector(emergencyPage:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconEmergency, nil]];

}
- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];
}

-(void) emergencyPage:(id)sender {
    [sharedCenter SpeakOut:@"emergency"];

    EmergencyTableViewController *eViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"emergency"];
    [self.navigationController pushViewController:eViewController animated:YES];
}

-(void) settingPage:(id)sender {
    [sharedCenter SpeakOut:@"setting"];

    SettingViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    [self.navigationController pushViewController:settingViewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"hearing"] || [[segue identifier]isEqualToString:@"nonenglish"]) {
        HearingViewController *subViewController = [segue destinationViewController];
        subViewController.subMenu = [segue identifier];
        subViewController.transit = [self transit];

    } else if ([[segue identifier] isEqualToString:@"mainMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];
    } else if ([[segue identifier] isEqualToString:@"cognitive"]) {
        CognitiveTableViewController *destinationVC = [segue destinationViewController];
        destinationVC.transit = [self transit];
    }
    
    NSLog(@"segue in main = %@", [segue identifier]);
}


@end
