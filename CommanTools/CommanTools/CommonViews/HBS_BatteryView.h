//
//  HBS_BatteryView.h
//  Vividia
//
//  Created by Arvin on 2017/7/18.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BatteryStyle) {
    
    BatteryStyleHor,
    BatteryStyleVor
};

@interface HBS_BatteryView : UIView

- (id)initWithFrame:(CGRect)frame style:(BatteryStyle)style;
- (void)setBatteryColor:(UIColor *)color;
- (void)setBatteryPercent:(float)percent;
@end
