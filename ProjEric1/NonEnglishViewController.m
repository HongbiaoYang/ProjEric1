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


@interface NonEnglishViewController () {
    ResourceCenter *sharedCenter;
}


@end

@implementation NonEnglishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [[self YesButton] setBackgroundColor: [UIColor yellowColor]];
    [[self NoButton] setBackgroundColor:[UIColor yellowColor]];
    [[self MoreButton] setBackgroundColor:[UIColor yellowColor]];

    sharedCenter = [ResourceCenter sharedResource];
}


- (IBAction)YesClick:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClick:(id)sender {
    [sharedCenter SpeakOut:@"No"];
}

- (IBAction)MoreClick:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ItemTableViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.category = [segue identifier];
    destinationViewController.subMenu = [self subMenu];

}


@end
