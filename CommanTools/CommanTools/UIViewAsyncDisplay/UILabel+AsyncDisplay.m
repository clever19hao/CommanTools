//
//  UILabel+AsyncDisplay.m
//  HBSDrone
//
//  Created by Arvin on 2018/11/4.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "UILabel+AsyncDisplay.h"
#import "UIView+AsyncDisplay.h"

@implementation UILabel (AsyncDisplay)

- (void)async_setViewWithObj:(id <AsyncLoad>)obj key:(NSString *)key placeholder:(NSString *)placeholder {
    
    if (placeholder) {
        self.text = placeholder;
    }
    
    [self async_setViewWithObj:obj key:key freshBlock:^(UIView *weakView, id result, NSError *error) {
        
        if (result) {
            ((UILabel *)weakView).text = result;
        }
        else {
            NSLog(@"*********result is nil********");
        }
    }];
}

@end
