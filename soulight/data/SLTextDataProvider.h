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

@property (readonly)            NSArray *               allTextDatas;

- (SLTextData*)createTextData;

- (void)formatTextDatas:(void(^)(NSArray *formatDates, NSArray* formatTextDatas, NSIndexPath* activeIndexPath))textDatasBlock;

- (void)save;

- (SLTextData*)activeTextData;
- (BOOL)setActiveTextData:(SLTextData*)data;

@end
