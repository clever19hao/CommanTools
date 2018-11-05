//
//  NSError+Custom.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/5.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>

//错误域主要有四个，对于Carbon框架的Error，归于OSStatus domain（NSOSStatusErrorDomain），对于POSIX error，归于NSPOSIXErrorDomain，而对于我们的iOS开发，一般使用NSCocoaErrorDomain。NSError.h定义了四个domain
//自定义的模块错误domain
extern NSErrorDomain const HBSServerNetErrorDomain;
extern NSErrorDomain const HBSCameraTaskErrorDomain;

typedef int AppErrorCode;

@interface NSError (Custom)

+ (NSError *)serverError:(AppErrorCode)code errorMsg:(NSString *)errorMsg;

+ (NSError *)cameraError:(AppErrorCode)code errorMsg:(NSString *)errorMsg;

+ (NSError *)errorWithDomain:(NSErrorDomain)domain code:(AppErrorCode)code msg:(NSString *)errorMsg;

- (NSString *)errorMsg;

@end
