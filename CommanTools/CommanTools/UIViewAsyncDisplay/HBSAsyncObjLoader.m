//
//  HBSAsyncObjLoader.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "HBSAsyncObjLoader.h"
#import "HBSCachePool.h"
#import "AsyncLoad.h"
#import "AsyncLoadId.h"
#import "AsyncLoadOperation.h"

NSErrorDomain const AsyncLoadErrorDomain = @"AsyncLoadErrorDomain";

@interface HBSAsyncObjLoader ()

@property (nonatomic,strong) dispatch_semaphore_t lock;
@property (nonatomic,strong) NSMutableDictionary *opeInfo;
@end

@implementation HBSAsyncObjLoader
{
    NSOperationQueue *queue;
}

+ (instancetype)shareLoader {
    
    static id ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
    });
    return ins;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 3;
        
        _opeInfo = [NSMutableDictionary dictionary];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)setConcurrentOperationCount:(NSInteger)count {
    
    queue.maxConcurrentOperationCount = count;
}

- (void)cancelLoadId:(AsyncLoadId *)loadId {
    
    if (!loadId) {
        return;
    }
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    AsyncLoadOperation *ope = [_opeInfo objectForKey:loadId.key];
    if (ope && [ope removeLoadComplete:loadId.subId]) {
        [_opeInfo removeObjectForKey:loadId.key];
    }
    
    dispatch_semaphore_signal(_lock);
}

- (id)startLoadWithObj:(id <AsyncLoad>)obj key:(NSString *)key complete:(loadComplete)complete {
    
    id cacheObj = [[HBSCachePool shareCachePool] getObjWithKey:[NSString stringWithFormat:@"%@_%@",[obj asyncObjKey],key] objClass:[obj class]];
    if (cacheObj) {
        if (complete) {
            complete(cacheObj,nil);
        }
        return nil;
    }
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    NSString *fullKey = [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([obj class]),[obj asyncObjKey],key];
    AsyncLoadOperation *ope = [_opeInfo objectForKey:fullKey];
    if (!ope) {
        ope = [[AsyncLoadOperation alloc] initWithObj:obj key:key];
        
        __weak typeof(self) weakself = self;
        ope.completionBlock = ^{
            
            if (!weakself) {
                return;
            }
            
            __strong typeof(weakself) strongself = weakself;
            
            dispatch_semaphore_wait(strongself.lock, DISPATCH_TIME_FOREVER);
            
            [strongself.opeInfo removeObjectForKey:fullKey];
            
            dispatch_semaphore_signal(strongself.lock);
        };
        
        [_opeInfo setObject:ope forKey:fullKey];
        [queue addOperation:ope];
    }
    dispatch_semaphore_signal(_lock);
    
    AsyncLoadId *loadid = [[AsyncLoadId alloc] init];
    loadid.key = fullKey;
    loadid.subId = [ope addLoadComplete:complete];
    
    return loadid;
}

@end
