//
//  PlusProcessing.h
//  Test
//
//  Created by Dev on 8/15/17.
//  Copyright © 2017 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlusProcessing : NSObject


+(PlusProcessing *)singleton;
-(void)pressPlusprocess:(id)ID;
-(void)removeObject:(NSUInteger)ID;
-(BOOL)isIdInArray:(id)ID;

@end
