//
//  ViewControllerTwo.h
//  Test
//
//  Created by Dev on 8/1/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewControllerTwo : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *bufIDs;


@end
