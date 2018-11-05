//
//  AlumbPreview.m
//  HBSDrone
//
//  Created by Arvin on 2018/8/28.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "AlumbPreview.h"
#import "PageScrollView.h"
#import "UIImageView+HBS.h"

@interface AlumbPreview () <PageScrollViewDelegate>
@end

@implementation AlumbPreview
{
    NSMutableArray *itemArray;
    UIImageView *ivFlag;
    UILabel *lbDuration;
    
    PageScrollView *scroll;
    UIButton *btnTouch;
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        scroll = [[PageScrollView alloc] init];
        scroll.delegate = self;
        [self addSubview:scroll];
        
//        btnTouch = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnTouch addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnTouch];
        
        ivFlag = [[UIImageView alloc] init];
        [self addSubview:ivFlag];
        
        lbDuration = [[UILabel alloc] init];
        lbDuration.textColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
        lbDuration.font = [UIFont systemFontOfSize:10];
        lbDuration.layer.shadowOpacity = 0.5;
        lbDuration.layer.shadowColor = [UIColor blackColor].CGColor;
        lbDuration.layer.shadowOffset = CGSizeMake(0, 0);
        [self addSubview:lbDuration];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItem:)];
        [self addGestureRecognizer:ges];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    scroll.frame = self.bounds;
    [scroll reloadData];
    
    btnTouch.frame = self.bounds;
    
    lbDuration.frame = CGRectMake(10, 0, self.frame.size.width - 10, 20);

    if (_isVideo) {
        ivFlag.frame = CGRectMake((self.frame.size.width - 35)/2, (self.frame.size.height - 35)/2, 35, 35);
    }
    else {
        ivFlag.frame = CGRectMake(self.frame.size.width - 10 - 12, self.frame.size.height - 10 - 11, 12, 11);
    }
}

- (void)freshAlubmView {
    
    [scroll reloadData];
    
    if ([itemArray count] < 1) {
        
        lbDuration.text = nil;
        ivFlag.image = nil;
        
        return;
    }
    
    if (_isVideo) {
        lbDuration.text = [self stringFromSeconds:_duration];
        ivFlag.image = [UIImage imageNamed:@"Hubtv_video_flag"];
        ivFlag.frame = CGRectMake((self.frame.size.width - 35)/2, (self.frame.size.height - 35)/2, 35, 35);
    }
    else if ([itemArray count] > 1) {
        lbDuration.text = [NSString stringWithFormat:@"%d/%d",(int)_currentIndex + 1,(int)itemArray.count];
        ivFlag.image = [UIImage imageNamed:@"Hubtv_photo_flag"];
        ivFlag.frame = CGRectMake(self.frame.size.width - 10 - 12, self.frame.size.height - 10 - 11, 12, 11);
    }
    else {
        lbDuration.text = nil;
        ivFlag.image = nil;
    }
}

- (NSString *)stringFromSeconds:(NSTimeInterval)duration {
    
    int seconds = (int)duration;
    
    int h = (int)(seconds / 3600);
    int m = (seconds % 3600)/60;
    int s = seconds%60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
}

- (void)displayWithItems:(NSArray *)items {
    
    if (!itemArray) {
        itemArray = [NSMutableArray arrayWithCapacity:1];
    }

    [itemArray setArray:items];
    
    if (itemArray.count <= _currentIndex) {
        _currentIndex = 0;
    }
    
    [self freshAlubmView];
}

- (void)pressItem:(UIButton *)sender {
    
    if (self.selectIndex) {
        self.selectIndex(_currentIndex);
    }
}

- (int)pageScrollViewNumberOfData {
    return (int)[itemArray count];
}

- (PageView *)pageScrollView:(PageScrollView *)pageScroll pageViewAtIndex:(int)index {
    
    PageView *page = [pageScroll dequeueReusablePageView];
    if (!page) {
        page = [[PageView alloc] init];
    }
    page.frame = pageScroll.bounds;
    page.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [page.imageView HBS_setImageWithURL:[NSURL URLWithString:itemArray[index]] size:CGSizeMake(480, 270) placeholderImage:[UIImage imageNamed:@"HBScenter_head"] cacheToDisk:YES];
    return page;
}

- (void)pageScrollView:(PageScrollView *)pageScroll didEndScrollToIndex:(int)index {
    
    _currentIndex = index;
    lbDuration.text = [NSString stringWithFormat:@"%d/%d",(int)_currentIndex + 1,(int)itemArray.count];
}
@end
