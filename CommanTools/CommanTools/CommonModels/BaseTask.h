//
//  CameraTask.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/12.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseTask;

typedef void (^TaskHandle)(BaseTask *task,NSError *error);

@interface BaseTask : NSObject

//取消任务代码
@property (nonatomic,copy) void (^cancel_block)(void);

//结束任务代码
@property (nonatomic,copy) void (^finish_block)(id,NSError *);

//执行任务代码
@property (nonatomic,copy) void (^execut_block)(id,BaseTask *);

@property (nonatomic,strong) NSString *taskGroupName;
@property (nonatomic,strong) NSString *taskIdentity;

@property (nonatomic,strong,readonly) NSError *finishError;

@property (atomic,assign,readonly) BOOL isCancelled;
@property (atomic,assign,readonly) BOOL isFinished;
@property (atomic,assign,readonly) BOOL isExecuting;

@end
