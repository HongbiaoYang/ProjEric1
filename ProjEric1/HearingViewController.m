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


@interface HearingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gettingonoff;

@end

@implementation HearingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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

    ItemTableViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.category = [segue identifier];
    destinationViewController.subMenu = [self subMenu];


}


@end
