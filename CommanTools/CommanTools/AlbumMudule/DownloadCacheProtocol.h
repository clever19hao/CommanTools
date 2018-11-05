//
//  DownloadProtocol.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 实现这个协议，就能在加载数据时实现数据缓存
 */
@protocol DownloadCacheProtocol <NSObject>

@property (nonatomic,assign) int failCount;//缓存失败的次数

/**
 获取容器key，用于在缓存池中查询容器
 @return 容器key
 */
- (NSString *)dataCacheKeyInCachePool;

/**
 获取当前数据key，用于在容器中查询数据

 @return 数据key
 */
- (NSString *)dataKeyInDataCache;

/**
 异步加载数据
 
 @param downloadComplete 加载结束,主线程返回要缓存的数据
 */
- (void)loadDataWithComplete:(void (^)(id cacheData))downloadComplete;

@end
