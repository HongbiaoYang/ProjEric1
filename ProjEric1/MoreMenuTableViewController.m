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

@interface MoreMenuTableViewController () {
    ResourceCenter *sharedCenter;
}

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
                    [[NSBundle mainBundle] pathForResource:@"xml/response" ofType:@"xml"],
                      nil];
    
    NSArray *elements = [[NSArray alloc] initWithObjects:@"Title",@"Text",
                         @"Titulo",@"Texto",@"Image",@"ImageV",nil];
    
    
    XMLListParser *xmlParser = [[XMLListParser alloc]init];
    [self setItems:[xmlParser loadMultiXML:paths withElements:elements]];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:252.0 green:218.0 blue:75.0 alpha:1.0f]];
    
    sharedCenter = [ResourceCenter sharedResource];
    
    // NSLog(@"Inside More Menu view %@ count=%ld", paths, [[self items] count]);

    
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

    return [[self items] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    return height / 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"MoreTableCell";
    MoreItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    TTSItemStruct *tItem = self.items[row];
    // NSLog(@"row=%ld text=%@ img=%@ item=%@ count=%ld", row, tItem.text, tItem.image, tItem, [[self items] count]);
    
    cell.MoreLabel.text = [tItem title];
 
    
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
    
    long row = [indexPath row];
    TTSItemStruct *sItem = self.items[row];
    
    [sharedCenter SpeakOut:sItem.text];
    
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
