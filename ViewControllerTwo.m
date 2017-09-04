//
//  ViewControllerTwo.m
//  Test
//
//  Created by Dev on 8/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//



#import "ViewControllerTwo.h"
#import "ViewControllerOne.h"
#import "CategoriesViewController.h"
#import "SQLiteManager.h"


NSString * const CGEdit = @"Edit";
NSString * const CGDone = @"Done";

@interface ViewControllerTwo ()

{
    NSMutableArray *_IDs;
    NSMutableDictionary *_names;

}


@end



@implementation ViewControllerTwo

- (instancetype)init
{
    self = [super init];
    
    return self;
}


- (void)dealloc
{
    self.table = nil;
    [_IDs release];
    [_names release];
    
    [super dealloc];
}


-(void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:CGEdit
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(editRestaurants:)] autorelease];
    self.title = @"Favorites";
    self.table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 414, 714)
                                               style:UITableViewStylePlain] autorelease];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.view addSubview:self.table];
   
    self.navigationController.navigationBar.translucent = YES;
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    
    [super viewDidLoad];

}


- (void)viewWillAppear:(BOOL)animated
{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _bufIDs = [[NSMutableArray alloc] initWithArray:[_userDefaults objectForKey:@"Favorites"]];
    NSString *query = @"SELECT id FROM ch_restaurant";
    NSArray *result = [[SQLiteManager singleton] executeSql:query];
    NSMutableArray *buf1 = [[[NSMutableArray alloc] init] autorelease];
    _IDs = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < result.count; i++)
    {
        id a = [result objectAtIndex:i];
        [buf1 addObject:[a allValues]];
        id b = [buf1 objectAtIndex:i];
        id c = [b objectAtIndex:0];
        [_IDs addObject:c];
    }
   
    _names = [[NSMutableDictionary alloc] init];
   
    for(NSUInteger i = 0; i < result.count; i++)
    {
        
        NSString *querry = @"SELECT name,id FROM ch_restaurant WHERE id=%@" ;
        NSString *ID = [_IDs objectAtIndex:i];
        
        [_names setObject:[self execSQL:querry
                                 withID:ID
                            searchField:@"name"]
                   forKey:ID];
    }
    
    [_names keysSortedByValueUsingSelector:@selector(compare:)];
    _arrayData = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0 ; i <  _bufIDs.count; i++)
    {
        [_arrayData addObject:[_names objectForKey:[_bufIDs objectAtIndex:i]]];
    }
    [self.table reloadData];
    
    
    
    
    [super viewWillAppear:YES];
}


- (IBAction)editRestaurants:(id)button
{
    self.navigationItem.rightBarButtonItem.title = CGDone;
    self.navigationItem.rightBarButtonItem.action = @selector(doneEditRestaurants:);
    
    [self.table setEditing:YES
                  animated:YES];
}


- (IBAction)doneEditRestaurants:(id)button
{
    self.navigationItem.rightBarButtonItem.title = CGEdit;
    self.navigationItem.rightBarButtonItem.action = @selector(editRestaurants:);
    
    [self.table setEditing:NO
                  animated:YES];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"] ;
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]autorelease];
    }
 
    cell.textLabel.text = [_arrayData objectAtIndex:indexPath.row];
    
    
    NSString *querry = @"SELECT file_path FROM ch_restaurant_logo WHERE restaurant_id=%@";
    cell.imageView.image = [UIImage imageNamed:[self execSQL:querry
                                                   withID:[ _bufIDs objectAtIndex:indexPath.row]
                                                   searchField:@"file_path"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    return cell;
}


-(NSString*) execSQL:(NSString*)querry withID:(NSString*)ID searchField:(NSString*)field
{
    return [[[SQLiteManager singleton] executeSql:[NSString stringWithFormat:querry, ID]] objectAtIndex:0][field];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [_arrayData removeObjectAtIndex:indexPath.row];
        [_bufIDs removeObjectAtIndex:indexPath.row];
         [[PlusProcessing singleton]removeObject:indexPath.row];
        [_table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *restaurantID = [_bufIDs objectAtIndex:indexPath.row];
    CategoriesViewController *detailView = [[CategoriesViewController alloc] initWithRestID:restaurantID];
    
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView autorelease];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (void)refreshTable
{
    [_refreshControl endRefreshing];
    [self.table reloadData];
}




@end
