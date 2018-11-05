//
//  HBSDownloadCache.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/25.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSDownloadCache.h"

@implementation HBSDownloadCache
{
    NSCache *dataCache;
}
@synthesize diskRoot;

+ (instancetype)shareCache {
    
    static id ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        dataCache = [[NSCache alloc] init];
        
        [self hbs_setCacheDisRoot:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject];
    }
    return self;
}

+ (NSString *)imageKeyByURL:(NSURL *)url size:(CGSize)size {
    
    NSString *relative = [url path];
    NSString *root = [[self shareCache] diskRoot];
    
    if (url.isFileURL && [relative hasPrefix:root]) {
        relative = [relative substringFromIndex:root.length];
    }
    
    NSString *main = [relative stringByDeletingPathExtension];
    NSString *ext = [relative pathExtension];
    
    
    return [NSString stringWithFormat:@"%@_(%d,%d).%@",main,(int)size
            .width,(int)size.height,ext];
}

+ (BOOL)imageIsInlocalCache:(NSString *)key {
    
    NSString *path = key;
    NSString *root = [[self shareCache] diskRoot];
    
    if (![path hasPrefix:root]) {
        path = [NSString stringWithFormat:@"%@%@",root,key];
    }
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL];
}

- (void)hbs_setCacheDisRoot:(NSString *)root {
    
    if ([root hasSuffix:@"/"]) {
        diskRoot = [NSString stringWithFormat:@"%@HBSDownloadCache/",root];
    }
    else {
        diskRoot = [NSString stringWithFormat:@"%@/HBSDownloadCache/",root];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:diskRoot withIntermediateDirectories:YES attributes:nil error:nil];
}

- (UIImage *)hbs_getCacheImageWithKey:(NSString *)key {
    
    if (key.length < 1) {
        return nil;
    }
    
    UIImage *img = [dataCache objectForKey:key];
    if (!img) {
        NSString *path = key;
        if (![path hasPrefix:diskRoot]) {
            path = [NSString stringWithFormat:@"%@%@",diskRoot,key];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            img = [UIImage imageWithContentsOfFile:path];
            
            if (img) {
                
                [self hbs_cacheImage:img key:key toDisk:NO];
            }
        }
    }
    
    return img;
}

- (void)hbs_cacheImage:(UIImage *)image key:(NSString *)key toDisk:(BOOL)toDisk {
    
    if (!image || key.length < 1) {
        return;
    }
    
    if (toDisk) {
        
        //存到本地
        NSString *path = key;
        if (![path hasPrefix:diskRoot]) {
            path = [NSString stringWithFormat:@"%@%@",diskRoot,key];
        }
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        [data writeToFile:path atomically:YES];
    }
    else {
        [dataCache setObject:image forKey:key];
    }
}

- (void)hbs_removeCacheImageWithKey:(NSString *)key {
    
    [dataCache removeObjectForKey:key];
    
    NSString *path = key;
    if ([path hasPrefix:diskRoot]) {
        path = [NSString stringWithFormat:@"%@%@",diskRoot,key];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (UIImage *)hbs_getCacheImageWithUrl:(NSURL *)url size:(CGSize)size {
    
    if (!url) {
        return nil;
    }
    
    NSString *relative = [url path];
    NSString *main = [relative stringByDeletingPathExtension];
    NSString *ext = [relative pathExtension];
    NSString *key = [NSString stringWithFormat:@"%@_(%d,%d).%@",main,(int)size
                          .width,(int)size.height,ext];
    
    UIImage *img = [dataCache objectForKey:key];
    
    if (!img) {//内存中没有，从本地获取
        
        NSString *path = key;
        if (!url.isFileURL) {
            path = [NSString stringWithFormat:@"%@%@",diskRoot,key];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            img = [UIImage imageWithContentsOfFile:path];
            
            if (img) {
                
                if ([key hasPrefix:diskRoot]) {
                    key = [key substringFromIndex:diskRoot.length];
                }
                
                [self hbs_cacheImage:img url:url size:size toDisk:NO];
            }
        }
    }
    
    return img;
}

- (void)hbs_cacheImage:(UIImage *)image url:(NSURL *)url size:(CGSize)size toDisk:(BOOL)toDisk {
    
    if (!image || !url) {
        return;
    }
    
    NSString *relative = [url path];
    NSString *main = [relative stringByDeletingPathExtension];
    NSString *ext = [relative pathExtension];
    NSString *key = [NSString stringWithFormat:@"%@_(%d,%d).%@",main,(int)size
                     .width,(int)size.height,ext];
    
    if (toDisk) {
        
        //存到本地
        NSString *path = key;
        if (!url.isFileURL) {
            path = [NSString stringWithFormat:@"%@%@",diskRoot,key];
        }
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSData *data = UIImageJPEGRepresentation(image,1.0);
        [data writeToFile:path atomically:YES];
    }
    else {
        [dataCache setObject:image forKey:key];
    }
}
@end
