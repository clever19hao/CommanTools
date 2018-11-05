//
//  LocalFile.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/15.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "ImageAdapter.h"
#import "DownloadCacheProtocol.h"

@interface LocalFile : ImageAdapter <DownloadCacheProtocol>

@property (nonatomic,strong) UIImage *thumbImage;
@property (nonatomic,strong) NSDate *fileCreateDate;

@property (nonatomic,assign,readonly) BOOL isVideo;
@property (atomic,assign) NSTimeInterval videoDuration;

- (id)initWithFilePath:(NSString *)filepath;

+ (BOOL)isImageFile:(NSString *)filename;
+ (BOOL)isVideoFile:(NSString *)filename;

@end
