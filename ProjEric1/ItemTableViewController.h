//
//  ItemTableViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 8/5/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSItemStruct;

@interface ItemTableViewController : UITableViewController <NSXMLParserDelegate> {
    
    NSMutableString *currentElementValue;
    NSMutableArray *items;
    TTSItemStruct *aItem;
    BOOL storingFlag;
    NSArray *elementToParse;
}

    @property NSString *category;


@end
