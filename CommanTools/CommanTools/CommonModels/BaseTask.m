//
//  BaseTask.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/12.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "BaseTask.h"

@interface BaseTask ()
{
    int execut_count;
}

@property (atomic,assign) BOOL isCancelled;
@property (atomic,assign) BOOL isFinished;
@property (atomic,assign) BOOL isExecuting;

@end

@implementation BaseTask

- (void)setCancel_block:(void (^)(void))cancel_block {
    
    __weak typeof(self) weakself = self;
    _cancel_block = ^ {
        
        DBG(@"任务取消");
        
        weakself.isCancelled = YES;
        cancel_block();
    };
}

- (void)setFinish_block:(void (^)(id,NSError *))finish_block {
    
    __weak typeof(self) weakself = self;
    _finish_block = ^(id param,NSError *error){
      
        DBG(@"任务结束");
        
        weakself.isFinished = YES;
        finish_block(param,error);
    };
}

- (void)setExecut_block:(void (^)(id,BaseTask *))execut_block {
        
    _execut_block = ^(id param,BaseTask *task){
      
        if (task->_isExecuting) {
            task->execut_count += 1;
            DBG(@"block执行次数:%d",task->execut_count);
        }
        else {
            DBG(@"任务开始");
            task->_isExecuting = YES;
            task->execut_count = 1;
        }
        
        if (task.isCancelled || task.isFinished) {
            return;
        }
        
        execut_block(param,task);
    };
}

- (void)dealloc {
    
    DBG(@"%@ 销毁,ID=%@",NSStringFromClass([self class]),_taskGroupName);
}



@end
