//
//  CellPushViewController.m
//  Test
//
//  Created by Dev on 8/3/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import "CategoriesViewController.h"


@interface CategoriesViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIViewController *_prev;
}

@end


@implementation CategoriesViewController

- (instancetype)initWithRestID:(NSString *)ID
{
    self = [super init];
    
    if (self != nil)
    {
        _selectedId = ID;
        [self setValueToArrays];
    }
    
    return self;
}


- (void)dealloc
{
    self.table = nil;
    self.itemNames = nil;
    self.categoriesAndItems = nil;
    _selectedId = nil;
    self.categoriesByID = nil;
    self.arrayOfNames = nil;
  
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([[PlusProcessing singleton] isIdInArray:_selectedId])
    {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    }
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    self.title = @"";
    _prev = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count-2)];
    self.table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 414, 714)
                                              style:UITableViewStylePlain] autorelease];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(addRestaurantToFavorites:)] autorelease];
   
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.table addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.table reloadData];
    [super viewDidLoad];
}


- (void)setValueToArrays
{
    NSString *categoryQuerry = [@"SELECT DISTINCT category_id,name, id FROM ch_item WHERE restaurant_id=%@ ORDER BY id" autorelease];
    self.categoriesAndItems = [[SQLiteManager singleton] executeSql:[NSString stringWithFormat:categoryQuerry, self.selectedId]];
    self.itemNames = [NSMutableDictionary dictionary];
    self.categoriesByID = [NSMutableArray array];
    self.arrayOfNames = [NSMutableArray array];
    [self.arrayOfNames addObject:[[[NSMutableArray alloc] init] autorelease]];
    NSInteger k = 0;
    NSString *buf = [self.categoriesAndItems objectAtIndex:0][@"category_id"];
    for (NSUInteger i = 0; i < self.categoriesAndItems.count; i++)
    {
        if ([self.categoriesAndItems objectAtIndex:i][@"category_id"] != buf ||
            i == (self.categoriesAndItems.count - 1))
        {
            NSString *querry = [@"SELECT DISTINCT name FROM ch_category WHERE id=%@" autorelease];
            [self.categoriesByID addObject:[self execSQL:querry
                                                  withID:buf
                                             searchField:@"name"]];
            
            [self.itemNames setObject:[self.arrayOfNames objectAtIndex:(self.arrayOfNames.count-1)]
                               forKey:[self.categoriesByID objectAtIndex:(self.categoriesByID.count-1)]];
            
            buf = [self.categoriesAndItems objectAtIndex:i][@"category_id"];
            [self.arrayOfNames addObject:[NSMutableArray array]];
            k++;
        }
        [[self.arrayOfNames objectAtIndex:k] addObject:[self.categoriesAndItems objectAtIndex:i]];
    }

}


- (NSString *)execSQL:(NSString*)querry withID:(NSString*)ID searchField:(NSString*)field
{
    return [[[SQLiteManager singleton] executeSql:[NSString stringWithFormat:querry, ID]] objectAtIndex:0][field];
}



- (void)addRestaurantToFavorites:(id)button
{
    
    [[PlusProcessing singleton] pressPlusprocess:_selectedId];
    if([[PlusProcessing singleton] isIdInArray:_selectedId])
    {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    }
    [self viewDidAppear:NO];

    
    SystemSoundID soundID;
    NSURL *soundUrl = [NSURL fileURLWithPath:@"/Users/dev/Downloads/Add ArtWork FastFood/Fav.wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"] autorelease];
    }
    
    cell.textLabel.text = [[self.itemNames objectForKey:[[self.itemNames allKeys]
                                                         objectAtIndex:indexPath.section]]
                                                         objectAtIndex:indexPath.row][@"name"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [[self.itemNames objectForKey:[[self.itemNames allKeys] objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row][@"id"];
    ItemFields *detailView = [[[ItemFields alloc] initWithItemID:ID] autorelease];
    [self.navigationController pushViewController:detailView
                                         animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemNames.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.itemNames allKeys] objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.itemNames objectForKey:[[self.itemNames allKeys] objectAtIndex: section]] count];

}

- (void)refreshTable
{
    [_refreshControl endRefreshing];
    [self viewDidAppear:YES];
    [self.table reloadData];
    
}


@end
