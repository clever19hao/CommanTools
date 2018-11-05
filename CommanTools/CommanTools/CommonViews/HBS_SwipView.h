//
//  HBS_SwipView.h
//  Vividia
//
//  Created by Arvin on 2017/6/26.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *ItemImageKey;

@interface HBS_SwipView : UIView

@property (nonatomic,copy) void (^turnOff)(NSInteger tag);
@property (nonatomic,copy) void (^press)(NSInteger tag);

@property (nonatomic,assign) CGSize itemSize;

- (id)initWithOrigin:(CGPoint)point;

- (void)addItem:(NSDictionary *)info withTag:(NSInteger)tag;

- (void)removeItemViewWithTag:(NSInteger)tag;

@end
