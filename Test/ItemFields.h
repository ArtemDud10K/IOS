//
//  ItemFieldsView.h
//  Test
//
//  Created by TestDeveloper on 12/07/2017.
//  Copyright © 2017 TestDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteManager.h"


@interface ItemFields : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray *itemFields;
@property (strong, nonatomic) NSArray *sourseFields;
@property (strong, nonatomic) NSArray *fieldsFromDB;
@property (nonatomic, strong) NSString *itemID;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


- (instancetype)initWithItemID:(NSString*)ID;

@end
