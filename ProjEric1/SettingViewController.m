//
//  SettingViewController.m
//  ProjEric1
//
//  Created by hongbiao yang on 10/8/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "SettingViewController.h"
#import "ResourceCenter.h"
#import "DBManager.h"

ResourceCenter *sharedCenter;

@interface SettingViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrInfo;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.SpeedSlider.continuous = YES;

    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"projEric.sql"];
    self.view.backgroundColor = [UIColor blackColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    sharedCenter = [ResourceCenter sharedResource];

    float speedValueFromDB = [self loadSpeedFromDB];

    [sharedCenter setTalkSpeed:speedValueFromDB];
    self.SpeedSlider.value = [sharedCenter talkSpeed];
    self.speedDisplay.text = [NSString stringWithFormat:@"Talking Speed(%.2f)", [sharedCenter talkSpeed]];

}

- (float)loadSpeedFromDB {

    NSString *query = @"select fieldValue from appInfo where fieldKey = 'speakSpeed';";

    if (self.arrInfo != nil) {
        self.arrInfo = nil;
    }

    self.arrInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

//    // if there is no record in the database
//    if (self.arrInfo == nil) {
//        NSString *query = [NSString stringWithFormat:@"insert into appInfo values (null, 'speakSpeed', 0.3);", self.SpeedSlider.value];
//        [self.dbManager executeQuery:query];
//
//        // If the query was successfully executed then pop the view controller.
//        if (self.dbManager.affectedRows != 0) {
//            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
//        }
//        else{
//            NSLog(@"Could not execute the query.");
//        }
//
//        return 0.3f;
//    }

    NSString *speedStr = (NSString *) [[[self arrInfo] objectAtIndex:0] objectAtIndex:0];


    return (CGFloat) [speedStr floatValue];
}


- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"exit the view");
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"update appInfo set fieldValue='%.4f' where fieldKey='speakSpeed';", self.SpeedSlider.value];

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }

    [super viewWillDisappear:animated];

}

- (IBAction)speedChange:(id)sender {

    NSLog(@"speed=%3f", self.SpeedSlider.value);
    
    [sharedCenter setTalkSpeed:self.SpeedSlider.value];
    self.speedDisplay.text = [NSString stringWithFormat:@"Talking Speed(%.2f)", self.SpeedSlider.value];
    
}


- (IBAction)speakWithTestSpeed:(id)sender {
    [sharedCenter SpeakOut:@"Hello, welcome to project eric"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
