//
//  DisplayViewController.h
//  ProjEric1
//
//  Created by Hongbiao Yang on 7/29/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSItemStruct;


@interface DisplayViewController : UIViewController<NSXMLParserDelegate> {


    NSMutableString *currentElementValue;
    NSMutableArray *items;
    TTSItemStruct *aItem;
    BOOL storingFlag;
    NSArray *elementToParse;

}

@property (weak, nonatomic)
IBOutlet UIScrollView *scroller;
@property NSArray *xmlItems;


@end
