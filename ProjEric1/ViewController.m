//
//  ViewController.m
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ViewController.h"
#import "HearingViewController.h"
#import "ResourceCenter.h"
#import "SettingViewController.h"
#import "MoreMenuTableViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>


@interface ViewController () {
    ResourceCenter *sharedCenter;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];

    self.navigationController.toolbar.barTintColor = [UIColor yellowColor];

    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    sharedCenter = [ResourceCenter sharedResource];


    UIImage *imgEmergency = [UIImage imageNamed:@"emergency_ico"];
    UIButton *btnEmergency = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmergency.bounds = CGRectMake(0, 0, imgEmergency.size.width, imgEmergency.size.height);
    [btnEmergency setImage:imgEmergency forState:UIControlStateNormal];
    UIBarButtonItem *iconEmergency = [[UIBarButtonItem alloc] initWithCustomView:btnEmergency];

    //
    UIBarButtonItem *icoSetting = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingPage:)];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:28.0];
    NSDictionary *fontDict = @{NSFontAttributeName:customFont};
    [icoSetting setTitleTextAttributes:fontDict forState:UIControlStateNormal];


    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: icoSetting, iconEmergency, nil]];

}
- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];
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
    } else if ([[segue identifier] isEqualToString:@"mainMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];
    }
    
    NSLog(@"segue = %@", [segue identifier]);
}


@end
