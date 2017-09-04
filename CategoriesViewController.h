//
//  CellPushViewController.h
//  Test
//
//  Created by Dev on 8/3/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"
#import "ItemFields.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewControllerTwo.h"
#import "PlusProcessing.h"

@interface CategoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *itemNames;
@property (strong, nonatomic) NSArray *categoriesAndItems;
@property (strong, nonatomic) NSMutableArray *categoriesByID;
@property (strong, nonatomic) NSMutableArray *arrayOfNames;
@property (strong, nonatomic) UITableView *table;
@property (nonatomic, strong) NSString *selectedId;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


- (instancetype)initWithRestID:(NSString *)ID;

@end
