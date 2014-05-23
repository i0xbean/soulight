//
//  NSArray+MZAddition.h
//  Soulight
//
//  Created by Ming Z. on 14-5-23.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MZAddition)

- (NSIndexPath*)indexPathNextWithIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathPrevWithIndexPath:(NSIndexPath*)indexPath;

- (BOOL)containsIndexPath:(NSIndexPath*)indexPath;

@end
