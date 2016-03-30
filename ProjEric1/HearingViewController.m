//
//  HearingViewController.m
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "HearingViewController.h"
#import "ItemTableViewCell.h"
#import "ItemTableViewController.h"
#import "ResourceCenter.h"
#import "MoreMenuTableViewController.h"
#import "SettingViewController.h"


@interface HearingViewController () {
    ResourceCenter *sharedCenter;
}

@property (weak, nonatomic) IBOutlet UIButton *gettingonoff;

@end

@implementation HearingViewController



- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];

}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.toolbar.barTintColor = [UIColor yellowColor];
    
    sharedCenter = [ResourceCenter sharedResource];
    [sharedCenter SpeakOut:@"hearing"];

    // Do any additional setup after loading the view.
    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;
    self.YesItem.title = @"Yes      \u2714";
    self.NoItem.title = @"No      \u2716";
    self.MoreItem.title = @"More      \u2605";

    // add right up corner icons: setting and emergency
    UIImage *imgHome = [UIImage imageNamed:@"home"];
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.bounds = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    UIBarButtonItem *iconHome = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    [btnHome addTarget:self action:@selector(goHomePage:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconHome, [sharedCenter iconSound], nil] animated:YES];

}

-(void) goHomePage:(id)sender {
    NSLog(@"goHomePage");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gettingClick:(id)sender {
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSLog(@"segue in Hearing=%@", [segue identifier]);


    if ([[segue identifier] isEqualToString:@"hearingMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];
        destinationViewController.transit = [segue identifier];

    } else {
        ItemTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.category = [segue identifier];
        destinationViewController.subMenu = [self subMenu];
        destinationViewController.transit = [self transit];
    }

}


@end
