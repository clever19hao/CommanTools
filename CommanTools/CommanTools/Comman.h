//
//  Define.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/5.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define HOST    @"http://192.168.0.88"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define DIR_TMP            [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TemporaryFiles"]
#define DIR_DOC            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define IOS_SystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

#define WINDOW_W    [UIScreen mainScreen].bounds.size.width
#define WINDOW_H    [UIScreen mainScreen].bounds.size.height

//屏幕宽度
#define SCREEN_W (WINDOW_W > WINDOW_H ? WINDOW_W : WINDOW_H)
//屏幕高度
#define SCREEN_H (WINDOW_W > WINDOW_H ? WINDOW_H : WINDOW_W)

#define BOUNDS  CGRectMake(0,0,SCREEN_W,SCREEN_H)

//以6plus为基础向其他屏幕比例转换 横屏
#define X_SCALE     (SCREEN_W/736.0)
#define Y_SCALE     (SCREEN_H/414.0)
#define XP_(w)   ((w)*X_SCALE)
#define YP_(h)   ((h)*Y_SCALE)

#define NONNIL(str) (str ?: @"")

#endif /* Define_h */
