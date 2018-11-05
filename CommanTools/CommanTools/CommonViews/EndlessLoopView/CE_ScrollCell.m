//
//  CE_ScrollCell.m
//  CommanApp
//
//  Created by cxq on 16/5/28.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "CE_ScrollCell.h"

@interface CE_ScrollCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation CE_ScrollCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        if (@available(iOS 11.0,*)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _scrollView.layer.position = CGPointMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height/2);
        
        [self addSubview:_scrollView];
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [_scrollView addSubview:_containerView];
        
        _ivContent = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        _ivContent.contentMode = UIViewContentModeScaleAspectFit;
        _ivContent.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:_ivContent];
        
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singlePress:)];
        gesture1.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gesture1];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doublePress:)];
        gesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:gesture];
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
//    _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    _scrollView.layer.position = CGPointMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height/2);
//    _scrollView.zoomScale = 1.0f;
//    _containerView.frame = self.bounds;
//    _ivContent.frame = _scrollView.bounds;
    
    [self resetZoomScale];
}

- (void)doublePress:(UITapGestureRecognizer *)sender {
    
    if (_scrollView.zoomScale > 1.5) {
        [_scrollView setZoomScale:1 animated:YES];
    }
    else {
        [_scrollView setZoomScale:2 animated:YES];
    }
    
    if ([_cellDelegate respondsToSelector:@selector(didDoublePress:)]) {
        [_cellDelegate didDoublePress:self];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(responseSingle) object:nil];
}

- (void)singlePress:(UITapGestureRecognizer *)sender {
    
    [self performSelector:@selector(responseSingle) withObject:nil afterDelay:0.5];
}

- (void)responseSingle {
    
    if ([_cellDelegate respondsToSelector:@selector(didSinglePress:)]) {
        [_cellDelegate didSinglePress:self];
    }
}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _containerView.frame.size.width;
    CGFloat H = _containerView.frame.size.height;
    
    CGRect rct = _containerView.frame;
    rct.origin.x = (int)MAX((Ws-W)/2, 0);
    rct.origin.y = (int)MAX((Hs-H)/2, 0);
    _containerView.frame = rct;
}

- (void)resetZoomScale {

    if (!_ivContent.image) {
        return;
    }
    
    const CGFloat fullW = self.frame.size.width;
    const CGFloat fullH = self.frame.size.height;
    
    CGSize size =  _ivContent.image.size;
    CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
    CGFloat W = (int)(ratio * size.width);
    CGFloat H = (int)(ratio * size.height);
    _ivContent.frame = CGRectMake(0, 0, W, H);
    _scrollView.contentOffset = CGPointZero;
    _containerView.frame = _ivContent.frame;

    _scrollView.zoomScale = 1;
    
    _ivContent.center = CGPointMake(_containerView.frame.size.width/2, _containerView.frame.size.height/2);
    _containerView.center = CGPointMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height/2);
    _scrollView.contentSize = CGSizeMake(W, H);

}



@end
