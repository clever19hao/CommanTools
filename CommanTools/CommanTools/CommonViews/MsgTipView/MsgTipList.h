//
//  MsgTipList.h
//  HBSDrone
//
//  Created by Arvin on 2018/7/11.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MSG_DURATION    3

typedef void (^DismissHandle)(NSString *msg);

typedef enum {
    TipMsgTypeDesc,//描述性提示，用户可看可不看
    TipMsgTypeForbid,//禁用类提示,用户需要仔细看，颜色要显眼一点
    TipMsgTypeWarning//警告类提示，用户需要特别注意，颜色要更加显眼
}TipMsgType;

@interface MsgTipList : NSObject

- (id)initWithMaxFrame:(CGRect)rect inView:(UIView *)inView;

/**
添加一条提示消息，默认类型为TipMsgTypeDesc，默认时间为3秒钟

 @param msg 提示的文字
 */
- (void)addMsg:(NSString *)msg;

/**
 添加一条提示消息,默认时间为3秒钟

 @param msg 提示的文字
 @param type 消息类型
 */
- (void)addMsg:(NSString *)msg type:(TipMsgType)type;

/**
 添加一条提示消息，默认类型为TipMsgTypeDesc

 @param msg 提示的文字
 @param duration 消息显示时长，为0时则不会自动消失
 */
- (void)addMsg:(NSString *)msg duration:(double)duration;

/**
 添加一条提示消息

 @param msg 提示的文字
 @param duration 消息显示时长，为0时则不会自动消失
 @param type 消息类型
 */
- (void)addMsg:(NSString *)msg duration:(double)duration type:(TipMsgType)type;

/**
 添加一条提示消息

 @param msg 提示的文字
 @param duration 消息显示时长，为0时则不会自动消失
 @param type 消息类型
 @param handle 消息显示到期后回调
 */
- (void)addMsg:(NSString *)msg duration:(double)duration type:(TipMsgType)type dismissHandle:(DismissHandle)handle;

/**
 移除消息提示，不会触发消息显示到期后回调

 @param msg 提示的文字
 */
- (void)hideMsg:(NSString *)msg;

/**
 消息提示是否存在

 @param msg 提示的文字
 @return YES存在 NO不存在
 */
- (BOOL)isExsitMsg:(NSString *)msg;

/**
 移除所有消息提示，不会触发消息显示到期后回调
 */
- (void)hideAllMsg;

- (void)test;

@end
