//
//  GeocoderManager.h
//  HBSDrone
//
//  Created by Arvin on 2018/11/4.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 反地理编码需要注意:
 1、如果用户是在高速上快速移动，可能返回整个区域的名称，而不是用户通过小公园的名称
 2、应用应该明白怎样使用地理编码，因为地理编码对于每一个app都是有频率限制的，如果在较短的时间内进行太多的请求，可能会导致请求失败(当使用超过了最大的限制，地理编码将会返回应该错误对象kCLErrorNetwork)
 3、对于任意的用户行为，最多只发送一次请求。
 4、如果用户执行的多次请求涉及到相同的位置，应该重用最初的地理编码请求结果，而不是开始一个新的请求
 5、当想要自动更新用户的当前位置时(如：用户正在移动),要注意：仅仅是当用户已经移动一段距离并且有一段合理的时间才发起一个新的编码请求。例如：不应该在每分钟发送超过一个的编码请求。
 6、不要每次在用户不能够立马看到结果的时候，又开始一个编码请求。当应用处于后台绘制inactive状态不要进行请求操作。
 */

@class CLLocation;
@class CLPlacemark;

extern NSErrorDomain const GeocoderErrorDomain;

enum {
    AppErrorCodeReusePlacemark = -1
};

@interface GeocoderManager : NSObject

+ (void)reverseGeocodeLocation:(CLLocation *)location complete:(void (^)(CLPlacemark *place,NSError *error))complete;

+ (void)clear;

@end
