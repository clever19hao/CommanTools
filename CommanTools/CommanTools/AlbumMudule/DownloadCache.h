//
//  DownloadCache.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadCacheProtocol.h"

/**
 自定义的缓存池，管理对象异步加载顺序并缓存指定数据
 */
@interface DownloadCache : NSObject

+ (DownloadCache *)defaultDownloadCache;

/**
 添加要缓存的数据到队列，会根据队列的执行情况自动等待或执行。

 @param requestDatas 构造的请求对象
 */
- (void)addRequestDatas:(NSArray <id <DownloadCacheProtocol>> *)requestDatas;

- (BOOL)isExsitReuest:(id <DownloadCacheProtocol>)request;

/**
 获取缓存池中的数据。要先构造一个请求对象，才可以获取到指定数据

 @param requestData 构造的请求对象
 @return 缓存的数据
 */
- (id)getCacheDataWithRequestData:(id <DownloadCacheProtocol>)requestData;

/**
 删除缓存的数据。要先构造一个请求对象，才可以删除指定数据

  @param requestData 构造的请求对象
 */
- (void)removeCacheData:(id <DownloadCacheProtocol>)requestData;

/**
 删除缓存的数据的容器。要先构造一个请求对象，才可以删除指定数据所在的容器

 @param requestData 构造的请求对象
 */
- (void)drainCache:(id <DownloadCacheProtocol>)requestData;

/**
 释放所有容器
 */
- (void)drainAll;

#pragma mark - 直接缓存指定数据
- (void)cacheData:(id)data dataKey:(NSString *)dataKey cacheKey:(NSString *)cacheKey;
- (id)getCacheDataWithDataKey:(NSString *)dataKey cacheKey:(NSString *)cacheKey;
@end
