//
//  PopViewTool.h
//  HBSDrone
//
//  Created by Arvin on 2018/3/21.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    animate_none,
    animate_downUp,
    animate_rightLeft,
    animate_center
}AnimateStyle;

@interface PopViewTool : NSObject

@property (nonatomic,strong,readonly) UIView *content;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,assign) BOOL pressBackgroundDismiss;//default YES;
@property (nonatomic,copy) void (^dismissBlock)();

- (void)showWithContent:(UIView *)content style:(AnimateStyle)style;

- (void)resumeShow;

- (void)dismiss;
- (void)dismissNoAnimate;

@end
