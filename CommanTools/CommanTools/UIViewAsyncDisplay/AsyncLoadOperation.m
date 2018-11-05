//
//  AsyncLoadOperation.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/3.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "AsyncLoadOperation.h"
#import "AsyncLoad.h"
#import "NSError+Custom.h"
#import "HBSCachePool.h"

@interface AsyncLoadOperation ()

@property (nonatomic,strong) NSMutableArray <loadComplete> *blockInfo;

@property (strong, nonatomic) dispatch_semaphore_t lock;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end

@implementation AsyncLoadOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithObj:(id <AsyncLoad>)obj key:(NSString *)key {
    
    if (self = [super init]) {
        
        _asyncObj = obj;
        _loadKey = [key copy];
        
        _blockInfo = [NSMutableArray array];
        
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (id)addLoadComplete:(loadComplete)complete {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_blockInfo addObject:complete];
    dispatch_semaphore_signal(_lock);
    
    return complete;
}

- (BOOL)removeLoadComplete:(id)addId {
    
    BOOL isCancel = NO;
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_blockInfo removeObject:addId];
    if ([_blockInfo count] == 0) {
        isCancel = YES;
    }
    dispatch_semaphore_signal(_lock);
    
    if (isCancel) {
        [self cancel];
    }
    
    return isCancel;
}

#pragma mark - override
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

- (void)cancel {
    
    @synchronized (self) {
        
        if (self.isFinished) {
            return;
        }
        
        [super cancel];
        
        dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
        [_blockInfo removeAllObjects];
        dispatch_semaphore_signal(_lock);
        
        self.executing = NO;
        self.finished = YES;
    }
}

- (void)start {
    
    @synchronized (self) {
        
        if (self.isCancelled) {
            
            self.finished = YES;
            
            dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
            [_blockInfo removeAllObjects];
            dispatch_semaphore_signal(_lock);
            
            return;
        }
        
        if (self.isExecuting) {
            return;
        }
    }
    
    self.executing = YES;
    
    if (_asyncObj && _loadKey) {
        
        [_asyncObj asyncLoadDataWithKey:_loadKey complete:^(id result, NSError *error) {
            [self finishedWithResult:result error:error];
        }];
    }
    else {
        [self finishedWithResult:nil error:[NSError errorWithDomain:AsyncLoadErrorDomain code:AppErrorCodeObjIsNil userInfo:@{NSLocalizedDescriptionKey:@"Load Object is nil!"}]];
    }
}

- (void)finishedWithResult:(id)result error:(NSError *)error {
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSMutableArray *blockArray = [NSMutableArray arrayWithArray:_blockInfo];
    [_blockInfo removeAllObjects];
    dispatch_semaphore_signal(_lock);
    
    self.executing = NO;
    self.finished = YES;
    
    if (result) {
        
        NSString *dataKey = [NSString stringWithFormat:@"%@_%@",[_asyncObj asyncObjKey],_loadKey];
        [[HBSCachePool shareCachePool] addObj:result key:dataKey objClass:[_asyncObj class]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        for (loadComplete complete in blockArray) {
            
            complete(result,error);
        }
    });
}
@end
