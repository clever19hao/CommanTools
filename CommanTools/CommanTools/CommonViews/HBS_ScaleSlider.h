//
//  HBS_ScaleSlider.h
//  Vividia
//
//  Created by Arvin on 2017/6/28.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_ScaleSlider : UIView

@property (nonatomic,copy) void (^selectValue)(NSNumber *value);
@property (nonatomic,assign) BOOL isShowChangeValue;
@property (nonatomic,assign) BOOL isOnlyUseValueInArray;

- (id)initWithScaleWithValues:(NSArray <NSNumber *> *)values unitDes:(NSString *)uint frame:(CGRect)frame;
- (void)setCurSelectValue:(NSNumber *)value;

@end
