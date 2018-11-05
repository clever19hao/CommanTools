//
//  ImageAdapter.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageAdapterProtocol.h"

/**
 输入源有很多时，可使用适配器模式统一输出。属于视图层，不应该与数据层直接交互,应该与ViewController交互
 */
@interface ImageAdapter : NSObject <ImageAdapterProtocol>

@property (nonatomic,copy) void (^imageAdatperChanged)(id data);

/**
 输入对象,只用于将数据中转成可显示数据
 */
@property (nonatomic,strong) id data;

@property (nonatomic,strong) NSString *groupKey;

/**
 与输入对象建立联系
 @param data 输入对象
 @return 实例对象
 */
- (instancetype)initWithData:(id)data;

@end
