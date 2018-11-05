//
//  HBSDownloadCache.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/25.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HBSDownloadCache : NSObject

@property (nonatomic,copy,readonly) NSString *diskRoot;//default is Library/Caches/

+ (instancetype)shareCache;

/**
 生成图片缓存的key，唯一映射一张图片

 @param url 图片url
 @param size 指定的图片size
 @return 图片key
 */
+ (NSString *)imageKeyByURL:(NSURL *)url size:(CGSize)size;

/**
 本地文件缓存是否存在

 @param key 图片缓存的key
 @return YES存在 NO本地文件不存在
 */
+ (BOOL)imageIsInlocalCache:(NSString *)key;

/**
 设置文件缓存目录

 @param root 文件缓存目录
 */
- (void)hbs_setCacheDisRoot:(NSString *)root;

/**
 从内存或者文件缓存中获取图片

 @param key 图片缓存的key
 @return 图片
 */
- (UIImage *)hbs_getCacheImageWithKey:(NSString *)key;

/**
 保存图片到内存或者文件

 @param image 图片
 @param key 图片缓存的key
 @param toDisk YES缓存到文件 NO缓存到内存
 */
- (void)hbs_cacheImage:(UIImage *)image key:(NSString *)key toDisk:(BOOL)toDisk;

/**
 从内存和文件中删除图片

 @param key 图片缓存的key
 */
- (void)hbs_removeCacheImageWithKey:(NSString *)key;

@end
