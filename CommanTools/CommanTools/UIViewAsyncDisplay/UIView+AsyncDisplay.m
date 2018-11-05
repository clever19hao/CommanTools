//
//  UIView+AsyncDisplay.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights  reserved.
//

#import "UIView+AsyncDisplay.h"
#import <objc/runtime.h>
#import "HBSAsyncObjLoader.h"
#import "AsyncLoad.h"
#import "AsyncLoadId.h"

@interface UIView (_AsyncDisplay)

@property (nonatomic,strong) AsyncLoadId *loadId;

@end

@implementation UIView (AsyncDisplay)

- (id)loadId {
    
    return objc_getAssociatedObject(self, @selector(loadId));
}

- (void)setLoadId:(id)loadId {
    
    objc_setAssociatedObject(self, @selector(loadId), loadId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
- (void)async_setViewWithObj:(id <AsyncLoad>)obj key:(NSString *)key freshBlock:(void (^)(UIView *weakView,id result,NSError *error))freshBlock {
    
    if (key.length == 0 || !obj) {
        
        //如果视图正在加载数据，则取消(取消正在执行的任务然后将回调移除)
        [[HBSAsyncObjLoader shareLoader] cancelLoadId:self.loadId];
        self.loadId = nil;
        return;
    }
    
    if ([self.loadId isEqualKeyWithObj:obj key:key]) {//当前视图正在加载该数据，等待返回
        return;
    }
    
    //如果视图正在加载其它的数据，则取消(取消正在执行的任务然后将回调移除)
    if (self.loadId) {
        [[HBSAsyncObjLoader shareLoader] cancelLoadId:self.loadId];
        self.loadId = nil;
    }
    
    __weak typeof(self) weakself = self;
    
    self.loadId = [[HBSAsyncObjLoader shareLoader] startLoadWithObj:obj key:key complete:^(id result, NSError *error) {
        
        __strong typeof(weakself) strongself = weakself;//防止在block回调中weakself释放导致异常
        if (!strongself) {
            return;
        }
        
        if (strongself.loadId && ![strongself.loadId isEqualKeyWithObj:obj key:key]) {//此时已加载的数据不是视图所需要的，就不刷新视图
            return;
        }
        
        strongself.loadId = nil;
        
        if (freshBlock) {
            freshBlock(strongself,result,error);
        }
    }];
}
@end
