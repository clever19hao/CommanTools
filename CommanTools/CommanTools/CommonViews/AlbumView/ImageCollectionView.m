//
//  ImageCollectionView.m
//  PhotoAlbumManager
//
//  Created by Arvin on 2017/10/31.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ImageCollectionView.h"
#import "PhotoImageCell.h"

@interface SectionButton : UIButton
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation SectionButton
@end

#define ITEM_SPACE  1

@interface ImageCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoImageCellDelegate>

@property (nonatomic,strong) UICollectionView *collection;

@property (nonatomic,strong) NSMutableArray <NSMutableArray <ImageAdapter *> *>* selectArray;

@end

@implementation ImageCollectionView

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = ITEM_SPACE;
        layout.minimumInteritemSpacing = ITEM_SPACE;
        layout.headerReferenceSize = CGSizeMake(30, 40);
        
        if (@available(iOS 9.0, *)) {
            layout.sectionHeadersPinToVisibleBounds = YES;
        }
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        _collection.alwaysBounceVertical = YES;
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:0.8];
        
        [_collection registerClass:[PhotoImageCell class] forCellWithReuseIdentifier:@"PhotoImageCell"];
        
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderSection"];
        
        [self addSubview:_collection];
        
        _dataArray = [NSMutableArray arrayWithCapacity:1];
        _selectArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    _collection.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)layoutSubviews {
    
    //_collection.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self freshView];
}

#pragma mark - Public methods

