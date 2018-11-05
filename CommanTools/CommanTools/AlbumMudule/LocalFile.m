//
//  LocalFile.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/15.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "LocalFile.h"
#import "DownloadCache.h"
#import <AVFoundation/AVFoundation.h>

@interface LocalFile ()

@property (nonatomic,strong) NSString *filepath;

@end

@implementation LocalFile
@synthesize failCount;

+ (BOOL)isImageFile:(NSString *)filename {
    
    NSString *ext = [[filename pathExtension] lowercaseString];
    
    if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"png"] || [ext isEqualToString:@"bmp"] || [ext isEqualToString:@"jpeg"]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isVideoFile:(NSString *)filename {
    
    NSString *ext = [[filename pathExtension] lowercaseString];
    
    if ([ext isEqualToString:@"mp4"] || [ext isEqualToString:@"mov"] || [ext isEqualToString:@"mpv"] || [ext isEqualToString:@"m4v"]) {
        return YES;
    }
    
    return NO;
}

- (id)initWithFilePath:(NSString *)filepath {
    
    if (self = [super init]) {
        
        _isVideo = [LocalFile isVideoFile:filepath.lastPathComponent];
        _filepath = filepath;
    }
    
    return self;
}

#pragma mark - DownloadCacheProtocol

- (NSString *)dataCacheKeyInCachePool {
    
    if (self.isVideo) {
        return @"Video";
    }
    
    return @"Photo";
}

- (NSString *)dataKeyInDataCache {
    
    return [_filepath lastPathComponent];
}

- (void)loadDataWithComplete:(void (^)(id cacheData))complete {
    
    NSLog(@"load local file : %@",self.name);
    
    __weak LocalFile *tmpself = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (tmpself.isVideo) {
            
            NSURL *videoURL = [NSURL fileURLWithPath:tmpself.path];
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            NSParameterAssert(asset);
            
            NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
            if (duration == 0) {
                tmpself.videoDuration = 0;
            }
            else if (duration < 1 && duration > 0) {
                tmpself.videoDuration = 1;
            }
            else {
                tmpself.videoDuration = round(duration);
            }
            
            AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            assetImageGenerator.appliesPreferredTrackTransform = YES;
            assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
            
            CGImageRef frameImageRef = NULL;
            NSError *frameImageError = nil;
            frameImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(0, asset.duration.timescale) actualTime:NULL error:&frameImageError];
            
            if (frameImageRef) {
                
                UIImage *image = frameImageRef ? [[UIImage alloc] initWithCGImage:frameImageRef] : nil;
                CFRelease(frameImageRef);
                
                if (image) {
                    
                    CGSize size = CGSizeMake(50, 50);
                    
                    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
                    
                    // 绘制改变大小的图片
                    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
                    
                    // 从当前context中创建一个改变大小后的图片
                    tmpself.thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                    
                    // 使当前的context出堆栈
                    UIGraphicsEndImageContext();
                }
            }
        }
        else {
            
            UIImage *image = [UIImage imageWithContentsOfFile:tmpself.path];
            
            CGSize size = CGSizeMake(50, 50);
            
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            
            // 绘制改变大小的图片
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            
            // 从当前context中创建一个改变大小后的图片
            tmpself.thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            
            // 使当前的context出堆栈
            UIGraphicsEndImageContext();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (complete) {//通知缓存池处理
                complete(tmpself.thumbImage);
            }
            
            if (tmpself.imageAdatperChanged) {
                tmpself.imageAdatperChanged(tmpself);
            }
        });
    });
}


#pragma mark - ImageAdapterProtocol
- (UIImage *)thumbImage {
    
    if (!_thumbImage) {
        
        _thumbImage = [[DownloadCache defaultDownloadCache] getCacheDataWithRequestData:self];
        
        if (!_thumbImage && self.failCount < 3) {
            
            if (![[DownloadCache defaultDownloadCache] isExsitReuest:self]) {
                [[DownloadCache defaultDownloadCache] addRequestDatas:@[self]];
            }
        }
    }
    
    return _thumbImage;
}

- (double)duration {
    
    return _videoDuration;
}

- (NSString *)createDate {
    return nil;
}

- (NSString *)location {
    return nil;
}


- (NSString *)name {
    return [_filepath lastPathComponent];
}


- (UIImage *)originImage {
    return [UIImage imageWithContentsOfFile:_filepath];
}


- (NSString *)path {
    return _filepath;
}

- (BOOL)isShowDuration {
    return _isVideo;
}

- (BOOL)isShowVideoFlag {
    return _isVideo;
}

@end
