//
//  ViewControllerOne.m
//  Test
//
//  Created by Dev on 8/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import "ViewControllerOne.h"

@interface ViewControllerOne ()
{
    NSArray *_restaurantsIDs;
    NSArray *_restaurantsNames;
    BOOL _isSearching;
}

@end



@implementation ViewControllerOne

- (instancetype)init
{
    self = [super init];
    [self setValueToArraysFromDB];
    
    return self;
}


- (void)dealloc
{
    self.table = nil;
    self.allRestaurantsByFirstChar = nil;
    self.allRestaurantsById = nil;
    [_restaurantsIDs release];
    [_restaurantsNames release];
    self.searchResult = nil;
    self.searchController = nil;
    self.tags = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    self.table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 414, 714)
                                              style:UITableViewStylePlain] autorelease];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.searchController = [[[UISearchController alloc] initWithSearchResultsController:nil] autorelease];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.table.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.table];
    
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.title = @"Restaurants";

    
    [super viewDidAppear:animated];
}


- (void)setValueToArraysFromDB
{
    _restaurantsIDs = [[SQLiteManager singleton] executeSql:@"SELECT id FROM ch_restaurant ORDER BY name"];
    _restaurantsNames = [[[SQLiteManager singleton] executeSql:@"SELECT name FROM ch_restaurant ORDER BY name"] retain];
    self.searchResult = [NSArray array];
    
    NSString *temp = [[_restaurantsNames objectAtIndex:0][@"name"] substringToIndex:1];
    
    self.allRestaurantsByFirstChar = [NSMutableDictionary dictionary];
    [self.allRestaurantsByFirstChar setObject:[NSMutableArray array]
                                       forKey:temp];
    
    self.allRestaurantsById = [NSMutableDictionary dictionary];
    self.tags = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < _restaurantsNames.count; i++)
    {
        if([[_restaurantsNames objectAtIndex:i][@"name"] substringToIndex:1] != temp || i == (_restaurantsNames.count - 1) )
        {
            [self.tags addObject:temp];
            temp = [[_restaurantsNames objectAtIndex:i][@"name"] substringToIndex:1];
            [self.allRestaurantsByFirstChar setObject:[NSMutableArray array]
                                               forKey:temp];
        }
        
        [[self.allRestaurantsByFirstChar objectForKey:temp] addObject:[_restaurantsNames objectAtIndex:i][@"name"]];
        [self.allRestaurantsById setObject:[_restaurantsIDs objectAtIndex:i][@"id"]
                                    forKey:[_restaurantsNames objectAtIndex:i][@"name"]];
    }
    
}


- (NSArray*)currentNames:(NSInteger)index
{
    return [self.allRestaurantsByFirstChar objectForKey:[self.tags objectAtIndex:index]];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = (_isSearching) ? [self.searchResult objectAtIndex:indexPath.row][@"name"] : [[self currentNames:indexPath.section] objectAtIndex:indexPath.row];
    NSString *imageID = [self.allRestaurantsById objectForKey:cell.textLabel.text] ;
    NSString *querry = @"SELECT file_path FROM ch_restaurant_logo WHERE restaurant_id=%@" ;
    
    cell.imageView.image = [UIImage imageNamed:[self execSQL:querry
                                                      withID:imageID]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(NSString*) execSQL:querry withID:ID
{
    return [[[SQLiteManager singleton] executeSql:[NSString stringWithFormat:querry, ID]] objectAtIndex:0][@"file_path"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *restaurantID = [self.allRestaurantsById objectForKey:[self.table cellForRowAtIndexPath:indexPath].textLabel.text];
    CategoriesViewController *detailView = [[[CategoriesViewController alloc] initWithRestID:restaurantID] autorelease];
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? (@"Choose a restaurant") : (nil);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_isSearching) ? 1 : (self.tags.count);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_isSearching) ? (self.searchResult.count) : ([self currentNames:section].count);
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return (_isSearching) ? (nil) : (self.tags);
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    [searchController.searchBar becomeFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSearching = YES;
    
    [self updateSearchResultsForSearchController:self.searchController];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.searchResult = [_restaurantsNames filteredArrayUsingPredicate:
                         [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@", self.searchController.searchBar.text]];
    
    _isSearching = ([searchController.searchBar.text length] != 0);
    
    [self.table reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _isSearching = NO;
    
    [self.table reloadData];
}

- (void)refreshTable
{
    [_refreshControl endRefreshing];
    [self.table reloadData];
}

@end
