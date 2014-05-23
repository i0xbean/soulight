//
//  SLTextDataProvider.m
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLTextDataProvider.h"




@interface SLTextDataProvider ()

@end

@implementation SLTextDataProvider

MZSINGLETON_IN_M

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    NSArray *tmpArray = (NSArray*)[[EGOCache globalCache] objectForKey:kCacheAllDayTextDatas];
    _allDayTextDatas = [NSMutableArray arrayWithArray:[tmpArray mutableCopy]];
    tmpArray = (NSArray*)[[EGOCache globalCache] objectForKey:kCacheAllDayDates];
    _allDates = [NSMutableArray arrayWithArray:[tmpArray mutableCopy]];
    _activeIndexPath = (NSIndexPath*)[[EGOCache globalCache] objectForKey:kCacheActiveIndexPath];
    if (_allDayTextDatas.count == 0) {
        [self createTextData];
    }
}

#pragma mark - public

- (SLTextData *)createTextData
{
    SLTextData *data = [[SLTextData alloc] init];
    data.createdDate = data.modifiedDate = [NSDate date];
    
    NSMutableArray *dayTextDatas = nil;
    
    NSDate *newest = _allDates.firstObject;
    if (newest && [newest isEqualToDateIgnoringTime:data.createdDate]) {
        dayTextDatas = _allDayTextDatas.firstObject;

    } else {
        [_allDates insertObject:data.createdDate atIndex:0];
        dayTextDatas = [NSMutableArray array];
        [_allDayTextDatas insertObject:dayTextDatas atIndex:0];
    }
    
    [dayTextDatas insertObject:data atIndex:0];
    self.activeTextData = data;
    
    [self save];
    
    return data;
}

- (void)save
{
    dispatch_async(dispatch_queue_create("im.ioi.soulight.textdatas_save", 0), ^{
        [[EGOCache globalCache] setObject:_allDayTextDatas forKey:kCacheAllDayTextDatas];
        [[EGOCache globalCache] setObject:_allDates forKey:kCacheAllDayDates];
        [[EGOCache globalCache] setObject:_activeIndexPath forKey:kCacheActiveIndexPath];
    });
}

#pragma mark - public

- (SLTextData*)activeTextData;
{
    return _allDayTextDatas[_activeIndexPath.section][_activeIndexPath.row];
}

- (BOOL)setActiveTextData:(SLTextData*)data;
{
    NSIndexPath *indexPath = [self findATextData:data];
    if (indexPath) {
        _activeIndexPath = indexPath;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifActiveTextDataChanged object:nil];
        [self save];
        return YES;
    }
    return NO;
}

- (BOOL)removeTextData:(SLTextData*)data;
{
    NSIndexPath *indexPath = [self findATextData:data];
    if (indexPath) {
        NSMutableArray *dayTextDatas = _allDayTextDatas[indexPath.section];
        [dayTextDatas removeObjectAtIndex:indexPath.row];
        
        [self save];
        return YES;
    }
    return NO;
}

#pragma mark - private

- (NSIndexPath*)findATextData:(SLTextData*)data
{
    __block BOOL has = NO;
    __block NSUInteger s;
    __block NSUInteger r;
    [_allDayTextDatas enumerateObjectsUsingBlock:^(NSArray *dayTextDatas, NSUInteger section, BOOL *allStop) {
        [dayTextDatas enumerateObjectsUsingBlock:^(SLTextData *obj, NSUInteger row, BOOL *stop) {
            if ([obj isEqual:data]) {
                has = YES;
                s = section;
                r = row;
            }
        }];
    }];
    
    if (has) {
        return [NSIndexPath indexPathForRow:r inSection:s];
    } else {
        return nil;
    }
}

@end
