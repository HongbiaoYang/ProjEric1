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
@property(nonatomic, strong) UITapGestureRecognizer *spGesture;
@end

@implementation MoreMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // get sharedCenter
    sharedCenter = [ResourceCenter sharedResource];


    // ge dbManager from sharedCenter
    self.dbManager = [sharedCenter dbManager]; 
//            [[DBManager alloc] initWithDatabaseFilename:@"projEric.sql"];
    NSLog(@"db=%@ is from:%@", [self dbManager], [self from]);


    // get array with or without user input items
    NSString *query;
    if ([[self from] isEqualToString:@"displayMore-hearing"]|| [[self from] isEqualToString:@"hearingMore"] ||
            [[self from] isEqualToString:@"mainMore"] || [[self from] isEqualToString:@"homeMore"]) {
        query = [[NSString alloc] initWithFormat:
                @"select * from %@Table where menu = 'response' order by hearing desc", [sharedCenter transit]];
    } else {
        query = [[NSString alloc] initWithFormat:
                @"select * from %@Table where menu = 'response' and customize = 'normal' order by hearing desc"
                , [sharedCenter transit]];
    }

    // obtain and flatten the list
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self.dbManager convertValueToItem:customArray];


    // add input option if from hearing/main
    NSLog(@"from %@", [self from]);
    if ([[self from] isEqualToString:@"displayMore-hearing"]|| [[self from] isEqualToString:@"hearingMore"] ||
            [[self from] isEqualToString:@"mainMore"] || [[self from] isEqualToString:@"homeMore"]) {

        TTSItemStruct *aItem = [[TTSItemStruct alloc] init];
        aItem.title = @"Input Your Text...";
        aItem.image = @"picture108.png";
        aItem.customize = @"input";

        [customArrayItems insertObject:aItem atIndex:0];

        [self setItems:customArrayItems];
    } else {
        [self setItems:customArrayItems];
    }


    self.view.backgroundColor = [UIColor blackColor];

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];

    // show the toolbar, set it to transparent. If set it to hidden, goHome button will go wrong
    [self.navigationController setToolbarHidden:NO];


    // handle hand gesture
    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;

    self.lpGesgure = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];

    self.spGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.spGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.spGesture];


    // set long press or double tap according to where it comes from
    if ([self.from isEqualToString:@"cognitiveMore"]) {
        [self.view addGestureRecognizer:self.lpGesgure];
        NSLog(@"in lp from =%@", [self from]);

    } else {
        [self.view addGestureRecognizer:self.dpGesture];
        NSLog(@"in dp from =%@", [self from]);
    }

    [self.spGesture requireGestureRecognizerToFail:self.dpGesture];

    // add right up corner icons: sound animation and home
    UIImage *imgHome = [UIImage imageNamed:@"home"];
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.bounds = CGRectMake(0, 0, imgHome.size.width, imgHome.size.height);
    [btnHome setImage:imgHome forState:UIControlStateNormal];
    UIBarButtonItem *iconHome = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    [btnHome addTarget:self action:@selector(goHomePage:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: iconHome, [sharedCenter iconSound], nil]];
}

-(void) goHomePage:(id)sender {
    NSLog(@"goHomePage");

//    [self setToolbarItems:[[NSArray alloc] init] animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        // handling code
        if ([self.from isEqualToString:@"cognitiveMore"]) {
            [sharedCenter SpeakOut:@"please hold this button to make a selection"];
        } else {
            [sharedCenter SpeakOut:@"please double tap to make a selection"];
        }

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

    if ([sItem.customize isEqualToString:@"input"]) {
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
    NSLog(@"image in more:%@", imageName);
    
    
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
        [sharedCenter SpeakOut:[[alertView textFieldAtIndex:0] text]];
    } else {
        NSLog(@"Something is wrong, index=%d", buttonIndex);
    }
}


- (void)addCustomItem:(NSString *)text {

    NSString *query = [NSString stringWithFormat:
            @"insert into %@Table values (null, '%@', '%@', 0,0, 'customize', 'customize', "
                    "'#00ffff','response','added', 0,0,0);", [sharedCenter transit], text, text];

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
    [[self navigationController] setToolbarHidden:NO animated:animated];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.

    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];
    NSLog(@"can edit in more:%@|%@", sItem.customize, sItem.title);


    if ([sItem.customize isEqualToString:@"added"]) {
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

    NSString *query = [NSString stringWithFormat:
            @"delete from %@Table where title = '%@';", [sharedCenter transit], aStruct.title];

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
