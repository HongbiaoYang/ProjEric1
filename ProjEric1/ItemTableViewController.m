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
#import "ResourceCenter.h"
#import "MoreMenuTableViewController.h"
#import <AVFoundation/AVSpeechSynthesis.h>


NSString *getPathByCategory(NSString *category);

@interface ItemTableViewController () {
    ResourceCenter *sharedCenter;
}

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

- (IBAction)YesClicker:(id)sender {
    [sharedCenter SpeakOut:@"Yes"];
}

- (IBAction)NoClicker:(id)sender {
    [sharedCenter SpeakOut:@"No"];
}


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
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = [self fullTitle:[self subMenu] category:[self category] ];
    sharedCenter = [ResourceCenter sharedResource];

    
    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;
}

- (NSString *)fullTitle:(NSString *)menu category:(NSString *)category {
    NSMutableString *title = [[NSMutableString alloc] init];

    if ([[menu lowercaseString] isEqualToString:@"hearing"]) {
        [title setString:@"Hearing->"];
        NSLog(@"if menu is hearing :%@", title);

        if ([[category lowercaseString] isEqualToString:@"gettingon"]) {
            [title appendString:@"Getting on and off the bus"];
        } else if ([[category lowercaseString] isEqualToString:@"riding"]) {
            [title appendString:@"Riding the bus"];
        } else if ([[category lowercaseString] isEqualToString:@"safety"]) {
            [title appendString:@"Safety"];
        } else if ([[category lowercaseString] isEqualToString:@"emergency"]) {
            [title appendString:@"Emergency"];
        } else {
            [title appendString:@"Unknown"];
        }


    } else if ([[menu lowercaseString] isEqualToString:@"nonenglish"]) {
        [title setString:@"Español->"];

        if ([[category lowercaseString] isEqualToString:@"gettingon"]) {
            [title appendString:@"Embarque"];
        } else if ([[category lowercaseString] isEqualToString:@"riding"]) {
            [title appendString:@"Viajar"];
        } else if ([[category lowercaseString] isEqualToString:@"safety"]) {
            [title appendString:@"Bajar"];
        } else if ([[category lowercaseString] isEqualToString:@"emergency"]) {
            [title appendString:@"Emergency"];
        } else {
            [title appendString:@"Unknown"];
        }
    }

    NSLog(@"menu=%@ cat=%@ title=%@", menu, category, title);


    return title;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath=%ld", [indexPath row]);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];

    [sharedCenter SpeakOut:sItem.text];
}


// in iOS 7 regardless of orientation width is the shorter side; in iOS8+ it is orientation dependent
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [ResourceCenter screenSize].height / 3;
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



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"displayMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [[segue identifier] stringByAppendingFormat:@"-%@", [self subMenu]];
    }
}


@end
