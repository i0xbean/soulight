//
//  SLTextDataProvider.m
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLTextDataProvider.h"




@interface SLTextDataProvider ()

@property (strong, nonatomic)   NSMutableArray *            textDatas;

@property (assign, nonatomic)   int                         activeIndex;

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
    NSArray *cacheData = (NSArray*)[[EGOCache globalCache] objectForKey:kCacheTextDatas];
    _activeIndex = [[[EGOCache globalCache] stringForKey:kCacheActiveTextDataIndex] intValue];
    _textDatas = [NSMutableArray arrayWithArray:cacheData];
    
    if (_textDatas.count == 0) {
        [self createTextData];
        _activeIndex = 0;
        [self save];
    }
}

#pragma mark - public

- (SLTextData *)createTextData
{
    SLTextData *data = [[SLTextData alloc] init];
    data.createdDate = data.modifiedDate = [NSDate date];
    
    [_textDatas insertObject:data atIndex:0];
    
    return data;
}

- (NSArray *)allTextDatas
{
    return _textDatas;
}

- (void)save
{
    dispatch_async(dispatch_queue_create("im.ioi.soulight.textdatas_save", 0), ^{
        [[EGOCache globalCache] setObject:_textDatas forKey:kCacheTextDatas];
        [[EGOCache globalCache] setString:@(_activeIndex).description forKey:kCacheActiveTextDataIndex];
    });
}

- (void)formatTextDatas:(void(^)(NSArray *formatDates, NSArray* formatTextDatas, NSIndexPath* activeIndexPath))textDatasBlock;
{
    __block NSIndexPath *activeIndexPath        = nil;
    NSMutableArray *formatDates                 = [NSMutableArray array];
    NSMutableArray *formatTextDatas             = [NSMutableArray array];
    __block NSMutableArray *someDayTextDatas    = [NSMutableArray array];
    __block NSDate *someDayDate                 = ((SLTextData*)_textDatas.firstObject).createdDate;
    [formatDates addObject:someDayDate];
    [formatTextDatas addObject:someDayTextDatas];
    
    
    [_textDatas enumerateObjectsUsingBlock:^(SLTextData* d, NSUInteger idx, BOOL *stop) {
        if (idx == _activeIndex) {
            activeIndexPath = [NSIndexPath indexPathForItem:someDayTextDatas.count inSection:formatDates.count-1];
        }
        
        if ([someDayDate isEqualToDateIgnoringTime:d.createdDate]) {
            [someDayTextDatas addObject:d];
        } else {
            someDayDate = d.createdDate;
            [formatDates addObject:someDayDate];
            
            someDayTextDatas = [NSMutableArray array];
            [formatTextDatas addObject:someDayTextDatas];
        }
    }];
    
    textDatasBlock(formatDates, formatTextDatas, activeIndexPath);
}

#pragma mark - public

- (SLTextData*)activeTextData;
{
    return _textDatas[_activeIndex];
}

- (BOOL)setActiveTextData:(SLTextData*)data;
{
    NSUInteger idx = [_textDatas indexOfObject:data];
    if (idx == NSNotFound) {
        return NO;
    } else {
        _activeIndex = (int)idx;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifActiveTextDataChanged object:nil];
        [self save];
        return YES;
    }
}

@end
