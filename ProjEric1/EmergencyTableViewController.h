//
//  EmergencyTableViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/2/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBManager;

@interface EmergencyTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@property NSMutableArray *items;
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, copy) NSString *from;
@end
