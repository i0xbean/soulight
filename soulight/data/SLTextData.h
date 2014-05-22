//
//  SLTextData.h
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTextData : NSObject

@property (strong, nonatomic)   NSDate *            createdDate;
@property (strong, nonatomic)   NSDate *            modifiedDate;

@property (strong, nonatomic)   NSString *          text;

@property (assign, nonatomic)   float               reuseHistoryCellHeight;

@end
