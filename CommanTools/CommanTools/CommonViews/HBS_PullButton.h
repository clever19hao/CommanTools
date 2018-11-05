//
//  HBS_PullButton.h
//  Vividia
//
//  Created by Arvin on 2017/6/26.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBS_PullButton : UIView

@property (nonatomic,copy) void (^pressHandle)(NSInteger index);

@property (nonatomic,assign) NSInteger selectIndex;

- (id)initWithItems:(NSArray <NSString *>*)titles images:(NSArray <NSString *> *)imgNames frame:(CGRect)frame;

@end
