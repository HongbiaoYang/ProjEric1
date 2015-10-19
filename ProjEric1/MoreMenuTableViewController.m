//
//  MoreMenuTableViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 10/4/15.
//  Copyright © 2015 Bill. All rights reserved.
//

#import "MoreMenuTableViewController.h"
#import "XMLListParser.h"
#import "ResourceCenter.h"
#import "MoreItemTableViewCell.h"
#import "TTSItemStruct.h"
#import "DBManager.h"

@interface MoreMenuTableViewController () {
    ResourceCenter *sharedCenter;
}

@property (nonatomic, strong) DBManager *dbManager;

@property(nonatomic, strong) UITapGestureRecognizer *dpGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer *lpGesgure;
@end

@implementation MoreMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *paths = [[NSArray alloc] initWithObjects:
                    [[NSBundle mainBundle] pathForResource:@"xml/response" ofType:@"xml"],
                      nil];
    
    NSArray *elements = [[NSArray alloc] initWithObjects:@"Title",@"Text",
                         @"Titulo",@"Texto",@"Image",@"ImageV",@"Customize",nil];
    
    
    XMLListParser *xmlParser = [[XMLListParser alloc]init];
    //[self setItems:[xmlParser loadMultiXML:paths withElements:elements]];

    NSMutableArray *xmlItems = [xmlParser loadMultiXML:paths withElements:elements];
    NSLog(@"more from %@", [self from]);

    // create dbManager
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"projEric.sql"];

    // customized array from user input
    NSString *query = @"select itemDesc from CustomItem order by itemID desc";
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self convertValueToItem:customArray];

    // add input option if from hearing/main
    NSLog(@"from %@", [self from]);
    if ([[self from] isEqualToString:@"displayMore-hearing"]|| [[self from] isEqualToString:@"hearingMore"] ||
            [[self from] isEqualToString:@"mainMore"]) {

        TTSItemStruct *aItem = [[TTSItemStruct alloc] init];
        aItem.title = @"Input Your Text...";
        aItem.image = @"picture108.png";
        aItem.imageV = @"input";

        [customArrayItems insertObject:aItem atIndex:0];

        NSLog(@"input item= %@", aItem);

        // combine the arrays together
        [customArrayItems addObjectsFromArray:xmlItems];
        NSLog(@"array = %@", customArrayItems);

        [self setItems:customArrayItems];
    } else {
        [self setItems:xmlItems];
    }


    self.view.backgroundColor = [UIColor blackColor];

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    
    sharedCenter = [ResourceCenter sharedResource];
    
    [self.navigationController setToolbarHidden:YES];

    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;

    self.lpGesgure = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];

    if ([self.from isEqualToString:@"cognitiveMore"]) {
        [self.view addGestureRecognizer:self.lpGesgure];
        NSLog(@"in lp from =%@", [self from]);

    } else {
        [self.view addGestureRecognizer:self.dpGesture];
        NSLog(@"in dp from =%@", [self from]);

    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code

        CGPoint dpLocation = [sender locationInView:self.tableView];
        NSIndexPath  *dpIndexPath = [self.tableView indexPathForRowAtPoint:dpLocation];

        [self handleItemAtRowOf:[dpIndexPath row]];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpGesgure]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            CGPoint lpLocation = [sender locationInView:self.tableView];
            NSIndexPath  *lpIndexPath = [self.tableView indexPathForRowAtPoint:lpLocation];

            [self handleItemAtRowOf:[lpIndexPath row]];

        }
    }
}


- (void)handleItemAtRowOf:(NSInteger)row {

    TTSItemStruct *sItem = self.items[row];

    if ([sItem.imageV isEqualToString:@"input"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add..." message:@"Input Your Text" delegate:self
                                               cancelButtonTitle:@"Save" otherButtonTitles:@"Speak", nil];

        alert.alertViewStyle = UIAlertViewStylePlainTextInput;

        [alert show];

    } else  {
        [sharedCenter SpeakOut:sItem.text];
    }

}


- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpGesgure]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            CGPoint lpLocation = [sender locationInView:self.tableView];
            NSIndexPath  *lpIndexPath = [self.tableView indexPathForRowAtPoint:lpLocation];
            long row = [lpIndexPath row];
            TTSItemStruct *sItem = self.items[row];

            [sharedCenter SpeakOut:sItem.text];
        }
    }
}




- (NSMutableArray *)convertValueToItem:(NSMutableArray *)array {
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];

    for (NSArray *textArr in array) {
        NSLog(@"array=%@ test=%@",array, [textArr objectAtIndex:0]);
        TTSItemStruct *aItem = [[TTSItemStruct alloc] initItemWithText:[textArr objectAtIndex:0]];
        [itemArray addObject:aItem];
    }

    NSLog(@"itemarray=%@", itemArray);
    return itemArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"self items %d", [[self items] count]);

    return [[self items] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    if ([[self from] isEqualToString:@"cognitiveMore"]) {
        return [ResourceCenter screenSize].height / 2;
    } else  {
        return [ResourceCenter screenSize].height / 3;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"MoreTableCell";
    MoreItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    TTSItemStruct *tItem = self.items[row];
    // NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem, [[self items] count]);

    if ([[self from] isEqualToString:@"nonenglishMore"] || [[self from] isEqualToString:@"displayMore-nonenglish"]) {
        cell.MoreLabel.text = [[tItem titulo] stringByAppendingFormat:@" / %@", [tItem title]];
    } else {
        cell.MoreLabel.text = [tItem title];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"sym/%@", [tItem image]];
    cell.MoreImage.image = [UIImage imageNamed:imageName];
    
    
    // blackground color of each cell
    UIColor *blueBack = [UIColor colorWithRed: 64.0/255.0f green:147.0/255.0f blue:223.0/255.0f alpha:1.0];
    cell.MoreLabel.backgroundColor = blueBack;
    cell.MoreLabel.textColor = [UIColor whiteColor];
    [cell.MoreLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    
    cell.MoreImage.backgroundColor = [UIColor blueColor];
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    long row = [indexPath row];
//    TTSItemStruct *sItem = self.items[row];
//
//
//    if ([sItem.imageV isEqualToString:@"input"]) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add..." message:@"Input Your Text" delegate:self
//                                               cancelButtonTitle:@"Save" otherButtonTitles:@"Speak", nil];
//
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//
//        [alert show];
//
//    } else  {
//        [sharedCenter SpeakOut:sItem.text];
//    }


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@ idx=%d",[[alertView textFieldAtIndex:0] text], buttonIndex);
    if (buttonIndex == 1) {
        [sharedCenter SpeakOut:[[alertView textFieldAtIndex:0] text]];
    } else if (buttonIndex == 0) {
        [self addCustomItem:[[alertView textFieldAtIndex:0] text]];
    } else {
        NSLog(@"Something is wrong, index=%d", buttonIndex);
    }
}


- (void)addCustomItem:(NSString *)text {

    NSString *query = [NSString stringWithFormat:@"insert into customItem values (null, '%@');", text];

    // NSLog(@"query=%@", query);

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        TTSItemStruct *aItem = [[TTSItemStruct alloc] init];
        aItem.title = text;
        aItem.text = text;
        aItem.image = @"customize.png";
        aItem.imageV = @"added";

        [[self items] insertObject:aItem atIndex:1];
        [[self tableView] reloadData];
    }
    else{
        NSLog(@"Could not execute the query.", self.dbManager);
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"will disappear");
    [[self navigationController] setToolbarHidden:NO];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];
    if (sItem.imageV == @"added") {
        return YES;
    } else {
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];

    [[self items] removeObject:sItem];

    [self updateDeleteItems:sItem];
    [[self tableView] reloadData];



    NSLog(@"delete");

}

- (void)updateDeleteItems:(TTSItemStruct *)aStruct {

    NSString *query = [NSString stringWithFormat:@"delete from customItem where itemDesc= '%@';", aStruct.title];

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);

    }
    else{
        NSLog(@"Could not execute the query.", self.dbManager);
    }


}


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
