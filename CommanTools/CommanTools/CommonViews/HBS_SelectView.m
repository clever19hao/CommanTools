//
//  HBS_SelectView.m
//  Vividia
//
//  Created by Arvin on 2017/4/19.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_SelectView.h"
#import "RadioButton.h"

@implementation HBS_SelectView
{
    UIView *content;
    UILabel *lbTitle;
    RadioButton *firstBtn;
}

- (id)initWithTitle:(NSString *)title btnTitles:(NSArray *)titles {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        content = [[UIView alloc] init];
        [self addTarget:self action:@selector(pressBg) forControlEvents:UIControlEventTouchUpInside];
        content.layer.cornerRadius = 15;
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
        
        CGFloat btn_w = 0;
        CGFloat btn_h = 30;
        CGFloat btn_space = 10;
        CGFloat start_x = 25;
        CGFloat start_y = 40;
        
        for (NSString* optionTitle in titles) {
            
            CGSize size = [optionTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}];
            
            if (btn_w < size.width + 30) {
                btn_w = size.width + 30;
            }
            
            RadioButton* btn = [[RadioButton alloc] initWithFrame:CGRectMake(start_x, start_y, btn_w, btn_h)];
            [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
            [btn setTitle:optionTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
            [content addSubview:btn];
            [buttons addObject:btn];
        }
        
        if (btn_w < 100) {
            btn_w = 100;
        }
        
        for (RadioButton *btn in buttons) {
            btn.frame = CGRectMake(start_x, start_y, btn_w, btn_h);
            start_y += btn_h + btn_space;
        }
        
        content.frame = CGRectMake((self.frame.size.width - (btn_w + 2 * start_x))/2, (self.frame.size.height - start_y)/2, btn_w + 2 * start_x, start_y);
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, content.frame.size.width, 40)];
        lbTitle.numberOfLines = 0;
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.font = [UIFont boldSystemFontOfSize:18];
        lbTitle.text = title;
        [content addSubview:lbTitle];
        
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

-(void) onRadioButtonValueChanged:(RadioButton*)sender
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

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.3;
    animation.fromValue = @(0.1);
    animation.toValue = @(1.0);
    
    [self.layer addAnimation:animation forKey:@"selectViewAnimate"];
}

@end
