//
//  PreTipView.m
//  HBSDrone
//
//  Created by Arvin on 2018/7/11.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "PreTipView.h"
#import <AVKit/AVKit.h>

@implementation PreTipView
{
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playToEnd {
    [player seekToTime:CMTimeMake(0, 1)];
    [player play];
}

- (void)enterForeground {
    
    [player play];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message url:(NSString *)url {
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat video_h = frame.size.width * 0.558;
        
        //视频高度0.56
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:url]];
        player = [AVPlayer playerWithPlayerItem:item];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        playerLayer.frame = CGRectMake(0, 0, frame.size.width, video_h);
        playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:playerLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        CGFloat lb_space = 8;
        CGFloat btn_h = frame.size.height * 0.12;
        
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
        CGRect msgRect = [message boundingRectWithSize:CGSizeMake(frame.size.width * 0.8, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:NULL];
        if (titleSize.height + lb_space + msgRect.size.height + 6 > frame.size.height - video_h - btn_h) {
            msgRect.size.height = frame.size.height - video_h - btn_h - lb_space - titleSize.height - 6;
        }
        
        CGFloat lb_y = video_h + (frame.size.height - video_h - btn_h - titleSize.height - lb_space - msgRect.size.height)/2;
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, lb_y, frame.size.width, titleSize.height)];
        lbTitle.textColor = [UIColor whiteColor];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.text = title;
        lbTitle.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:lbTitle];
        
        UILabel *lbMessage = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - msgRect.size.width)/2, lb_y + lb_space + titleSize.height, msgRect.size.width, msgRect.size.height)];
        lbMessage.textColor = [UIColor whiteColor];
        lbMessage.numberOfLines = 0;
        lbMessage.adjustsFontSizeToFitWidth = YES;
        lbMessage.textAlignment = NSTextAlignmentCenter;
        lbMessage.text = message;
        lbMessage.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbMessage];
        
        UIButton *btnNoTip = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNoTip.tag = 1000;
        btnNoTip.exclusiveTouch = YES;
        btnNoTip.backgroundColor = [UIColor blackColor];
        btnNoTip.frame = CGRectMake(0, frame.size.height - btn_h, frame.size.width*0.5, btn_h);
        [btnNoTip setTitle:NSLocalizedString(@"track_noLongerTip", @"不 再 提 示") forState:UIControlStateNormal];
        btnNoTip.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnNoTip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnNoTip setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btnNoTip addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnNoTip];
        
        UIButton *btnKnown = [UIButton buttonWithType:UIButtonTypeCustom];
        btnKnown.tag = 1001;
        btnKnown.exclusiveTouch = YES;
        btnKnown.backgroundColor = [UIColor blackColor];
        btnKnown.frame = CGRectMake(frame.size.width*0.5, frame.size.height - btn_h, frame.size.width*0.5, btn_h);
        [btnKnown setTitle:NSLocalizedString(@"track_iKnow", @"我 知 道 了") forState:UIControlStateNormal];
        btnKnown.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnKnown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnKnown setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btnKnown addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnKnown];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.lineWidth = 1;
        shape.strokeColor = [UIColor colorWithRed:96/255.0 green:100/255.0 blue:104/255.0 alpha:1].CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, frame.size.height - btn_h, frame.size.width, btn_h)];
        [path moveToPoint:CGPointMake(frame.size.width * 0.5, frame.size.height - btn_h)];
        [path addLineToPoint:CGPointMake(frame.size.width * 0.5, frame.size.height)];
        shape.path = path.CGPath;
        [self.layer addSublayer:shape];
        
        [player play];
    }
    
    return self;
}

- (void)pressBtn:(UIButton *)sender {
    
    [player pause];
    
    if (self.select) {
        self.select((int)sender.tag - 1000);
    }
}
@end
