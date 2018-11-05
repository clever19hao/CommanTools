//
//  PhotoImageCell.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/25.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "PhotoImageCell.h"

@implementation PhotoImageCell
{
    UIImageView *ivSelect;
}

- (void)dealloc {
    
    //NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    _photoView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        _photoView = [[AdapterImageView alloc] init];
        
        [self.contentView addSubview:_photoView];
                
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longGes.minimumPressDuration = 0.8;
        [self addGestureRecognizer:longGes];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _photoView.frame = self.bounds;
    
    ivSelect.frame = CGRectMake(self.frame.size.width - 16, self.frame.size.height - 16, 15, 15);
}

#pragma mark -

- (void)setCellEditing:(BOOL)edit select:(BOOL)select {
    
    if (edit) {
        
        if (!ivSelect) {
            ivSelect = [[UIImageView alloc] init];
            [self.contentView addSubview:ivSelect];
        }
        ivSelect.frame = CGRectMake(self.frame.size.width - 16, self.frame.size.height - 16, 15, 15);
        ivSelect.hidden = NO;
        
        if (select) {
            ivSelect.image = [UIImage imageNamed:@"choose"];
        }
        else {
            ivSelect.image = [UIImage imageNamed:@"choose_01"];
        }
    }
    else {
        ivSelect.hidden = YES;
        [ivSelect removeFromSuperview];
        ivSelect = nil;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"longPress began");
            if ([_delegate respondsToSelector:@selector(photoCellDidLongPressed:)]) {
                [_delegate photoCellDidLongPressed:self];
            }
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"longPress cancelled");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"longPress failed");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"longPress ended");
            
            break;
        default:
            break;
    }
}

@end
