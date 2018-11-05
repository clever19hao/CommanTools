//
//  UILabel+AsyncDisplay.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/4.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AsyncLoad;

@interface UILabel (AsyncDisplay)

- (void)async_setViewWithObj:(id <AsyncLoad>)obj key:(NSString *)key placeholder:(NSString *)placeholder;

- (void)async_setViewWithObj:(id <AsyncLoad>)obj key:(NSString *)key placeholder:(NSString *)placeholder freshBlock:(void (^)(UIView *weakView,id result,NSError *error))freshBlock;

@end
