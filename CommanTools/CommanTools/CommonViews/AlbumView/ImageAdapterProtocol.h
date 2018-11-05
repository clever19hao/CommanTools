//
//  ImageAdapterProtocol.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 界面显示所需的数据适配协议,根据界面需要改动
 */
@protocol ImageAdapterProtocol <NSObject>

/**
 返回 缩略图

 @return 缩略图
 */
- (UIImage *)thumbImage;

/**
 是否显示视频标志和时间

 @return YES：显示 NO：不显示
 */
- (BOOL)isShowVideoFlag;

/**
 是否显示播放时长
 @return YES：显示 NO：不显示
 */
- (BOOL)isShowDuration;
- (double)duration;

/**
 获取文档名字

 @return 图片或视频名字
 */
- (NSString *)name;

/**
 获取文档原图

 @return 返回图片或者视频的第一帧
 */
- (UIImage *)originImage;

/**
 获取文档的地理位置

 @return 地理位置
 */
- (NSString *)location;

/**
 获取文档路径

 @return 文档路径
 */
- (NSString *)path;

/**
 获取文档创建日期

 @return 创建日期
 */
- (NSString *)createDate;

@end

