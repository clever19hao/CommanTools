//
//  AnimateView.h
//  HY012_iOS
//
//  Created by Arvin on 2018/6/11.
//  Copyright © 2018年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AnimateNone,
    AnimateFromBottom,
    AnimateFromTop
}AnimateStyle;

@interface AnimateView : UIView

@property (nonatomic,assign) AnimateStyle animate;
@property (nonatomic,strong) NSString *tagStr;

- (void)show;

- (void)dismiss;

@end