- (BOOL)isSelectAll {
    
    if ([_selectArray count] == 0) {
        return NO;
    }
    
    for (int i = 0; i < [_dataArray count]; i++) {
        
        if ([_dataArray[i] count] != [_selectArray[i] count]) {
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isSelectAllAtSection:(NSInteger)index {
    
    if ([_selectArray count] <= index) {
        return NO;
    }
    
    if ([_selectArray[index] count] == 0) {
        return NO;
    }
    
    return [_dataArray[index] count] == [_selectArray[index] count];
}

- (void)setIsEditing:(BOOL)isEditing isSelectAll:(BOOL)selectAll {
    
    _isEditing = isEditing;
    
    for (int i = 0; i < [_selectArray count]; i++) {
        [_selectArray[i] removeAllObjects];
    }
    
    if (isEditing && selectAll) {
        
        for (int i = 0; i < [_dataArray count]; i++) {
            [_selectArray[i] setArray:_dataArray[i]];
        }
    }
    
    [self freshView];
    
    if ([_delegate respondsToSelector:@selector(imageCollectionView:didSelectImage:)]) {
        [_delegate imageCollectionView:self didSelectImage:_selectArray];
    }
}

- (void)reloadViewWithData:(NSMutableArray <NSMutableArray <ImageAdapter *> *>* )dataArray {
    
    [_dataArray setArray:dataArray];
    
    [_selectArray removeAllObjects];
    
    for (int i = 0; i < [_dataArray count]; i++) {
        [_selectArray addObject:[NSMutableArray array]];
    }
    
    [self freshView];
}

- (void)reloadData {
    
    [self freshView];
}

#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake([self cell_w_h], [self cell_w_h]);
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_dataArray[section] count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    ImageAdapter *adapter = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    
    [cell.photoView loadData:adapter];
    
    if (_isEditing && [_selectArray[indexPath.section] containsObject:adapter]) {
        
        [cell setCellEditing:_isEditing select:YES];
    }
    else {
        [cell setCellEditing:_isEditing select:NO];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderSection" forIndexPath:indexPath];
    v.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:0.9];
    
    [self freshHeaderView:v atIndexPath:indexPath];
    
    [collectionView bringSubviewToFront:v];
    
    return v;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ImageAdapter *adapter = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];

    if (_isEditing) {
        
        PhotoImageCell *cell = (PhotoImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSMutableArray *secArray = [_selectArray objectAtIndex:indexPath.section];
        
        if ([secArray containsObject:adapter]) {
            [secArray removeObject:adapter];
            [cell setCellEditing:_isEditing select:NO];
        }
        else {
            [secArray addObject:adapter];
            [cell setCellEditing:_isEditing select:YES];
        }
        
        if (@available(iOS 9.0, *)) {
            
            UICollectionReusableView *v = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            [self freshHeaderView:v atIndexPath:indexPath];
        } else {
            // Fallback on earlier versions
            [collectionView reloadData];
        }
        
        if ([_delegate respondsToSelector:@selector(imageCollectionView:didSelectImage:)]) {
            [_delegate imageCollectionView:self didSelectImage:_selectArray];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(imageCollectionView:didPressItem:)]) {
            [_delegate imageCollectionView:self didPressItem:adapter];
        }
        
        PhotoImageCell *cell = (PhotoImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.photoView loadData:adapter];
    }
}

#pragma mark - PhotoImageCellDelegate
- (void)photoCellDidLongPressed:(PhotoImageCell *)cell {
    
    if (_isEditing) {
       
        [self setIsEditing:NO isSelectAll:NO];
    }
    else {
        [self setIsEditing:YES isSelectAll:YES];
    }
}

#pragma mark - Action
- (void)pressSection:(SectionButton *)btn {
    
    NSIndexPath *indexPath = btn.indexPath;
    
    if ([self isSelectAllAtSection:indexPath.section]) {
        
        [_selectArray[indexPath.section] removeAllObjects];
        
        [btn setTitle:NSLocalizedString(@"photo_allSelect",@"全选") forState:UIControlStateNormal];
    }
    else {

        [_selectArray[indexPath.section] removeAllObjects];
        [_selectArray[indexPath.section] addObjectsFromArray:_dataArray[indexPath.section]];
        
        [btn setTitle:NSLocalizedString(@"photo_cancelSelect",@"取消选择") forState:UIControlStateNormal];
    }
    
    [_collection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    
    if ([_delegate respondsToSelector:@selector(imageCollectionView:didSelectImage:)]) {
        [_delegate imageCollectionView:self didSelectImage:_selectArray];
    }
}

#pragma mark - fresh view
- (void)freshView {
    
    [_collection reloadData];
}

- (CGFloat)cell_w_h {
    
    CGFloat w = _collection.frame.size.width;
    CGFloat h = _collection.frame.size.height;
    
    if (w > h) {
        
        return (w - 6*ITEM_SPACE)/7;
    }
    
    return (w - 3*ITEM_SPACE)/4;
}

- (void)freshHeaderView:(UICollectionReusableView *)header atIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lbDate = [header viewWithTag:1000];
    SectionButton *btn = (SectionButton *)[header viewWithTag:1001];
    
    if ([_dataArray[indexPath.section] count] == 0) {
        lbDate.text = nil;
        btn.hidden = NO;
        return;
    }
    
    ImageAdapter *adapter = [_dataArray[indexPath.section] objectAtIndex:indexPath.row];
    NSString *dateStr = adapter.groupKey;
    
    if (!lbDate) {
        lbDate = [[UILabel alloc] initWithFrame:header.bounds];
        lbDate.textColor = [UIColor whiteColor];
        lbDate.font = [UIFont systemFontOfSize:14];
        lbDate.tag = 1000;
        [header addSubview:lbDate];
    }
    lbDate.text = dateStr;
    
    if (!_isEditing) {
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.hidden = YES;
    }
    else {
        if (!btn) {
            btn = [SectionButton buttonWithType:UIButtonTypeSystem];
            btn.tag = 1001;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn addTarget:self action:@selector(pressSection:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:btn];
        }
        btn.indexPath = indexPath;
        
        btn.frame = CGRectMake(header.bounds.size.width - 120, (header.bounds.size.height - 30)/2, 120, 30);
        
        if ([self isSelectAllAtSection:indexPath.section]) {
            [btn setTitle:NSLocalizedString(@"photo_cancelSelect",@"取消选择") forState:UIControlStateNormal];
        }
        else {
            [btn setTitle:NSLocalizedString(@"photo_allSelect",@"全选") forState:UIControlStateNormal];
        }
        btn.hidden = NO;
    }
}
@end
