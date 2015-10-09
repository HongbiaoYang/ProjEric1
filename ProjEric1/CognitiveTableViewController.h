//
//  CognitiveTableViewController.h
//  ProjEric1
//
//  Created by hongbiao yang on 8/15/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMLListParser;

@interface CognitiveTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;

@property  XMLListParser *xmlParser;
@property(nonatomic, strong) NSMutableArray *items;
@end
