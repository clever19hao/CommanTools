//
//  MyOperation.m
//  HBSDrone
//
//  Created by Arvin on 2018/9/12.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "MyOperation.h"

@interface MyOperation ()

@property (readonly, copy) NSMutableArray *executionBlocks;
@property (nonatomic,assign,getter=isExecuting) BOOL executing;
@property (nonatomic,assign,getter=isFinished) BOOL finished;

@end

@implementation MyOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)init {
    if (self = [super init]) {
        _executionBlocks = [NSMutableArray arrayWithCapacity:1];
        _maxCount = 3;
    }
    return self;
}

/**
 添加串行任务,前面的任务(组)执行完成后再执行该任务,一次添加一个
 
 @param block 任务代码
 */
- (void)addSerialBlock:(void (^)(void))block {
    
    if (block) {
        [_executionBlocks addObject:block];
    }
}

/**
 添加并行任务,前面的任务(组)执行完成后再执行该任务组，任务组并发执行
 
 @param blocks 并发任务组
 */
- (void)addConcurrentBlock:(NSArray <dispatch_block_t> *)blocks {
    
    if (blocks) {
        [_executionBlocks addObject:blocks];
    }
}

- (void)setExecuting:(BOOL)executing {
    
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (void)setFinished:(BOOL)finished {
    
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}

- (void)start {
    
    NSLog(@"MyOperation start");
    
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    
    [self main];
    
    self.executing = YES;
}

- (void)main {
    
    NSLog(@"MyOperation main begin");
    @try {
        @autoreleasepool {
            
            while (!self.isCancelled) {
                
                id obj = [_executionBlocks firstObject];
                
                if (obj == nil) {
                    NSLog(@"所有任务执行完成");
                    break;
                }
                else {
                    
                    if ([obj isKindOfClass:[NSArray class]]) {//并发执行
                        
                        NSArray * blocks = obj;
                        
                        NSString *name = [NSString stringWithFormat:@"com.x_hubsan.myoperation-%d",rand()];
                        dispatch_queue_t queue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_CONCURRENT);
                        
                        dispatch_semaphore_t seg = dispatch_semaphore_create(_maxCount);
                        
                        for (dispatch_block_t block in blocks) {
                            
                            dispatch_semaphore_wait(seg, DISPATCH_TIME_FOREVER);
                            
                            dispatch_async(queue, ^{
                                if (block) {
                                    block();
                                }
                                dispatch_semaphore_signal(seg);
                            });
                        }
                        
                        dispatch_barrier_sync(queue, ^{
                            NSLog(@"完成一组并行任务:%d",(int)[blocks count]);
                            [_executionBlocks removeObject:blocks];
                        });
                    }
                    else {
                        dispatch_block_t block = obj;
                        if (block) {
                            NSLog(@"执行一个串行任务");
                            block();
                        }
                        [_executionBlocks removeObject:block];
                    }
                }
            }
            self.executing = NO;
            self.finished = YES;
        }
    }
    @catch (NSException *e) {
        NSLog(@"MyOperation Exception %@",e);
        self.executing = NO;
        self.finished = YES;
    }
    
    NSLog(@"MyOperation main end");
}


@end
