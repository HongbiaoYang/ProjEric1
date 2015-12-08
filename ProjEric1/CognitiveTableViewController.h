//
//  CognitiveTableViewController.h
//  ProjEric1
//
//  Created by hongbiao yang on 8/15/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBManager;

@interface CognitiveTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) NSObject *transit;
@end
