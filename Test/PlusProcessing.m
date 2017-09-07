//
//  PlusProcessing.m
//  Test
//
//  Created by Dev on 8/15/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import "PlusProcessing.h"

@implementation PlusProcessing

#pragma Singleton
static PlusProcessing * plus = nil;
NSMutableArray *buffer;


+(PlusProcessing *)singleton
{
    @synchronized([PlusProcessing class])
    {
        if (!plus)
        {
           plus = [[self alloc] init];
        }
        return plus;
    }
    return nil;
}


+(id)alloc
{
    @synchronized([PlusProcessing class])
    {
        plus = [super alloc];
        return plus;
    }
    return nil;
}


-(id)init
{
    self = [super init];
    buffer = [[NSMutableArray alloc] init];

    return self;
}





-(void)pressPlusprocess:(id)ID
{
    if (buffer.count > 0)
    {
        if([self isIdInArray:ID])
        {
            [buffer removeObject:ID];
        }
        
        else
        {
            [buffer addObject:ID];
        }
    }
    
    else
    {
        [buffer addObject:ID];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:buffer forKey:@"Favorites"];
    [userDefaults synchronize];
    
}


-(void)removeObject:(NSUInteger)ID
{
    if(buffer.count > 0)
    {
        [buffer removeObjectAtIndex:ID];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:buffer forKey:@"Favorites"];
    [userDefaults synchronize];
}




-(BOOL)isIdInArray:(id)ID
{
    for(NSUInteger i = 0; i < buffer.count; i++)
    {
        if([[buffer objectAtIndex:i] isEqualToString:ID])
        {
            return YES;
        }
        
    }
    return NO;
}





@end
