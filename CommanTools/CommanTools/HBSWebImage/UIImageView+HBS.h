//
//  UIImageView+HBS.h
//  HBSDrone
//
//  Created by Arvin on 2018/9/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HBS)

/**
 加载并显示图片，并将图片保存到内存中，低内存或切换到后台时大概率会被系统释放。
 加载顺序：内存-->本地缓存文件-->网络

 @param url 原图url
 @param placeholderImage 备用图片，获取url为空时使用
 */
- (void)HBS_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 加载并显示图片，并将图片保存到内存中，低内存或切换到后台时大概率会被系统释放。
 加载顺序：内存-->本地缓存文件-->网络

 @param url 原图url
 @param placeholderImage 备用图片，获取url为空时使用
 @param cacheToDisk 为YES时会保存到磁盘文件
 */
- (void)HBS_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage cacheToDisk:(BOOL)cacheToDisk;

/**
 加载并显示指定大小的图片，并将原图和resize后的图片保存到内存中，低内存或切换到后台时大概率会被系统释放.
 加载顺序：内存-->本地缓存文件-->原图内存-->原图本地缓存文件-->网络原图-->resize.

 @param url 原图url
 @param size 指定图片显示的大小
 @param placeholderImage 备用图片，获取url为空时使用
 */
- (void)HBS_setImageWithURL:(NSURL *)url size:(CGSize)size placeholderImage:(UIImage *)placeholderImage;

/**
 加载并显示指定大小的图片，并将原图和resize后的图片保存到内存中，低内存或切换到后台时大概率会被系统释放.
 加载顺序：内存-->本地缓存文件-->原图内存-->原图本地缓存文件-->网络-->resize.
 
 @param url 原图url
 @param size 指定图片显示的大小
 @param placeholderImage 备用图片，获取url为空时使用
 @param cacheToDisk 为YES时会保存到文件
 */
- (void)HBS_setImageWithURL:(NSURL *)url size:(CGSize)size placeholderImage:(UIImage *)placeholderImage cacheToDisk:(BOOL)cacheToDisk;
@end
