//
//  EmergencyTableViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 12/2/15.
//  Copyright (c) 2015 Bill. All rights reserved.
//

#import "EmergencyTableViewController.h"
#import "ResourceCenter.h"
#import "DBManager.h"
#import "EmergencyTableViewCell.h"
#import "TTSItemStruct.h"
#import "MoreMenuTableViewController.h"

@interface EmergencyTableViewController ()

@property(nonatomic, strong) UITapGestureRecognizer *dpGesture;
@property(nonatomic, strong) UITapGestureRecognizer *spGesture;
@end

@implementation EmergencyTableViewController {
    ResourceCenter *sharedCenter;
}

- (IBAction)YesClicker:(id)sender {
}

- (IBAction)NoClicker:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    sharedCenter = [ResourceCenter sharedResource];

    // get database manager
    self.dbManager = [sharedCenter dbManager];

    NSLog(@"from emer ico:%@", self.dbManager);

    NSString *query = [[NSString alloc] initWithFormat:
            @"select * from paraTable where menu = 'emergency' order by hearing desc"];

    // obtain and flatten the list
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self.dbManager convertValueToItem:customArray];
    self.items = customArrayItems;

//    NSLog(@"item array in items:%@", customArray);

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];

    CGFloat width = [ResourceCenter screenSize].width / 3;
    self.YesItem.width = width;
    self.NoItem.width = width;
    self.MoreItem.width = width;

    // hide 'more' button if comes from cognitive
    if ([[self from] isEqualToString:@"cognitive"]) {

        NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];

// This is how you remove the button from the toolbar and animate it
        [toolbarButtons removeObject:self.MoreItem];
        [self setToolbarItems:toolbarButtons animated:YES];

        NSLog(@"emergency from %@", [self from]);
    }

    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.dpGesture];

    self.spGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.spGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.spGesture];

    [self.spGesture requireGestureRecognizerToFail:self.dpGesture];
    
}


- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code

        CGPoint dpLocation = [sender locationInView:self.tableView];
        NSIndexPath  *dpIndexPath = [self.tableView indexPathForRowAtPoint:dpLocation];
        long row = [dpIndexPath row];

        TTSItemStruct *sItem = self.items[row];

        [sharedCenter SpeakOut:sItem.text];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        [sharedCenter SpeakOut:@"please double tap to make a selection"];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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

    // Configure the cell...
    NSString *cellIdentifier = @"EmergencyTableCell";
    EmergencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    long row = [indexPath row];

    TTSItemStruct *tItem = self.items[row];

    cell.itemLabel.text = [tItem title];

    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem image]];
    cell.itemImage.image = [UIImage imageNamed:imageName];


    // blue background color of each cell
    UIColor *colorBack;

    if ([self from] != NULL && [[self from] isEqualToString:@"cognitive"]) {
        colorBack = [ResourceCenter colorFromHexString:tItem.color];
    } else {
        colorBack = [UIColor colorWithRed: 64.0/255.0f green:147.0/255.0f blue:223.0/255.0f alpha:1.0];
    }

    NSLog(@"from in emer=%@", [self from]);

    cell.itemLabel.backgroundColor = colorBack;
    cell.itemLabel.textColor = [UIColor whiteColor];
    [cell.itemLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];

    cell.itemImage.backgroundColor = [UIColor blueColor];

    return cell;
}

// in iOS 7 regardless of orientation width is the shorter side; in iOS8+ it is orientation dependent
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[self from] isEqualToString:@"cognitive"]) {
        return [ResourceCenter screenSize].height / 2;
    } else {
        return [ResourceCenter screenSize].height / 3;
    }

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
    if ([[segue identifier] isEqualToString:@"emergencyMore"]) {
        MoreMenuTableViewController *destinationViewController = [segue destinationViewController];
        destinationViewController.from = [segue identifier];

    }

}


@end
