//
//  ShutterView.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/13.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShutterView : UIView

+ (void)shutter;

+ (void)shutterWithNumber:(int)number hasSound:(BOOL)hasSound;

+ (void)waitWithNumber:(int)number;

@end
