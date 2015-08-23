//
//  ViewController.m
//  ProjEric1
//
//  Created by Bill on 7/17/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ViewController.h"
#import "HearingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    _YesButton.backgroundColor = [UIColor yellowColor];
    _NoButton.backgroundColor = [UIColor yellowColor];
    _MoreButton.backgroundColor = [UIColor yellowColor];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"hearing"] || [[segue identifier]isEqualToString:@"nonenglish"]) {
        HearingViewController *subViewController = [segue destinationViewController];
        subViewController.subMenu = [segue identifier];
    }
    
}


@end
