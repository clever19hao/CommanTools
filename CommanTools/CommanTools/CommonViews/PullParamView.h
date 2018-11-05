//
//  PullParamView.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/7.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PullFromLeft,
    PullFromRight
}PullDirection;

@interface PullParamView : UIView

@property (nonatomic,assign) PullDirection direction;
@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) CGRect pullFrame;

//加载子视图用
- (UIView *)pullContentView;

- (void)show;

- (void)dismiss:(void (^)(void))complete;

@end
