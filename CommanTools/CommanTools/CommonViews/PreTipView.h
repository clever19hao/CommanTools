//
//  PreTipView.h
//  HBSDrone
//
//  Created by Arvin on 2018/7/11.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreTipView : UIView

@property (nonatomic,copy) void (^select)(int index);

- (id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message url:(NSString *)url;

@end
