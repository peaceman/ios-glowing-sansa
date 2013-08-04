//
//  LodgesViewController.m
//  LodgeManager
//
//  Created by Nico Nägele on 7/21/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "LodgesViewController.h"
#import "APIClient.h"
#import "SVPullToRefresh.h"
#import "AFHTTPRequestOperation.h"

@interface LodgesViewController ()
- (void)loadNextEntries;
@end

@implementation LodgesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    __weak id weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadNextEntries];
    }];
    [self fetchLodges];
}



- (void)fetchLodges
{
    APIClient* apiClient = [APIClient sharedInstance];
    [apiClient fetchLodges:^(id JSON) {
        self.lodges = [JSON objectForKey:@"lodges"];
        [self.tableView reloadData];
    }];
}

- (void)loadNextEntries
{
    APIClient* apiClient = [APIClient sharedInstance];
    [apiClient fetchNextLodges:^(id JSON) {
        self.lodges = [self.lodges arrayByAddingObjectsFromArray:[JSON objectForKey:@"lodges"]];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lodges && self.lodges.count) {
        return self.lodges.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LodgeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* lodge = [self.lodges objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [lodge objectForKey:@"name"];
    cell.detailTextLabel.text = [lodge objectForKey:@"description"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
