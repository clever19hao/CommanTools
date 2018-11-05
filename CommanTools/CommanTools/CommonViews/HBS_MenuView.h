//
//  HBS_MenuView.h
//  Vividia
//
//  Created by Arvin on 2017/4/24.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_MenuView : UIControl

@property (nonatomic,copy) void (^selectHandle)(HBS_MenuView *menu);
@property (nonatomic,assign) NSInteger selectIndex;

- (id)initWithTitle:(NSString *)title btnTitles:(NSArray *)titles;

- (void)showInView:(UIView *)parentView;

@end
