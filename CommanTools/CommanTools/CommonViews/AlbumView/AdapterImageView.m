//
//  AdapterImageView.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/21.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "AdapterImageView.h"

@interface AdapterImageView ()

@property (nonatomic,strong) ImageAdapter *adapterData;

@end

@implementation AdapterImageView
{
    UIImageView *videoFlag;
    UILabel *lbDuration;
}

- (void)dealloc {
    //NSLog(@"AdapterImageView delloc %@",[_adapterData name]);
    self.adapterData.imageAdatperChanged = nil;
    self.adapterData = nil;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
                
        videoFlag = [[UIImageView alloc] initWithFrame:CGRectZero];
        videoFlag.image = [UIImage imageNamed:@"video"];
        [self addSubview:videoFlag];

        
        lbDuration = [[UILabel alloc] initWithFrame:CGRectZero];
        lbDuration.adjustsFontSizeToFitWidth = YES;
        lbDuration.font = [UIFont systemFontOfSize:8];
        lbDuration.textColor = [UIColor whiteColor];
        lbDuration.shadowColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        lbDuration.shadowOffset = CGSizeMake(1, -1);
        lbDuration.textAlignment = NSTextAlignmentRight;
        [self addSubview:lbDuration];

    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    videoFlag.frame = CGRectMake(5, self.frame.size.height - 13, 14, 8);
    lbDuration.frame = CGRectMake(20, self.frame.size.height - 14, self.frame.size.width - 24, 10);

}

- (void)loadData:(ImageAdapter *)data {
    
    _adapterData = data;
    
    __weak AdapterImageView *tmpself = self;
    self.adapterData.imageAdatperChanged = ^(id curData) {
        [tmpself freshView];
    };
    [self freshView];
}

- (NSString *)formatStrBySeconds:(long)seconds {
    
    int h = (int)(seconds / 3600);
    int m = (seconds % 3600) / 60;
    int s = seconds % 60;
    
    if (h > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d",m,s];
}

- (void)freshView {
    
    self.image = [self.adapterData thumbImage];
    videoFlag.hidden = ![self.adapterData isShowVideoFlag];
    lbDuration.hidden = ![self.adapterData isShowDuration];
    lbDuration.text = [self formatStrBySeconds:[self.adapterData duration]];
}
@end
