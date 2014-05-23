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
    [self loadDataFromCache];
    if (_allDayTextDatas.count == 0) {
        [self createTextData];
        _activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (void)loadDataFromCache
{
    NSArray *tmpArray = (NSArray*)[[EGOCache globalCache] objectForKey:kCacheAllDayTextDatas];
    _allDayTextDatas = [NSMutableArray arrayWithArray:[tmpArray mutableCopy]];
    tmpArray = (NSArray*)[[EGOCache globalCache] objectForKey:kCacheAllDayDates];
    _allDates = [NSMutableArray arrayWithArray:[tmpArray mutableCopy]];
    _activeIndexPath = (NSIndexPath*)[[EGOCache globalCache] objectForKey:kCacheActiveIndexPath];
}

#pragma mark - POJO

- (void)setActiveIndexPath:(NSIndexPath *)activeIndexPath
{
    _activeIndexPath = activeIndexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifActiveTextDataChanged object:nil];
}

#pragma mark - public

- (SLTextData *)createTextData
{
    return [self createTextDataWithDate:[NSDate date]];
}

- (void)save
{
    [self saveWithAsync:YES];
}

#pragma mark - public

- (SLTextData*)activeTextData;
{
    NSArray *tmpArray =
        _allDayTextDatas.count>_activeIndexPath.section ? _allDayTextDatas[_activeIndexPath.section] : nil;
    return tmpArray.count > _activeIndexPath.row ? tmpArray[_activeIndexPath.row] : nil;
}

- (BOOL)setActiveTextData:(SLTextData*)data;
{
    NSIndexPath *indexPath = [self findATextData:data];
    if (indexPath) {
        self.activeIndexPath = indexPath;
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
        
        if (dayTextDatas.count == 0) {
            [_allDayTextDatas removeObject:dayTextDatas];
            [_allDates removeObjectAtIndex:indexPath.section];
        }
        
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

- (SLTextData *)createTextDataWithDate:(NSDate*)date;
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

- (void)saveWithAsync:(BOOL)async
{
    void(^block)()  = ^{
        [[EGOCache globalCache] setObject:_allDayTextDatas forKey:kCacheAllDayTextDatas];
        [[EGOCache globalCache] setObject:_allDates forKey:kCacheAllDayDates];
        [[EGOCache globalCache] setObject:_activeIndexPath forKey:kCacheActiveIndexPath];
    };
    
    if (async) {
        dispatch_async(dispatch_queue_create("im.ioi.soulight.textdatas_save", 0), block);
    } else {
        block();
    }
    
}


#pragma mark - debug

- (void)debugClearData;
{
    [[EGOCache globalCache] clearCache];
}

- (void)debugAppendDataWithDays:(int)days;
{
    for (int i=0; i<days; i++) {
        NSDate *date = [NSDate dateWithDaysBeforeNow:i];
        for (int j=0; j<i%3+1; j++) {
            SLTextData* tData = [self createTextDataWithDate:date];
            tData.text = [NSString stringWithFormat:@"%ld - %d", (long)date.day, j];
        }
    }
    
    [self saveWithAsync:NO];
    [self loadDataFromCache];
}


@end
