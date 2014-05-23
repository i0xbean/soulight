//
//  NSArray+MZAddition.m
//  Soulight
//
//  Created by Ming Z. on 14-5-23.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "NSArray+MZAddition.h"

@implementation NSArray (MZAddition)

- (NSIndexPath*)indexPathNextWithIndexPath:(NSIndexPath*)indexPath;
{
    NSArray *tmpArr = self.count > indexPath.section ? self[indexPath.section] : nil;
    if (indexPath.row < tmpArr.count-1) {
        return [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    }
    int inc = [self hasElementSubArrayWithIndexPath:indexPath sectionInc:1];
    if (inc == 0) {
        return nil;
    } else {
        return [NSIndexPath indexPathForRow:0 inSection:indexPath.section+inc];
    }
}

- (NSIndexPath*)indexPathPrevWithIndexPath:(NSIndexPath*)indexPath;
{
    if (indexPath.row > 0) {
        return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    int inc = [self hasElementSubArrayWithIndexPath:indexPath sectionInc:-1];
    if (inc == 0) {
        return nil;
    } else {
        NSArray *tmpArr = self[indexPath.section+inc];
        return [NSIndexPath indexPathForRow:tmpArr.count-1 inSection:indexPath.section+inc];
    }
}

- (int)hasElementSubArrayWithIndexPath:(NSIndexPath*)indexPath sectionInc:(int)inc
{
    NSArray *tmpArr = self.count > indexPath.section+inc ? self[indexPath.section+inc] : nil;
    
    if (!tmpArr) {
        return 0;
    } else if (tmpArr.count > 0) {
        return inc;
    } else {
        return [self hasElementSubArrayWithIndexPath:indexPath sectionInc:(inc + (inc>0 ? 1 : -1))];
    }
}

- (BOOL)containsIndexPath:(NSIndexPath*)indexPath;
{
    NSArray *tmpArr = self.count > indexPath.section ? self[indexPath.section] : nil;
    if (tmpArr.count > indexPath.row) {
        return YES;
    }
    return NO;
}

@end
