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
#import "XMLListParser.h"
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
                      @"Titulo",@"Texto",@"Image",@"ImageV",nil];

    NSString *path = getPathByCategory([self category]);

    XMLListParser *xmlParser = [[XMLListParser alloc]init];
    [self setItems:[xmlParser loadXML:path withElements:elementToParse]];
    self.view.backgroundColor = [UIColor blackColor];

    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = [self category];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath=%ld", [indexPath row]);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];


    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:sItem.text];
    [utterance setRate:0.2f];
    [synthesizer speakUtterance:utterance];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    // in iOS 7 regardless of orientation width is the shorter side
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    return height / 3;
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
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"ItemTableCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    long row = [indexPath row];
    
    TTSItemStruct *tItem = self.items[row];
    // NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem, items.count);

    if ([[self subMenu] isEqualToString:@"hearing"]) {
        cell.itemLabel.text = [tItem title];
    } else if ([[self subMenu] isEqualToString:@"nonenglish"]) {
        cell.itemLabel.text = [tItem titulo];
    }

    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem image]];
    cell.itemImage.image = [UIImage imageNamed:imageName];


    // blackground color of each cell
    UIColor *blueBack = [UIColor colorWithRed: 64.0/255.0f green:147.0/255.0f blue:223.0/255.0f alpha:1.0];
    cell.itemLabel.backgroundColor = blueBack;
    cell.itemLabel.textColor = [UIColor whiteColor];
    [cell.itemLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];

    cell.itemImage.backgroundColor = [UIColor blueColor];

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
