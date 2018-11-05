//
//  HBSDownloaderOperation.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HBSDownloader.h"

extern NSErrorDomain const HBSDownloaderErrorDomain;

enum {
    AppErrorCodeTaskInitFailed = -1,
    AppErrorCodeTaskResponseDataNil = -2
};

extern NSNotificationName const DownloaderOperationStatusChangedNotice;

typedef NSString *NoticeUserInfoKey;
extern NoticeUserInfoKey const NoticeUserInfoError;
extern NoticeUserInfoKey const NoticeUserInfoStatus;

enum {
    StatusStarted = 1,
    StatusReceive = 2,
    StatusCancel = 3,
    StatusError = 4,
    StatusCompleted = 5
};

/**
 定义下载所需实现的接口，如果有特殊的业务需求，可定制NSOperation子类实现该接口,并由HBSDownloader调用setOperationClass进行配置,便可对子类管理
 */
@protocol HBSDownloaderOperationInterface <NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session;

- (id)addSize:(CGSize)size progress:(HBSDownloaderProgress)progress completed:(HBSDownloaderCompleted)completed;

- (BOOL)cancelWithSubId:(id)subId;

@optional
- (NSURLSessionTask *)dataTask;

@end

/**
 下载类，封装了一次完整下载的流程。HBSDownloader管理多个operation。增加后台处理时间
 一个url对应一个operation，但是界面上可能多个地方触发下载同一个url，所以一个个operation对应多个界面回调。
 */
@interface HBSDownloaderOperation : NSOperation <HBSDownloaderOperationInterface>

@property (nonatomic,strong,readonly) NSURLSessionDataTask *dataTask;

@end
