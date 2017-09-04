//
//  ItemFieldsView.m
//  Test
//
//  Created by TestDeveloper on 12/07/2017.
//  Copyright © 2017 TestDeveloper. All rights reserved.
//

#import "ItemFields.h"

@interface ItemFields ()

@end


@implementation ItemFields

- (instancetype)initWithItemID:(NSString*)ID
{
    self = [super init];
    if (self != nil)
    {
        self.itemID = ID;
        [self setValueToArrays];
        
    }
    return self;
}


- (void)dealloc
{
    self.table = nil;
    self.itemID = nil;
    self.sourseFields = nil;
    self.itemFields = nil;
    self.fieldsFromDB = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    self.table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 414, 714) style:UITableViewStylePlain] autorelease];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.view addSubview:self.table];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
}

- (void)setValueToArrays
{
    
    self.itemFields = @[@"Serving", @"Calories", @"Total fat", @"Saturated fat", @"Trans fats", @"Cholesterol", @"Sodium", @"Carbonates"];
    
    self.sourseFields = @[@"serving", @"calories", @"total_fat", @"saturated_fat", @"trans_fats", @"cholesterol", @"sodium", @"carbs"];
    
    NSString *query = @"SELECT serving,calories,total_fat,saturated_fat,trans_fats,cholesterol,sodium,carbs FROM ch_item WHERE id =\"%@\"";
    
    self.fieldsFromDB = [[SQLiteManager singleton] executeSql:[NSString stringWithFormat:query, self.itemID]];
   
}



#pragma mark

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = [self.itemFields objectAtIndex:indexPath.row];
    
    if([self.fieldsFromDB objectAtIndex:0][[self.sourseFields objectAtIndex:indexPath.row]] != nil)
    {
        cell.detailTextLabel.text = [self.fieldsFromDB objectAtIndex:0][[self.sourseFields objectAtIndex:indexPath.row]];
    }
    else
    {
        (cell.detailTextLabel.text = @"");
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemFields.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table deselectRowAtIndexPath:indexPath
                              animated:YES];
}

- (void)refreshTable
{
    [_refreshControl endRefreshing];
    [self.table reloadData];
}

@end
