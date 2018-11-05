//
//  MyOperation.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/12.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 封装了一组任务的执行顺序
 */
@interface MyOperation : NSOperation

/**
 当myConcurrent为YES时有效，设置最大并发任务数量,默认3
 */
@property (nonatomic,assign) long maxCount;

/**
 添加串行任务,前面的任务(组)执行完成后再执行该任务,一次添加一个

 @param block 任务代码
 */
- (void)addSerialBlock:(void (^)(void))block;

/**
 添加并行任务,前面的任务(组)执行完成后再执行该任务组，任务组并发执行

 @param blocks 并发任务组
 */
- (void)addConcurrentBlock:(NSArray <dispatch_block_t> *)blocks;

@end
