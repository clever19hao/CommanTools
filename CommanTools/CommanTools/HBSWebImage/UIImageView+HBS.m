//
//  UIImageView+Custom.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "UIImageView+HBS.h"
#import "HBSDownloader.h"
#import "HBSDownloadCache.h"
#import <objc/runtime.h>

@interface UIImageView (_HBS)

@property (nonatomic,strong) HBSDownloaderID *hbs_downloadId;

@end

@implementation UIImageView (_HBS)

- (HBSDownloaderID *)hbs_downloadId {
    return objc_getAssociatedObject(self, @selector(hbs_downloadId));
}

- (void)setHbs_downloadId:(HBSDownloaderID *)hbs_downloadId {
    
    objc_setAssociatedObject(self, @selector(hbs_downloadId), hbs_downloadId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImageView (HBS)

- (NSString *)cacheKey:(NSURL *)url size:(CGSize)size {
    
    if (url.isFileURL) {
        
    }
    
    return url.absoluteString;
}

- (void)HBS_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    
    [self HBS_setImageWithURL:url size:CGSizeZero placeholderImage:placeholderImage cacheToDisk:NO];
}

- (void)HBS_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage cacheToDisk:(BOOL)cacheToDisk {
    
    [self HBS_setImageWithURL:url size:CGSizeZero placeholderImage:placeholderImage cacheToDisk:cacheToDisk];
}

- (void)HBS_setImageWithURL:(NSURL *)url size:(CGSize)size placeholderImage:(UIImage *)placeholderImage {
    
    [self HBS_setImageWithURL:url size:size placeholderImage:placeholderImage cacheToDisk:NO];
}

- (void)HBS_setImageWithURL:(NSURL *)url size:(CGSize)size placeholderImage:(UIImage *)placeholderImage cacheToDisk:(BOOL)cacheToDisk {
    
    if (url == nil) {
        
        //取消正在下载的任务
        [[HBSDownloader shareDownloader] cancelWithID:self.hbs_downloadId];
        self.hbs_downloadId = nil;
        
        self.image = placeholderImage;
        return;
    }
    
    if ([self.hbs_downloadId.url.absoluteString isEqualToString:url.absoluteString]) {
        return;
    }
    
    //取消正在下载的任务
    [[HBSDownloader shareDownloader] cancelWithID:self.hbs_downloadId];
    self.hbs_downloadId = nil;
    
    //从缓存中查找
    NSString *key = [HBSDownloadCache imageKeyByURL:url size:size];
    UIImage *image = [[HBSDownloadCache shareCache] hbs_getCacheImageWithKey:key];
    if (image) {
        self.image = image;
    }
    else  {
        
        if (placeholderImage) {
            self.image = placeholderImage;
        }
        
        __weak typeof(self) weakself = self;
        
        self.hbs_downloadId = [[HBSDownloader shareDownloader] downloadImageWithURL:url
                                                                               size:size
                                                                           progress:^(NSInteger receive, NSInteger expected, NSURL *targetUrl) {
                                                                               
                                                                           }
                                                                           complete:^(id obj, NSData *data, NSError *error, BOOL finished) {
                                                                               
                                                                               __strong typeof(weakself) strongself = weakself;//防止在block回调中weakself释放导致异常
                                                                               if (!strongself) {
                                                                                   return;
                                                                               }
                                                                               
                                                                               if ([strongself.hbs_downloadId.url.absoluteString isEqualToString:url.absoluteString]) {//考虑到复用情况，请求的顺序和响应的顺序可能不一致，判断是响应对应的请求
                                                                                   
                                                                                   if (obj) {
                                                                                       strongself.image = (UIImage *)obj;
                                                                                       
                                                                                       if (cacheToDisk && ![HBSDownloadCache imageIsInlocalCache:key]) {
                                                                                           [[HBSDownloadCache shareCache] hbs_cacheImage:obj key:key toDisk:cacheToDisk];
                                                                                       }
                                                                                   }
                                                                                   
                                                                                   strongself.hbs_downloadId = nil;
                                                                               }
                                                                               else {
                                                                                   NSLog(@"请求和响应的顺序不一致 %@",strongself);
                                                                               }
                                                                           }];
    }
}
@end
