//
//  HBS_SwipView.m
//  Vividia
//
//  Created by Arvin on 2017/6/26.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "HBS_SwipView.h"

NSString *ItemImageKey = @"ItemImage";

@implementation HBS_SwipView
{
    CGPoint origin;
    
    UIView *line;
    
    NSMutableDictionary *showItems;
    
    NSInteger movingTag;
    
    NSMutableDictionary *willAddItems;
    
    CGPoint begin;
}

- (id)initWithOrigin:(CGPoint)point {
    
    if (self = [super initWithFrame:CGRectMake(point.x, point.y, 0, 0)]) {
        
        origin = point;
        
        _itemSize = CGSizeMake(70, 37);
        
        //self.clipsToBounds = YES;
        
        showItems = [NSMutableDictionary dictionaryWithCapacity:1];
        willAddItems = [NSMutableDictionary dictionaryWithCapacity:1];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:128/255.0 green:255/255.0 blue:211/255.0 alpha:1];
        [self addSubview:line];
        
        movingTag = -1;
    }
    
    return self;
}

- (void)addItem:(NSDictionary *)info withTag:(NSInteger)tag {
    
    if (showItems[@(tag)] || willAddItems[@(tag)]) {
        return;
    }
    
    willAddItems[@(tag)] = info;
    
    [self processNext];
}

- (void)processNext {
    
    if (movingTag == -1) {
        
        [self addItemView];
    }
}

- (void)addItemView {
    
    NSArray *keys = [willAddItems allKeys];
    
    CGRect rect = self.frame;
    rect.size.width += _itemSize.width * [keys count];
    rect.size.height = _itemSize.height + 15 + 5;
    self.frame = rect;
    
    line.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    
    CGFloat start_x = [[showItems allKeys] count] * _itemSize.width;
    
    for (NSNumber *key in [willAddItems allKeys]) {
        
        NSInteger tag = [key integerValue];
        NSDictionary *info = willAddItems[key];
        
        UIImageView *ivItem = [[UIImageView alloc] initWithFrame:CGRectMake(start_x, 15, _itemSize.width, _itemSize.height)];
        ivItem.tag = tag;
        ivItem.image = [UIImage imageNamed:info[ItemImageKey]];
        ivItem.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:ivItem];
        
        showItems[@(tag)] = willAddItems[@(tag)];
        start_x += _itemSize.width;
    }
    
    [willAddItems removeAllObjects];
}

- (void)removeItemWithTag:(NSInteger)tag {
    
    [willAddItems removeObjectForKey:@(tag)];
    
    [showItems removeObjectForKey:@(tag)];
    
    if (self.turnOff) {
        self.turnOff(tag);
    }
    
    [self removeItemView:tag complete:^{
        
        self->movingTag = -1;
        
        [self processNext];
    }];
}

- (void)removeItemViewWithTag:(NSInteger)tag {
    
    [willAddItems removeObjectForKey:@(tag)];
    
    [showItems removeObjectForKey:@(tag)];
    
    [self removeItemView:tag complete:^{
        
        self->movingTag = -1;
        
        [self processNext];
    }];
}

- (void)removeItemView:(NSInteger)tag complete:(void (^)(void))complete {
    
    UIView *v = [self viewWithTag:tag];
    
    if (v) {
        
        CGRect rect = self.frame;
        rect.size.width -= _itemSize.width;
        //self.frame = rect;
        
        CGFloat delete_x = v.frame.origin.x;
        
        [v removeFromSuperview];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.frame = rect;
            self->line.frame = CGRectMake(0, self.frame.size.height - 1, rect.size.width, 1);
            
            for (UIView *tmp_v in self.subviews) {
                if (tmp_v.frame.origin.x > delete_x) {
                    tmp_v.frame = CGRectMake(tmp_v.frame.origin.x - self->_itemSize.width, tmp_v.frame.origin.y, tmp_v.frame.size.width, tmp_v.frame.size.height);
                }
            }
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    }
}

#pragma mark - touch
- (void)stopMove {
    
    UIView *v = [self viewWithTag:movingTag];
    if (v.center.y <= 0) {
        
        [self removeItemWithTag:movingTag];
    }
    else {
        
        [UIView animateWithDuration:0.2 animations:^{
            v.center = CGPointMake(v.center.x, 15 + self->_itemSize.height/2);
            v.alpha = 1;
        } completion:^(BOOL finished) {
            self->movingTag = -1;
            [self processNext];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (movingTag != -1) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    if (p.y < 15 || p.y > 15 + _itemSize.height) {
        return;
    }
    
    for (UIView *v in self.subviews) {
        
        if (CGRectContainsPoint(v.frame, p)) {
            
            movingTag = v.tag;
            begin = p;
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (movingTag == -1) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:self];
    
    if (p.y > 15 + _itemSize.height/2) {
        return;
    }
    
    UIView *v = [self viewWithTag:movingTag];
    
    v.center = CGPointMake(v.center.x, (p.y - 15 - _itemSize.height*0.5) * 1.2 + 15 + _itemSize.height*0.5);
    v.alpha = v.center.y / (15 + _itemSize.height*0.5);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (movingTag == -1) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (fabs(p.x - begin.x) < 5 && fabs(p.y - begin.y) < 5) {
        if (self.press) {
            self.press(movingTag);
        }
    }
    
    [self stopMove];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (movingTag == -1) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    if (fabs(p.x - begin.x) < 5 && fabs(p.y - begin.y) < 5) {
        if (self.press) {
            self.press(movingTag);
        }
    }
    
    [self stopMove];
}

@end
