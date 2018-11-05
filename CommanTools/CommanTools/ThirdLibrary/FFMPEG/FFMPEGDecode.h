//
//  FFMPEGDecode.h
//  FFMPEGDecode
//
//  Created by 钟发军 on 17/1/12.
//  Copyright © 2017年 Hubsan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FFMPEGDecodeDelegate <NSObject>//更新图像
-(void)DisplayNewScreen:(UIImage *)NewScreen;
@end
@protocol FFMPEGRGBMSGDelegate <NSObject>//获取RGB数据
-(void)UpdateRGBBuf:(unsigned char*)buf length:(int)length nWidth:(int)width nHeight:(int)height;
@end

@interface FFMPEGDecode : NSObject


@property (nonatomic, weak)   id<FFMPEGDecodeDelegate> delegate;
@property (nonatomic, weak)   id<FFMPEGRGBMSGDelegate> RGBDelegate;
@property (nonatomic, readonly) int VideoWidth;
@property (nonatomic, readonly) int VideoHight;

// 解码器初始化
- (id)init_code;
/*
 将视频裸码流丢入解码器解码(使用ffmpeg自带查查找完整视频帧的方法)
 */
-(void)StartSearchFrameHeardAndDecodeWithH264Data:(NSData *)data;
/*
 将视频裸码流丢入解码器解码(自定义查找实拍帧头的方法)
 */
-(void)DecodeH264Data:(NSData *)data;
@end
