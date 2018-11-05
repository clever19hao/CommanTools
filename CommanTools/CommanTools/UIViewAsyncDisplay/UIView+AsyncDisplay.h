//
//  UIView+AsyncDisplay.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/1.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AsyncLoad;

/**
 MVVM模式.实现UIView的异步数据刷新
 */
@interface UIView (AsyncDisplay)

- (void)async_setViewWithObj:(id <AsyncLoad>)obj key:(NSString *)key freshBlock:(void (^)(UIView *weakView,id result,NSError *error))freshBlock;

@end
