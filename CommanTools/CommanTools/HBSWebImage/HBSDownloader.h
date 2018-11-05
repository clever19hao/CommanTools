//
//  HBSDownloader.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HBSDownloaderProgress)(NSInteger receive,NSInteger expected,NSURL *targetUrl);
typedef void (^HBSDownloaderCompleted)(id obj,NSData *,NSError *,BOOL);

@interface HBSDownloaderID : NSObject

/**
 下载的url，标识一个下载operation
 */
@property (nonatomic,strong) NSURL *url;

/**
 调用者id，同一个下载url对应多个调用者
 */
@property (nonatomic,strong) id subId;

@end

@interface HBSDownloader : NSObject

/**
 超时时间，默认30秒
 */
@property (nonatomic,assign) NSTimeInterval downloadTimeout;

/**
 下载管理单例

 @return 单例
 */
+ (instancetype)shareDownloader;

/**
 取消下载任务

 @param downloadId 下载ID对象
 */
- (void)cancelWithID:(HBSDownloaderID *)downloadId;

/**
 设置下载的自定义类型，类型为空则使用默认类型HBSDownloaderOperation

 @param operation 自定义的下载实体类型
 */
- (void)setOperationClass:(Class)operation;

/**
 下载网络图片

 @param url 图片url
 @param progress 下载进度
 @param completed 下载完成回调
 @return 下载id对象，包含下载的信息
 */
- (HBSDownloaderID *)downloadImageWithURL:(NSURL *)url
                                     size:(CGSize)size
                                 progress:(HBSDownloaderProgress)progress
                                 complete:(HBSDownloaderCompleted)completed;

@end
