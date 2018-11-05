//
//  HBSCachePool.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSCachePool.h"

@implementation HBSCachePool
{
    NSMutableDictionary *poolDic;
    NSLock *poolLock;
}

+ (instancetype)shareCachePool {
    
    static id ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

- (instancetype)init {
    
    if (self = [super init]) {
        poolDic = [NSMutableDictionary dictionary];
        
        poolLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)addObj:(id)obj key:(NSString *)key {
    [self addObj:obj key:key objClass:[obj class]];
}

- (void)addObj:(id)obj key:(NSString *)key objClass:(Class)objClass {
    
    if (!obj) {
        return;
    }
    
    NSString *cacheKey = NSStringFromClass(objClass);
    
    [poolLock lock];
    NSCache *cache = [poolDic objectForKey:cacheKey];
    if (!cache) {
        cache = [[NSCache alloc] init];
        [poolDic setObject:cache forKey:cacheKey];
    }
    [poolLock unlock];
    
    [cache setObject:obj forKey:key];
}

- (id)getObjWithKey:(NSString *)key objClass:(Class)objClass {
    
    if (key.length < 1) {
        return nil;
    }
    
    NSString *cacheKey = NSStringFromClass(objClass);
    
    [poolLock lock];
    NSCache *cache = [poolDic objectForKey:cacheKey];
    [poolLock unlock];
    
    return [cache objectForKey:key];
}

- (void)removeObjWithKey:(NSString *)key objClass:(Class)objClass {
    
    if (key.length < 1) {
        return;
    }
    
    NSString *cacheKey = NSStringFromClass(objClass);
    
    [poolLock lock];
    NSCache *cache = [poolDic objectForKey:cacheKey];
    [poolLock unlock];
    
    [cache removeObjectForKey:key];
}

- (void)drainCache:(Class)objClass {
    
    NSString *cacheKey = NSStringFromClass(objClass);
    
    [poolLock lock];
    [poolDic removeObjectForKey:cacheKey];
    [poolLock unlock];
}

- (void)drainAllCache {
    
    [poolLock lock];
    [poolDic removeAllObjects];
    [poolLock unlock];
}

@end
