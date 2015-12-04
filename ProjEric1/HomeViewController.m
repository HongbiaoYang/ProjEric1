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

@interface HomeViewController ()

@end

@implementation HomeViewController {
    ResourceCenter *sharedCenter;
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