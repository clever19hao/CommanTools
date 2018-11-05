//
//  HBSDownloaderOperation.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSDownloaderOperation.h"
#import "HBSDownloadCache.h"
#import "NSError+Custom.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

static NSString *ProgressKey = @"progress";
static NSString *CompleteKey = @"complete";
static NSString *SizeKey = @"size";

NSErrorDomain const HBSDownloaderErrorDomain = @"HBSDownloaderErrorDomain";

NSNotificationName const DownloaderOperationStatusChangedNotice = @"DownloaderOperationStatusChangedNotice";
NoticeUserInfoKey const NoticeUserInfoError = @"error";
NoticeUserInfoKey const NoticeUserInfoStatus = @"status";


@interface HBSDownloaderOperation ()
{
    dispatch_source_t source;
}

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@property (strong, nonatomic) dispatch_semaphore_t lock;

@property (nonatomic,strong) NSMutableArray <NSDictionary *> *blocksInfo;
@property (nonatomic,weak) NSURLSession *unownedSession;
@property (nonatomic,strong) NSURLSession *ownedSession;
@property (nonatomic,strong) NSURLRequest *request;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@property (strong, nonatomic) NSMutableData *imageData;
@property (assign, nonatomic) NSInteger expectedSize;

@end

@implementation HBSDownloaderOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)dealloc {
    
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session {
    
    if (self = [super init]) {
        
        
        _blocksInfo = [NSMutableArray new];
        _unownedSession = session;
        _request = [request copy];
        
        _lock = dispatch_semaphore_create(1);
    }
    
    return self;
}

- (id)addSize:(CGSize)size progress:(HBSDownloaderProgress)progress completed:(HBSDownloaderCompleted)completed {
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    if (progress) {
        info[ProgressKey] = [progress copy];
    }
    
    if (completed) {
        info[CompleteKey] = [completed copy];
    }
    
    info[SizeKey] = [NSValue value:&size withObjCType:@encode(CGSize)];
    
    LOCK(self.lock);
    [_blocksInfo addObject:info];
    UNLOCK(self.lock);
    
    return info;
}

- (BOOL)cancelWithSubId:(id)subId {
    
    BOOL shouldCancel = NO;
    LOCK(self.lock);
    [_blocksInfo removeObject:subId];
    if ([_blocksInfo count] == 0) {
        shouldCancel = YES;
    }
    UNLOCK(self.lock);
    
    if (shouldCancel) {
        [self cancel];
    }
    
    return shouldCancel;
}

#pragma mark - NSOperation override
- (void)setFinished:(BOOL)finished {
    
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}

- (void)setExecuting:(BOOL)executing {
    
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (void)done {
    
    self.finished = YES;
    self.executing = NO;
    
    [self reset];
}

//重置数据
- (void)reset {
    
    LOCK(self.lock);
    [_blocksInfo removeAllObjects];
    UNLOCK(self.lock);
    
    _dataTask = nil;
    
    if (self.ownedSession) {
        [self.ownedSession invalidateAndCancel];
        self.ownedSession = nil;
    }
    
    if (source) {
        dispatch_source_cancel(source);
        source = nil;
    }
}

- (void)cancel {
    
    @synchronized (self) {
        
        if (self.isFinished) {
            return;
        }
        
        [super cancel];
        
        if (self.dataTask) {
            
            [self.dataTask cancel];
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakSelf userInfo:@{NoticeUserInfoStatus:@(StatusCancel)}];
            });
            
            if (self.executing) {
                self.executing = NO;
            }
            
            if (!self.finished) {
                self.finished = YES;
            }
        }
        
        [self reset];
    }
}

- (void)start {
    
    NSLog(@"%@%@",self,NSStringFromSelector(_cmd));
    
    @synchronized (self) {
        NSString *key = [HBSDownloadCache imageKeyByURL:_request.URL size:CGSizeZero];
        UIImage *img = [[HBSDownloadCache shareCache] hbs_getCacheImageWithKey:key];
        if (img) {//能从缓存中找到原始数据
            
            self.executing = YES;
            
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            
            [self callCompletionBlocksWithData:data error:nil finished:YES];
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakSelf userInfo:@{NoticeUserInfoStatus:@(StatusCompleted)}];
            });
            
            [self done];
            
            return;
        }
        
        if ([self isCancelled]) {
            
            self.finished = YES;
            
            [self reset];
            
            return;
        }
        
        __weak typeof(self) weakself = self;
        self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            //防止block执行中途self释放
            __strong typeof(weakself) strongself = weakself;
            if (strongself) {
                [strongself cancel];
                [[UIApplication sharedApplication] endBackgroundTask:strongself.backgroundTaskId];
                strongself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
            else {
                //对象释放了，则后台任务已完成
            }
        }];
        
        NSURLSession *session = self.unownedSession;
        if (!session) {
            session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
            _ownedSession = session;
        }
        
        _dataTask = [session dataTaskWithRequest:_request];
        self.executing = YES;
    }
    
    if (_dataTask) {
        
        [_dataTask resume];
        
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakself userInfo:@{NoticeUserInfoStatus:@(StatusStarted)}];
        });
    }
    else {
        //任务已结束
        [self callCompletionBlocksWithData:nil error:[NSError errorWithDomain:HBSDownloaderErrorDomain code:AppErrorCodeTaskInitFailed msg:@"Task can't be initialized"] finished:YES];
        
        [self done];
        
        return;
    }
    
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

#pragma mark - private methods

