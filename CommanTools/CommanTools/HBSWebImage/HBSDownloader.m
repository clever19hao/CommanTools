//
//  HBSDownloader.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSDownloader.h"
#import "HBSDownloaderOperation.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
#define UNLOCK(lock) dispatch_semaphore_signal(lock)

@interface HBSDownloaderID ()
@property (strong, nonatomic) NSOperation<HBSDownloaderOperationInterface> *downloadOperation;
@end

@implementation HBSDownloaderID

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end

@interface HBSDownloader () <NSURLSessionDelegate>

@property (strong, nonatomic) dispatch_semaphore_t operationsLock;
@property (assign, nonatomic) Class operationClass;
@property (weak, nonatomic) NSOperation <HBSDownloaderOperationInterface> *lastOperation;
@property (strong, nonatomic) NSMutableDictionary <NSURL *,NSOperation <HBSDownloaderOperationInterface> *> *downloadOperationDic;

@end

@implementation HBSDownloader
{
    NSOperationQueue *downloadQueue;
    NSURLSession *session;
}

@synthesize downloadOperationDic;

+ (instancetype)shareDownloader {
    
    static id ins;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    
    return ins;
}

- (void)dealloc {
    
    [session invalidateAndCancel];
    session = nil;
    
    [downloadQueue cancelAllOperations];
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        downloadQueue = [NSOperationQueue new];
        downloadQueue.maxConcurrentOperationCount = 3;
        downloadQueue.name = @"com.X-Hubsan.HBSDownloader";
        
        session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
        
        downloadOperationDic = [NSMutableDictionary dictionary];
        
        _operationsLock = dispatch_semaphore_create(1);
        
        _operationClass = [HBSDownloaderOperation class];
    }
    
    return self;
}

- (void)setOperationClass:(Class)operation {
    
    if (operation && [operation isSubclassOfClass:[NSOperation class]] && [operation conformsToProtocol:@protocol(HBSDownloaderOperationInterface)]) {
        _operationClass = operation;
    }
    else {
        _operationClass = [HBSDownloaderOperation class];
    }
}

- (void)setSuspended:(BOOL)suspended {
    
    downloadQueue.suspended = suspended;
}

- (void)cancelAllDownloads {
    [downloadQueue cancelAllOperations];
}

- (void)cancelWithID:(HBSDownloaderID *)downloadId {
    
    if (!downloadId.url) {
        return;
    }
    
    LOCK(self.operationsLock);
    
    NSOperation<HBSDownloaderOperationInterface> *ope = [downloadOperationDic objectForKey:downloadId.url];
    if (ope) {
        if ([ope cancelWithSubId:downloadId.subId]) {
            [downloadOperationDic removeObjectForKey:downloadId.url];
        }
    }
    
    UNLOCK(self.operationsLock);
    
}

- (HBSDownloaderID *)downloadImageWithURL:(NSURL *)url
                                     size:(CGSize)size
                                 progress:(HBSDownloaderProgress)progress
                                 complete:(HBSDownloaderCompleted)completed {
    
    if (!url) {
        if (completed) {
            completed(nil,nil,nil,YES);
        }
        return nil;
    }
    
    LOCK(self.operationsLock);
    
    NSOperation <HBSDownloaderOperationInterface> *ope = [downloadOperationDic objectForKey:url];
    if (!ope) {
        ope = [self createOperationWithURL:url];
        
        __weak typeof(self) weakself = self;
        ope.completionBlock = ^{
            
            if (!weakself) {
                return;
            }
            //因为block中是异步执行，有可能在代码块执行过程中self销毁，所以强引用保留
            __strong typeof(weakself) strongself = weakself;
            
            //任务结束处理,从字典中移除。downloadQueue会自动移除
            LOCK(strongself.operationsLock);
            [strongself.downloadOperationDic removeObjectForKey:url];
            UNLOCK(strongself.operationsLock);
        };
        
        [downloadOperationDic setObject:ope forKey:url];
        [downloadQueue addOperation:ope];
        
        //根据UI显示需求，应该是后进先出
        [self.lastOperation addDependency:ope];
        self.lastOperation = ope;
    }
    
    UNLOCK(self.operationsLock);
    
    HBSDownloaderID *downid = [HBSDownloaderID new];
    downid.downloadOperation = ope;
    downid.url = url;
    downid.subId = [ope addSize:size progress:progress completed:completed];
    
    return downid;
}

- (NSOperation <HBSDownloaderOperationInterface> *)createOperationWithURL:(NSURL *)url {
    
    NSTimeInterval timeout = _downloadTimeout;
    if (timeout == 0) {
        timeout = 30;
    }
    
    //不用系统缓存
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];
    
    NSOperation <HBSDownloaderOperationInterface> *ope = [[_operationClass alloc] initWithRequest:request session:session];
    
    return ope;
}

- (NSOperation<HBSDownloaderOperationInterface> *)operationByTask:(NSURLSessionTask *)task {
    
    NSOperation<HBSDownloaderOperationInterface> *returnOperation = nil;
    
    for (NSOperation<HBSDownloaderOperationInterface> *ope in downloadQueue.operations) {
        
        if ([ope respondsToSelector:@selector(dataTask)]) {
            
            if (ope.dataTask.taskIdentifier == task.taskIdentifier) {
                
                returnOperation = ope;
                
                break;
            }
        }
    }
    
    return returnOperation;
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSOperation<HBSDownloaderOperationInterface> *ope = [self operationByTask:dataTask];
    [ope URLSession:session
           dataTask:dataTask
 didReceiveResponse:response
  completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSOperation<HBSDownloaderOperationInterface> *ope = [self operationByTask:dataTask];
    
    [ope URLSession:session dataTask:dataTask didReceiveData:data];
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSOperation<HBSDownloaderOperationInterface> *ope = [self operationByTask:task];
    
    [ope URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSOperation<HBSDownloaderOperationInterface> *ope = [self operationByTask:task];
    
    [ope URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}

@end
