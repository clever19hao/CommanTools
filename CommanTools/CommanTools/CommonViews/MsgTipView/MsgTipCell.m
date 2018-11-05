//
//  MsgTipCell.m
//  HBSDrone
//
//  Created by Arvin on 2018/10/20.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "MsgTipCell.h"

@interface MsgTipCell ()

@property (nonatomic,strong) UIView *content;

@end

@implementation MsgTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)content {
    
    if (!_content) {
        _content = [UIView new];
        _content.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.contentView addSubview:_content];
    }
    
    return _content;
}

- (UIImageView *)ivMsgFlag {
    
    if (!_ivMsgFlag) {
        
        _ivMsgFlag = [[UIImageView alloc] init];
        [self.content addSubview:_ivMsgFlag];
    }
    
    return _ivMsgFlag;
}

- (UILabel *)lbMsg {
    
    if (!_lbMsg) {
        
        _lbMsg = [[UILabel alloc] init];
        _lbMsg.numberOfLines = 0;
        _lbMsg.adjustsFontSizeToFitWidth = YES;
        _lbMsg.font = [UIFont systemFontOfSize:14];
        [self.content addSubview:_lbMsg];
    }
    
    return _lbMsg;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _content.frame = CGRectMake(0, 2, self.frame.size.width, self.frame.size.height - 4);
    
    if (_ivMsgFlag) {
        _ivMsgFlag.frame = CGRectMake(5, (_content.frame.size.height - 22)/2, 22, 22);
    }
    
    if (_lbMsg) {
        _lbMsg.frame = CGRectMake(CGRectGetMaxX(_ivMsgFlag.frame) + 5, 0, _content.frame.size.width - CGRectGetMaxX(_ivMsgFlag.frame) - 10, _content.frame.size.height);
    }
}

@end
