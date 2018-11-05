//
//  NSError+Custom.m
//  HY012_iOS
//
//  Created by Arvin on 2018/6/5.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import "NSError+Custom.h"

NSErrorDomain const HBSServerNetErrorDomain = @"HBSServerNetErrorDomain";
NSErrorDomain const HBSCameraTaskErrorDomain = @"HBSCameraTaskErrorDomain";

@implementation NSError (Custom)

+ (NSError *)serverError:(AppErrorCode)code errorMsg:(NSString *)errorMsg {
    
    if (errorMsg.length <= 0) {
        errorMsg = @"无错误信息";
    }
    NSError *error = [NSError errorWithDomain:HBSServerNetErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    return error;
}

+ (NSError *)cameraError:(AppErrorCode)code errorMsg:(NSString *)errorMsg {
    
    if (errorMsg.length <= 0) {
        errorMsg = @"无错误信息";
    }
    
    NSError *error = [NSError errorWithDomain:HBSCameraTaskErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
    
    return error;
}

+ (NSError *)errorWithDomain:(NSErrorDomain)domain code:(AppErrorCode)code msg:(NSString *)errorMsg {
    
    NSString *str = errorMsg ?: @"";
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey:str}];
    return error;
}

- (NSString *)errorMsg {
    
    NSString *msg = self.userInfo[NSLocalizedDescriptionKey];
    
    if (msg.length <= 0) {
        msg = self.userInfo[NSLocalizedFailureReasonErrorKey];
    }
    
    if (msg.length <= 0) {
        msg = self.domain;
    }
    
    return msg;
}

@end
