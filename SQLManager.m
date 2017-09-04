//
//  SQLManager.m
//  FastFood
//
//  Created by MsJesus on 11.03.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLManager.h"




static int sqlCallBack(void *context, int count, char **values, char **columns)
{
	NSMutableArray *res = (NSMutableArray*)context;
	for (int i=0; i<count; i++)
	{
		const char *cstr = values[i];
		if (cstr) {
			[res addObject:[NSString stringWithUTF8String:cstr]];
		}
	}
	return SQLITE_OK;
}


@implementation SQLManager


@synthesize primeValue;



-(id)initWithFileName:(NSString *)_fileName
{
	self = [super init];
	if (self) {
		db = NULL;
		if (sqlite3_open([_fileName UTF8String], &db) != SQLITE_OK)	{
			db = NULL;
		}
	}
	
	return self;
}


-(NSMutableArray*)runSQL:(NSString *)sql
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	if (db) {
		sqlite3_exec(db, [sql UTF8String], sqlCallBack, result, NULL);
	}
		
	return [result autorelease];
}


-(NSMutableArray*)getFields:(NSString *)_fieldName inTable:(NSString *)_tableName forPrimeKey:(NSString *)_primeKey
{
	return [self runSQL:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", @"select ", _fieldName, @" from ", _tableName, @" where ", _primeKey, @" = '", primeValue, @"'"]];
}


-(NSString*)getFirstField:(NSString *)_fieldName inTable:(NSString *)_tableName forPrimeKey:(NSString *)_primeKey
{
	return [[self getFields:_fieldName inTable:_tableName forPrimeKey:_primeKey] objectAtIndex:0];
}


-(void)dealloc
{
	sqlite3_close(db);
	[super dealloc];
}


@end
