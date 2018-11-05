//
//  CE_ScrollCell.h
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHProgressView;
@class CE_ScrollCell;

@protocol scrollCellDelegate <NSObject>

@optional
- (void)didSinglePress:(CE_ScrollCell *)cell;

- (void)didDoublePress:(CE_ScrollCell *)cell;

@end

@interface CE_ScrollCell : UIView

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) UIImageView *ivContent;

@property (nonatomic,strong) SHProgressView *progressHUD;

@property (nonatomic,weak) id <scrollCellDelegate> cellDelegate;

- (void)resetZoomScale;


@end
