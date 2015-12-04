//
//  TutorialViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/2/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "TutorialViewController.h"
#import "ResourceCenter.h"
#import "SlideTutorialViewController.h"
#import "EmergencyTableViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController {
    ResourceCenter *sharedCenter;
}

- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];

}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];

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

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconEmergency, nil]];


}

-(void) emergencyPage:(id)sender {
    [sharedCenter SpeakOut:@"emergency"];

    EmergencyTableViewController *eViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"emergency"];
    [self.navigationController pushViewController:eViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"hearing"] || [[segue identifier] isEqualToString:@"nonenglish"]) {
        SlideTutorialViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];

    }
}

@end
