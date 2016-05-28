//
//  MoreMenuTableViewController.m
//  ProjEric1
//
//  Created by Hongbiao Yang on 10/4/15.
//  Copyright © 2015 Bill. All rights reserved.
//

#import "MoreMenuTableViewController.h"
#import "ResourceCenter.h"
#import "MoreItemTableViewCell.h"
#import "TTSItemStruct.h"
#import "DBManager.h"
#include "constant.h"

@interface MoreMenuTableViewController () {
    ResourceCenter *sharedCenter;
}

@property  BOOL drill;
@property (nonatomic, strong) DBManager *dbManager;

@property(nonatomic, strong) UITapGestureRecognizer *dpGesture;
@property(nonatomic, strong) UILongPressGestureRecognizer *lpGesture;
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
                @"select * from %@Table where menu = 'response' order by hearing desc, itemID asc", [sharedCenter transit]];
    } else {
        query = [[NSString alloc] initWithFormat:
                @"select * from %@Table where menu = 'response' and customize != 'input' order by hearing desc, itemID asc"
                , [sharedCenter transit]];
    }



    // obtain and flatten the list
    NSMutableArray *customArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSMutableArray *customArrayItems = [self.dbManager convertValueToItem:customArray];

    NSLog(@"array in More:%@", customArrayItems);

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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


    // show the toolbar, set it to transparent. If set it to hidden, goHome button will go wrong
    [self.navigationController setToolbarHidden:NO];


    // handle hand gesture
    self.dpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.dpGesture.numberOfTapsRequired = 2;

    self.lpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];

    self.spGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.spGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.spGesture];


    // set long press or double tap according to where it comes from
    if ([self.from isEqualToString:@"cognitiveMore"]) {
        [self.view addGestureRecognizer:self.lpGesture];
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
    if ([sender isEqual:self.lpGesture]) {
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
        
#if defined(LITE)

            NSString *message = @"This feature is only available in premium version";

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\u266B Lite Version"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];

            alert.alertViewStyle = UIAlertViewStyleDefault;
            alert.tag = 200;
            self.drill = YES;

            [alert show];
#else
        
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add..." message:@"Input Your Text" delegate:self
                                               cancelButtonTitle:@"Save" otherButtonTitles:@"Speak", nil];

            alert.alertViewStyle = UIAlertViewStylePlainTextInput;

            [alert show];
#endif

    } else  {

        [sharedCenter SpeakOut:sItem.text];

        // skip the frequency update process for demo item
        if ([sItem.customize isEqualToString:@"demo"])
            return;


        int freq;
        NSString *subMenu = nil;

        if ([[self from] isEqualToString:@"nonenglishMore"] || [[self from] isEqualToString:@"displayMore-nonenglish"]) {
            sItem.nonenglish += 10;
            freq = sItem.nonenglish;
            subMenu = @"nonenglish";

        } else if ([[self from] isEqualToString:@"cognitiveMore"]) {
            sItem.cognitive += 10;
            freq = sItem.cognitive;
            subMenu = @"cognitive";

        } else  {
            sItem.hearing += 10;
            freq = sItem.hearing;
            subMenu = @"hearing";
        }

        // database stuff: update the frequency value in database
        NSString *updateQuery = [[NSString alloc] initWithFormat:
                @"update %@Table set %@ = %d where title = '%@'", [sharedCenter transit], subMenu, freq,
                        [sItem.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];

        // Execute the query.
        [self.dbManager executeQuery:updateQuery];

        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        }
        else {
            NSLog(@"Could not execute the query.");
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

    NSLog(@"self items %lu", (unsigned long)[[self items] count]);

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
    cell.backgroundColor = [UIColor blackColor];

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

    if ([self drill] == YES) {
        return;
    }
    
    if (buttonIndex == 1) {

        NSString *text = [[alertView textFieldAtIndex:0] text];
        [sharedCenter SpeakOut:text];


        // switch server address with special keyword
        if ([text rangeOfString:@"switch server:"].location != NSNotFound) {
            [self switchServer:text];
        }
        
    } else if (buttonIndex == 0) {

        [self addCustomItem:[[alertView textFieldAtIndex:0] text]];
        [sharedCenter SpeakOut:[[alertView textFieldAtIndex:0] text]];
    } else {
        NSLog(@"Something is wrong, index=%ld", (long)buttonIndex);
    }
}

// switch server from debug console
- (void)switchServer:(NSString*) serverText {
    NSArray *serverArr = [serverText componentsSeparatedByString:@":"];

    if (serverArr != nil && serverArr.count > 1) {
        NSString *server = serverArr[1];

        if ([server isEqualToString:@"default"]) {
            sharedCenter.server = @"mydesk.desktops.utk.edu";
        } else {    // set server with ip address
            NSError *error = NULL;
            NSRegularExpression *regex =
                    [[NSRegularExpression alloc] initWithPattern:@"(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)"
                                                         options:0
                                                           error:&error];

            [regex enumerateMatchesInString:server options:0 range:NSMakeRange(0, server.length)
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                     sharedCenter.server = server;
                                 }];

        }


    }

}


- (void)addCustomItem:(NSString *)text {

    // query the maximum value of frequency
    NSString *queryMax = [NSString stringWithFormat:
            @"select max(hearing) from %@Table where menu = 'response'", [sharedCenter transit]];
    NSMutableArray *maxArray = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryMax]];

    // get the maximum frequency in the list
    int max = [[[maxArray objectAtIndex:0] objectAtIndex:0] intValue];

    // replace the ' to eliminate the confusion
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

    NSString *query = [NSString stringWithFormat:
            @"insert into %@Table values (null, '%@', '%@', 0,0, 'customize', 'customize', "
                    "'#00ffff','response','added', %d, 0, 0);", [sharedCenter transit], text, text, max + 1];

    // Execute the query.
    [self.dbManager executeQuery:query];

    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        TTSItemStruct *aItem = [[TTSItemStruct alloc] init];
        aItem.title = text;
        aItem.text = text;
        aItem.image = @"customize.png";
        aItem.imageV = @"customize.png";
        aItem.color = @"00ffff";
        aItem.customize = @"added";
        aItem.hearing = max + 1;

        [[self items] insertObject:aItem atIndex:1];
        [[self tableView] reloadData];
    }
    else{
        NSLog(@"Could not execute the query.");
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
    NSLog(@"can edit in more:%@|%@|", sItem.customize, sItem.title);


    if ([sItem.customize isEqualToString:@"added"]) {
        return YES;
    } else {
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                                            forRowAtIndexPath:(NSIndexPath *)indexPath {

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
        NSLog(@"Could not execute the query.");
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
