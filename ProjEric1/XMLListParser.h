//
//  XMLListParser.h
//  ProjEric1
//
//  Created by hongbiao yang on 8/15/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//



#import <Foundation/Foundation.h>

@class TTSItemStruct;

@interface XMLListParser : NSObject <NSXMLParserDelegate> {

     TTSItemStruct *aItem;
     BOOL storingFlag;
     NSArray *elementToParse;
     NSMutableString *currentElementValue;

}

@property NSMutableArray *items;
@property NSMutableArray *allItems;

- (NSMutableArray *)loadXML:(NSString *)path withElements:(NSArray *)elements;
- (NSMutableArray *)loadMultiXML:(NSArray *)paths withElements:(NSArray *)elements;

@end
