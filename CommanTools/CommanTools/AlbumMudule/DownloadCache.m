//
//  DownloadCache.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "DownloadCache.h"

#define LIMIT_NUMBER    1

@implementation DownloadCache
{
    NSCache *cachePool;
    NSMutableArray *willLoadArray;
    NSMutableArray *curLoading;
}

+ (DownloadCache *)defaultDownloadCache {
    
    static DownloadCache *ins = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!ins) {
            ins = [[DownloadCache alloc] init];
        }
    });
    
    return ins;
}

- (id)init {
    
    if (self = [super init]) {
        
        willLoadArray = [NSMutableArray arrayWithCapacity:1];
        curLoading = [NSMutableArray arrayWithCapacity:1];
        cachePool = [[NSCache alloc] init];
    }
    
    return self;
}

/**

 */
- (void)addRequestDatas:(NSArray <id <DownloadCacheProtocol>> *)requestDatas {
    
    for (id <DownloadCacheProtocol> obj in requestDatas) {
        
        NSString *cacheKey = [obj dataCacheKeyInCachePool];
        NSString *dataKey = [obj dataKeyInDataCache];
        
        NSLog(@"add request : %@",dataKey);
        
        if (!cacheKey || !dataKey) {
            continue;
        }
        
        NSCache *dataCache = [cachePool objectForKey:cacheKey];
        if (!dataCache) {
            dataCache = [[NSCache alloc] init];
            [cachePool setObject:dataCache forKey:cacheKey];
        }
        
        if ([dataCache objectForKey:dataKey]) {
            continue;
        }
        
        [willLoadArray addObject:obj];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performNext];
    });
}

- (BOOL)isExsitReuest:(id <DownloadCacheProtocol>)request {
    
    if ([curLoading containsObject:request]) {
        return YES;
    }
    
    if ([willLoadArray containsObject:request]) {
        return YES;
    }
    
    return NO;
}

- (void)performNext {
    
    if ([willLoadArray count] == 0) {
        return;
    }
    
    while ([curLoading count] < LIMIT_NUMBER) {
        
        id <DownloadCacheProtocol> curLoadData = [willLoadArray lastObject];
        
        if (!curLoadData) {
            break;
        }
        
        if ([curLoading containsObject:curLoadData]) {
            [willLoadArray removeObject:curLoadData];
            continue;
        }
        [curLoading addObject:curLoadData];
        
        NSString *cacheKey = [curLoadData dataCacheKeyInCachePool];
        NSString *dataKey = [curLoadData dataKeyInDataCache];
        
        [curLoadData loadDataWithComplete:^(id cacheData) {
            
            if (dataKey && cacheKey && cacheData) {
                
                NSCache *dataCache = [self->cachePool objectForKey:cacheKey];
                if (!dataCache) {
                    dataCache = [[NSCache alloc] init];
                    [self->cachePool setObject:dataCache forKey:cacheKey];
                }
                
                [dataCache setObject:cacheData forKey:dataKey];
            }
            
            if (!cacheData) {
                curLoadData.failCount += 1;
            }
            
            NSLog(@"complete request : %@",dataKey);
            
            [self->willLoadArray removeObject:curLoadData];
            [self->curLoading removeObject:curLoadData];
            [self performNext];
        }];
    }
}

- (id)getCacheDataWithRequestData:(id <DownloadCacheProtocol>)requestData {
    
    NSString *cacheKey = [requestData dataCacheKeyInCachePool];
    NSString *dataKey = [requestData dataKeyInDataCache];
    
    if (!cacheKey || !dataKey) {
        return nil;
    }
    
    NSCache *dataCache = [cachePool objectForKey:cacheKey];
    
    return [dataCache objectForKey:dataKey];
}

- (void)removeCacheData:(id <DownloadCacheProtocol>)requestData {
    
    NSString *cacheKey = [requestData dataCacheKeyInCachePool];
    NSString *dataKey = [requestData dataKeyInDataCache];
    
    if (!cacheKey || !dataKey) {
        return;
    }
    
    NSCache *dataCache = [cachePool objectForKey:cacheKey];
    
    [dataCache removeObjectForKey:dataKey];
}

- (void)drainCache:(id <DownloadCacheProtocol>)requestData {
    
    NSString *cacheKey = [requestData dataCacheKeyInCachePool];
    
    if (cacheKey) {
        [cachePool removeObjectForKey:cacheKey];
    }
}

- (void)drainAll {
    [willLoadArray removeAllObjects];
    [cachePool removeAllObjects];
}

#pragma mark - 直接缓存指定数据
- (void)cacheData:(id)cacheData dataKey:(NSString *)dataKey cacheKey:(NSString *)cacheKey {
    
    if (dataKey && cacheKey && cacheData) {
        
        NSCache *dataCache = [cachePool objectForKey:cacheKey];
        if (!dataCache) {
            dataCache = [[NSCache alloc] init];
            [cachePool setObject:dataCache forKey:cacheKey];
        }
        
        [dataCache setObject:cacheData forKey:dataKey];
    }
}

- (id)getCacheDataWithDataKey:(NSString *)dataKey cacheKey:(NSString *)cacheKey {
    
    if (!cacheKey || !dataKey) {
        return nil;
    }
    
    NSCache *dataCache = [cachePool objectForKey:cacheKey];
    
    return [dataCache objectForKey:dataKey];
}
@end
