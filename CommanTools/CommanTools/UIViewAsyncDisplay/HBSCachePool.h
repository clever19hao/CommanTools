//
//  HBSCachePool.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 对象缓存池.为每一种类型创建一个NSCache
 */
@interface HBSCachePool : NSObject

+ (instancetype)shareCachePool;

- (void)addObj:(id)obj key:(NSString *)key;

- (void)addObj:(id)obj key:(NSString *)key objClass:(Class)objClass;

- (id)getObjWithKey:(NSString *)key objClass:(Class)objClass;

- (void)removeObjWithKey:(NSString *)key objClass:(Class)objClass;

- (void)drainCache:(Class)objClass;

- (void)drainAllCache;

@end
