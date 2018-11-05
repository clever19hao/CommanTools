//
//  HBS_MenuView.m
//  Vividia
//
//  Created by Arvin on 2017/4/24.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_MenuView.h"
#import "RadioButton.h"
#import "HBS_ShapeAngle.h"

@implementation HBS_MenuView
{
    HBS_ShapeAngle *content;
    RadioButton *firstBtn;
}

- (id)initWithTitle:(NSString *)title btnTitles:(NSArray *)titles {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        
        [self addTarget:self action:@selector(pressBg) forControlEvents:UIControlEventTouchUpInside];
        
        content = [[HBS_ShapeAngle alloc] init];
        
        //content.layer.cornerRadius = 15;
        content.backgroundColor = [UIColor clearColor];
        [self addSubview:content];
        
        self.backgroundColor = [UIColor clearColor];
        
        NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
        
        CGFloat btn_w = 0;
        CGFloat btn_h = 40;
        
        for (NSString* optionTitle in titles) {
            
            CGSize size = [optionTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}];
            
            if (btn_w < size.width + 30) {
                btn_w = size.width + 30;
            }
            
            RadioButton* btn = [[RadioButton alloc] initWithFrame:CGRectMake(0, 0, btn_w, btn_h)];
            [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
            [btn setTitle:optionTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
            [content addSubview:btn];
            [buttons addObject:btn];
        }
        
        [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
        
        [buttons[0] setSelected:YES]; // Making the first button initially selected
        
        firstBtn = buttons[0];
    }
    
    return self;
}

- (void)setSelectIndex:(NSInteger)selectValue {
    
    if (selectValue + 1 > [firstBtn.groupButtons count] || selectValue < 0) {
        selectValue = 0;
    }
    _selectIndex = selectValue;
    
    RadioButton *btn = [[firstBtn groupButtons] objectAtIndex:_selectIndex];
    
    [btn setSelected:YES];
}

- (void)onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        
        NSInteger selectValue = [[firstBtn groupButtons] indexOfObject:sender];
        
        if (selectValue + 1 > [firstBtn.groupButtons count] || selectValue < 0) {
            _selectIndex = 0;
        }
        else {
            _selectIndex = selectValue;
        }
        
        if (self.selectHandle) {
            
            self.selectHandle(self);
        }
        
        [self dismiss];
    }
}

- (void)pressBg {
    
    [self dismiss];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)parentView {
    
    CGPoint p = [parentView convertPoint:CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height*0.9) toView:self];
    
    CGFloat btn_w = 0;
    CGFloat btn_space = 0;
    CGFloat start_x = 0;
    CGFloat start_y = 5;
    
    for (RadioButton *btn in firstBtn.groupButtons) {
        
        btn.frame = CGRectMake(0, start_y, btn.frame.size.width, btn.frame.size.height);
        
        start_y += btn.frame.size.height + btn_space;
        
        if (btn_w < btn.frame.size.width) {
            btn_w = btn.frame.size.width;
        }
    }
    
    if (btn_w < 100) {
        btn_w = 100;
    }
    
    CGFloat content_w = btn_w + 2 * start_x;
    
    if (p.x > content_w / 2 && p.x + content_w/2 < self.frame.size.width) {
        
        content.frame = CGRectMake(p.x - content_w/2, p.y, content_w, start_y);
    }
    else if (p.x < content_w / 2) {
        content.frame = CGRectMake(5, p.y, content_w, start_y);
    }
    else {
        content.frame = CGRectMake(self.frame.size.width - 5 - content_w, p.y, content_w, start_y);
    }
    
    CGPoint p1 = [parentView convertPoint:CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height*0.9) toView:content];
    
    content.anglePosition = CGPointMake(p1.x, 0);
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.fromValue = @(0.1);
    animation.toValue = @(1.0);
    
    [content.layer addAnimation:animation forKey:@"selectViewAnimate"];
}

@end
