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



@interface HearingViewController () {
    ResourceCenter *sharedCenter;
}

@property (weak, nonatomic) IBOutlet UIButton *gettingonoff;

@end

@implementation HearingViewController

- (IBAction)YesClick:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];

}

- (IBAction)NoClick:(id)sender {
    [sharedCenter SpeakOut:@"No"];
}

- (IBAction)MoreClick:(id)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _YesButton.backgroundColor = [UIColor yellowColor];
    _NoButton.backgroundColor = [UIColor yellowColor];
    _MoreButton.backgroundColor = [UIColor yellowColor];


    sharedCenter = [ResourceCenter sharedResource];

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
    
    if ([[segue identifier] isEqualToString:@"hearingMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];
        
        NSLog(@"segue in Hearing=%@", [segue identifier]);
        
    } else {
        ItemTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.category = [segue identifier];
        destinationViewController.subMenu = [self subMenu];
    }


}


@end
