//
//  PhotoImageCell.h
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/25.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdapterImageView.h"

@class PhotoImageCell;

@protocol PhotoImageCellDelegate <NSObject>

- (void)photoCellDidLongPressed:(PhotoImageCell *)cell;

@end

@interface PhotoImageCell : UICollectionViewCell

@property (nonatomic,strong,readonly) AdapterImageView *photoView;

@property (nonatomic,weak) id <PhotoImageCellDelegate> delegate;

- (void)setCellEditing:(BOOL)edit select:(BOOL)select;

@end
