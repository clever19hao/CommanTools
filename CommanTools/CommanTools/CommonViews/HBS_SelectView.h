//
//  HBS_SelectView.h
//  Vividia
//
//  Created by Arvin on 2017/4/19.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_SelectView : UIControl

@property (nonatomic,copy) void (^selectHandle)(HBS_SelectView *selectView);
@property (nonatomic,assign) NSInteger selectIndex;

- (id)initWithTitle:(NSString *)title btnTitles:(NSArray *)titles;

- (void)show;

@end
