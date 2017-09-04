//
//  ViewControllerOne.h
//  Test
//
//  Created by Dev on 8/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "CategoriesViewController.h"


@interface ViewControllerOne : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableDictionary *allRestaurantsByFirstChar;
@property (strong, nonatomic) NSMutableDictionary *allRestaurantsById;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end
