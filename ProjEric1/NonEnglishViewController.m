//
//  NonEnglishViewController.m
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "NonEnglishViewController.h"
#import "ItemTableViewController.h"
#import "ResourceCenter.h"
#import "MoreMenuTableViewController.h"


@interface NonEnglishViewController () {
    ResourceCenter *sharedCenter;
}


@end

@implementation NonEnglishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.toolbar.barTintColor = [UIColor yellowColor];

    sharedCenter = [ResourceCenter sharedResource];
    
    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    // add right up corner icons: sound animation and home
    UIImage *imgHome = [UIImage imageNamed:@"home"];
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.bounds = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    UIBarButtonItem *iconHome = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    [btnHome addTarget:self action:@selector(goHomePage:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconHome, [sharedCenter iconSound], nil]];
}


-(void) goHomePage:(id)sender {
    NSLog(@"goHomePage");
    [self.navigationController popToRootViewControllerAnimated:YES];

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
    if ([[segue identifier] isEqualToString:@"nonenglishMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];

    } else {
        ItemTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.category = [segue identifier];
        destinationViewController.subMenu = [self subMenu];
        destinationViewController.transit = [self transit];
    }



}


@end
