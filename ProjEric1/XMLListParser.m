//
//  XMLListParser.m
//  ProjEric1
//
//  Created by hongbiao yang on 8/15/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "XMLListParser.h"
#import "TTSItemStruct.h"


@implementation XMLListParser

NSArray *elementToParse;

- (NSMutableArray *)loadXML:(NSString *)path withElements:(NSArray *)elements {

    NSFileHandle * file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];

    // NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"data string=%@", dataString);

    // assign the elements for xml parse
    elementToParse = elements;

    NSXMLParser *m_parser = [[NSXMLParser alloc]initWithData:data];
    [m_parser setDelegate:self];

    BOOL flag = [m_parser parse];
    return [self items];

}

- (NSMutableArray *)loadMultiXML:(NSArray *)paths withElements:(NSArray *)elements {

    elementToParse = elements;

    self.allItems = [[NSMutableArray alloc] init];

    for(NSString *filename in paths) {
        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filename];
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        NSXMLParser *m_parser = [[NSXMLParser alloc]initWithData:data];
        [m_parser setDelegate:self];
        
        // NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        // NSLog(@"data string=%@", dataString);

        
        BOOL flag = [m_parser parse];
        [self.allItems addObjectsFromArray:self.items];

        // NSLog(@"all items=%@", [self allItems]);


    }
    return self.allItems;
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"Item"]) {

        [self.items addObject:aItem];
        aItem = nil;
    }

    if (storingFlag) {
        NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        [currentElementValue setString:@""];

        // NSLog(@"read titulo from xml:%@=====%@", elementName, trimmedString);



        if ([elementName isEqualToString:@"Title"]) {
            aItem.title = trimmedString;

        }

        if ([elementName isEqualToString:@"Text"]) {
            aItem.text = trimmedString;
        }

        if ([elementName isEqualToString:@"Titulo"]) {
            aItem.titulo = trimmedString;
        }

        if ([elementName isEqualToString:@"Image"]) {
            aItem.image = trimmedString;
        }

        if ([elementName isEqualToString:@"ImageV"]) {
            aItem.imageV = trimmedString;
        }
    }

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:@"General"] || [elementName isEqualToString:@"Emergency"]) {
        // NSLog(@"items=%@", items);

        self.items = [[NSMutableArray alloc] init];

    } else if ([elementName isEqualToString:@"Item"]) {
        aItem = [[TTSItemStruct alloc] init];
    }
    storingFlag = [elementToParse containsObject:elementName];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (storingFlag) {
        if (!currentElementValue) {
            currentElementValue = [[NSMutableString alloc] initWithString:string];
        } else {
            [currentElementValue appendString:string];
        }
    }

}


@end


