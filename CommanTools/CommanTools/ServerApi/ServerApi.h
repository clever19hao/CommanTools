//
//  ServerApi.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/5.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConfig.h"

enum {//AppErrorCode
    
    CodeParamIsNil = 0,//请求参数为空
    CodeResponseIsNil = 1,//返回数据为空
    CodeResDataFormatError = 2,//返回格式错误
    CodeIllegalVisit = 404,//非法访问
    CodeUserNotExsit = 416,//用户不存在或被禁止登录
    CodePasswordError = 417,//密码错误
    CodeCommandExpired = 418,//登录口令过期
    CodeUserIllegal = 419,//当前登录用户不合法
    CodeVersionTooLow = 500,//版本太低
    CodeServerException = 1000,//系统异常
};

@interface ServerApi : NSObject

@property (nonatomic,strong,readonly) ServerConfig *config;

+ (ServerApi *)getServerApi;

- (void)initWithConfig:(ServerConfig *)config;

- (void)test;

//标准POST请求
- (void)postRequestWithUrl:(NSString *)url param:(NSDictionary *)param response:(void (^)(NSDictionary *result,NSError *error))response;

/**
 表单请求 多个文件上传

 @param url 上传地址
 @param param 上传参数
 @param fieldArray 文件列表 key为name,filename,filedata,mime
 @param response 上传结果
 */
- (void)postRequestWithUrl:(NSString *)url
                 formParam:(NSDictionary *)param
                 formField:(NSArray <NSDictionary *> *)fieldArray
                  response:(void (^)(NSDictionary *result,NSError *error))response;

@end
