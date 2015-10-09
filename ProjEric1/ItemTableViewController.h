//
//  ItemTableViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 8/5/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSItemStruct;
@class XMLListParser;

@interface ItemTableViewController : UITableViewController {

    NSArray *elementToParse;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *YesItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MoreItem;


    @property NSString *category;
    @property NSString *subMenu;
    @property NSMutableArray *items;

@end
