//
//  HBS_View.h
//
//
//  Created by Arvin on 17/4/11.
//  Copyright © 2017年 hubsan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ContentAligment) {
    
    ContentCenter,
    ContentLeftRight,
    ContentUpDown,
    ContentRightLeft,
    ContentDownUp,
    ContentCustom
};

@class HBS_View;

typedef void (^HBS_ViewHandle)(HBS_View *view);

/**
 *  自定义点击控件，由背景图片，图片，描述文字构成，可以自己调整图片和文字的位置，可以响应点击事件.
 */
@interface HBS_View : UIImageView

@property (nonatomic,strong,readonly) UIImageView *foreImageView;//由外面设置foreImageView的属性
@property (nonatomic,strong,readonly) UILabel *describeLabel;//由外面设置describeLabel的属性

//@property (nonatomic,assign) UIEdgeInsets contentInset;//内容缩进 default{0,0,0,0}

@property (nonatomic,assign) BOOL adjustImageByState;// default YES

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL enabled;

@property (nonatomic,assign) ContentAligment contentAligment;
@property (nonatomic,assign) CGSize foreImageSize;
@property (nonatomic,assign) CGFloat space;//default 3.0

@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled; // default is YES

@property (nonatomic,strong) UIView *selectionView;

- (void)setBackgroundImage:(NSString *)imageName forState:(UIControlState)state;
- (void)setForeImage:(NSString *)imageName forState:(UIControlState)state;

- (void)setTouchHandle:(HBS_ViewHandle)selectHandle;

@end
