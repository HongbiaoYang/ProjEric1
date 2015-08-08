//
//  ItemTableViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 8/5/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "ItemTableViewController.h"
#import "TTSItemStruct.h"
#import "ItemTableViewCell.h"
#import <AVFoundation/AVSpeechSynthesis.h>


NSString *getPathByCategory(NSString *category);

@interface ItemTableViewController ()

@end

NSString *getPathByCategory(NSString *category) {
    if ([category isEqualToString:@"gettingon"]) {

        return [[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"];

    } else if ([category isEqualToString:@"riding"]) {
        return [[NSBundle mainBundle] pathForResource:@"xml/ridingbus" ofType:@"xml"];

    } else if ([category isEqualToString:@"safety"]) {
        return [[NSBundle mainBundle] pathForResource:@"xml/safety" ofType:@"xml"];

    } else if ([category isEqualToString:@"emergency"]) {
        return [[NSBundle mainBundle] pathForResource:@"xml/emergency" ofType:@"xml"];
    } else {
        return NULL;
    }
    
}

@implementation ItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    elementToParse = [[NSArray alloc] initWithObjects:@"Title",@"Text",
                      @"titulo",@"texto",@"Image",@"ImageV",nil];
    
    [self loadXML];
    
}


- (void)loadXML {

    // NSLog(@"category=%@", [self category]);

    // NSString *path = [[NSBundle mainBundle] pathForResource:@"xml/gettingonoff" ofType:@"xml"];
    NSString *path = getPathByCategory([self category]);

    NSFileHandle * file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    // NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"data string=%@", dataString);
    
    NSXMLParser *m_parser = [[NSXMLParser alloc]initWithData:data];
    [m_parser setDelegate:self];
    
    BOOL flag = [m_parser parse];
    if (flag) {
        NSLog(@"Parse succeed %ld!", items.count);
    } else {
        NSLog(@"Parse failed!");
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath=%ld", [indexPath row]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    long row = [indexPath row];
    TTSItemStruct *sItem = items[row];


    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:sItem.text];
    [utterance setRate:0.2f];
    [synthesizer speakUtterance:utterance];

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




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    // in iOS 7 regardless of orientation width is the shorter side
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    return height / 3;
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:@"General"] || [elementName isEqualToString:@"Emergency"]) {
        // NSLog(@"items=%@", items);
        items = [[NSMutableArray alloc] init];
        
    } else if ([elementName isEqualToString:@"Item"]) {
        aItem = [[TTSItemStruct alloc] init];
    }
    storingFlag = [elementToParse containsObject:elementName];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"ItemTableCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    long row = [indexPath row];
    
    TTSItemStruct *tItem = items[row];
    // NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem, items.count);
    
    cell.itemLabel.text = [tItem title];
    NSString *imageName = [NSString stringWithFormat:@"sym/%@",[tItem image] ];
    cell.itemImage.image = [UIImage imageNamed: imageName];



    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
