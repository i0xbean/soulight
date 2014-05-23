//
//  SLTextDataProvider.h
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLTextData.h"

@interface SLTextDataProvider : NSObject

MZSINGLETON_IN_H

@property (strong, nonatomic)   NSMutableArray *        allDayTextDatas;
@property (strong, nonatomic)   NSMutableArray *        allDates;
@property (strong, nonatomic)   NSIndexPath *           activeIndexPath;

- (SLTextData*)createTextData;

- (void)save;

- (SLTextData*)activeTextData;
- (BOOL)setActiveTextData:(SLTextData*)data;


- (BOOL)removeTextData:(SLTextData*)data;

@end
