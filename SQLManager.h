//
//  SQLManager.h
//  FastFood
//
//  Created by MsJesus on 11.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SQLManager : NSObject {
	sqlite3* db;
	NSString* primeValue;
}

@property (nonatomic, copy) NSString* primeValue;


-(id)initWithFileName:(NSString*)_fileName;

-(NSMutableArray*)runSQL:(NSString*)sql;
-(NSString*)getFirstField:(NSString*)_fieldName inTable:(NSString*)_tableName forPrimeKey:(NSString*)_primeKey;
-(NSMutableArray*)getFields:(NSString*)_fieldName inTable:(NSString*)_tableName forPrimeKey:(NSString*)_primeKey;

@end