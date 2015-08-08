//
//  DisplayViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 7/29/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "DisplayViewController.h"
#import "TTSItemStruct.h"


@interface DisplayViewController ()


@end



@implementation DisplayViewController

@synthesize scroller;
@synthesize xmlItems;

- (void)viewDidLoad {
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(0, 600)];
    [scroller setBounces:false];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    elementToParse = [[NSArray alloc] initWithObjects:@"Title",@"Text",
                    @"titulo",@"texto",@"Image",@"ImageV",nil];


    [self loadXML];

    
}

- (void)loadXML {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"];
    NSFileHandle * file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    // NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"data string=%@", dataString);
    
    NSXMLParser *m_parser = [[NSXMLParser alloc]initWithData:data];
    [m_parser setDelegate:self];

    BOOL flag = [m_parser parse];
    if (flag) {
        NSLog(@"Parse succeed %d!", items.count);
    } else {
        NSLog(@"Parse failed!");
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (void)parserDidEndDocument:(NSXMLParser *)parser {

}

- (void)parserDidStartDocument:(NSXMLParser *)parser {

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"General"]) {
        items = [[NSMutableArray alloc] init];

    } else if ([elementName isEqualToString:@"Item"]) {
        aItem = [[TTSItemStruct alloc] init];
    }
    storingFlag = [elementToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Item"]) {
        [items addObject:aItem];
        aItem = nil;
    }

    if (storingFlag) {
        NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        [currentElementValue setString:@""];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