- (UIImage *)image:(UIImage *)image resize:(CGSize)size {
    
    if (size.width == 0 || size.height == 0 || !image) {
        return image;
    }
    
    CGFloat ratio = MIN(size.width/image.size.width, size.height/image.size.height);
    size = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    
    int W = size.width;
    int H = size.height;
    
    CGImageRef   imageRef   = image.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (image.imageOrientation == UIImageOrientationDown || image.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

- (void)callCompletionBlocksWithData:(nullable NSData *)imageData
                               error:(nullable NSError *)error
                            finished:(BOOL)finished {
    
    NSLog(@"下载完成%@,len=%lld,error=%@",_request.URL.path,(long long)imageData.length,error);
    
    LOCK(self.lock);
    NSArray *callbackInfoArray = [NSArray arrayWithArray:_blocksInfo];
    UNLOCK(self.lock);
    
    if (imageData && !error) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            NSString *originkey = [HBSDownloadCache imageKeyByURL:_request.URL size:CGSizeZero];
            [[HBSDownloadCache shareCache] hbs_cacheImage:image key:originkey toDisk:NO];
        }
        
        NSMutableArray *tmp = [NSMutableArray array];
        NSMutableDictionary *imgInfo = [NSMutableDictionary dictionary];
        
        for (NSDictionary *info in callbackInfoArray) {
            
            CGSize size;
            [info[SizeKey] getValue:&size];
            
            NSString *key = [NSString stringWithFormat:@"%d_%d",(int)size.width,(int)size.height];
            
            UIImage *img = [imgInfo objectForKey:key];
            if (!img) {
                img = [self image:image resize:size];
                
                if (img) {
                    [imgInfo setObject:img forKey:key];
                    NSString *thumbkey = [HBSDownloadCache imageKeyByURL:_request.URL size:size];
                    [[HBSDownloadCache shareCache] hbs_cacheImage:img key:thumbkey toDisk:NO];
                }
            }
            
            [tmp addObject:key];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i < [callbackInfoArray count]; i++) {
                
                HBSDownloaderCompleted completed = callbackInfoArray[i][CompleteKey];
                
                if (completed) {
                    
                    completed(imgInfo[tmp[i]],imageData,error,finished);
                }
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i < [callbackInfoArray count]; i++) {
                
                HBSDownloaderCompleted completed = callbackInfoArray[i][CompleteKey];
                
                if (completed) {
                    
                    completed(nil,imageData,error,finished);
                }
            }
        });
    }
}

- (NSArray <id> *)callbacksForKey:(NSString *)key {
    
    LOCK(self.lock);
    NSMutableArray *array = [[_blocksInfo valueForKey:key] mutableCopy];
    UNLOCK(self.lock);
    //数组元素中valueForKey如果为nil会用NSNull.null替换
    [array removeObject:NSNull.null];
    
    return [array copy];
}

#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    NSInteger expected = (NSInteger)response.expectedContentLength;
    expected = expected > 0 ? expected : 0;
    self.expectedSize = expected;
    
    NSInteger statusCode = [response respondsToSelector:@selector(statusCode)] ? ((NSHTTPURLResponse *)response).statusCode : 200;
    BOOL valid = statusCode < 400;
    
    NSLog(@"URLSession start response code = %d",(int)statusCode);
    //'304 Not Modified' is an exceptional one. It should be treated as cancelled if no cache data
    //URLSession current behavior will return 200 status code when the server respond 304 and URLCache hit. But this is not a standard behavior and we just add a check
    if (statusCode == 304) {
        valid = NO;
    }
    
    if (valid) {
        
        source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_event_handler(source, ^{
            
            NSInteger receive = self.imageData.length;
            for (HBSDownloaderProgress progressBlock in [self callbacksForKey:ProgressKey]) {
                progressBlock(receive, self.expectedSize, self.request.URL);
            }
            //NSLog(@"progressBlock(%ld, %ld, %@)",receive,self.expectedSize,self.request.URL);
        });
        dispatch_resume(source);
        
        dispatch_source_merge_data(source, 0);
        
    } else {
        // Status code invalid and marked as cancelled. Do not call `[self.dataTask cancel]` which may mass up URLSession life cycle
        disposition = NSURLSessionResponseCancel;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakSelf userInfo:@{NoticeUserInfoStatus:@(StatusReceive)}];
    });
    
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if (!self.imageData) {
        self.imageData = [[NSMutableData alloc] initWithCapacity:self.expectedSize];
    }
    [self.imageData appendData:data];
    
    if (source) {
        dispatch_source_merge_data(source, data.length);
    }
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    @synchronized(self) {
        
        _dataTask = nil;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakSelf userInfo:@{NoticeUserInfoStatus:@(StatusError),NoticeUserInfoError:error}];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:DownloaderOperationStatusChangedNotice object:weakSelf userInfo:@{NoticeUserInfoStatus:@(StatusCompleted)}];
            }
        });
    }
    
    // make sure to call `[self done]` to mark operation as finished
    if (error) {
        [self callCompletionBlocksWithData:nil error:error finished:YES];
        [self done];
    }
    else {
        NSData *imageData = [self.imageData copy];
        if (imageData) {
            [self callCompletionBlocksWithData:imageData error:nil finished:YES];
        }
        else {
            [self callCompletionBlocksWithData:nil error:[NSError errorWithDomain:HBSDownloaderErrorDomain code:AppErrorCodeTaskResponseDataNil msg:@"Response data is nil"] finished:YES];
        }
        
        [self done];
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (YES) {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        } else {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

@end
