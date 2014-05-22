//
//  MZSingleton.h
//
//  Created by i0xbean on 13-12-10.
//

#ifndef _MZSingleton_h_
#define _MZSingleton_h_

#define MZSINGLETON_IN_H \
+ (instancetype)sharedInstance;\
+ (void)releaseSingleton; \


#define MZSINGLETON_IN_M \
\
__strong static NSMutableDictionary *__bc_singleton_shared_dic__ = nil; \
\
+ (instancetype)sharedInstance; \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__bc_singleton_shared_dic__ = [NSMutableDictionary dictionary]; \
}); \
\
id sharedSelf = nil; \
@synchronized(__bc_singleton_shared_dic__) { \
sharedSelf = [__bc_singleton_shared_dic__ objectForKey:self.class.description]; \
if (!sharedSelf) { \
sharedSelf = [[super allocWithZone:NULL] init]; \
[__bc_singleton_shared_dic__ setObject:sharedSelf forKey:self.class.description]; \
} \
} \
return sharedSelf; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self sharedInstance]; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
+ (void)releaseSingleton; \
{ \
[__bc_singleton_shared_dic__ removeObjectForKey:self.class.description]; \
} \


#endif
