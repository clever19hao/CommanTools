//
//  DisplayImageViewController.m
//  GoogFit
//
//  Created by 陈小青 on 16/4/30.
//  Copyright © 2016年 cxq. All rights reserved.
//

#import "DisplayImageViewController.h"
#import <Photos/Photos.h>
#import "CE_LoopView.h"
#import "CE_ScrollCell.h"
#import "ImageAdapter.h"
#import "AlbumManager.h"
#import "Comman.h"
#import "HBS_Tools.h"
#import "SegButton.h"

@interface DisplayImageViewController () <UIDocumentInteractionControllerDelegate,CE_LoopViewDelegate, UIAlertViewDelegate>
{
    SegButton *seg;
    UIView *infoView;
}

@property (nonatomic,strong) CE_LoopView *loop;

@property (nonatomic,strong) UIDocumentInteractionController *docInteractionController;

@end

@implementation DisplayImageViewController

- (void)dealloc {
    
    [_loop removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    
    self.navigationItem.rightBarButtonItems = @[actionItem];
    
    _loop = [[CE_LoopView alloc] initWithFrame:self.view.bounds delegate:self];
    [self.view addSubview:_loop];
    
    int index = [self currentAdapterIndex];
    self.title = [NSString stringWithFormat:@"%d/%d",index + 1,(int)[_adapterArray count]];
    
    [self->_loop showPage:index];
    
    __weak typeof(self) tmpSelf = self;
    seg = [[SegButton alloc] init];
    seg.backgroundColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:0.4];
    [self.view addSubview:seg];
    [seg setItems:nil imgs:@[[UIImage imageNamed:@"delete"],[UIImage imageNamed:@"details"],[UIImage imageNamed:@"share_01"]]];
    
    seg.pressHandle = ^(NSInteger index) {
        [tmpSelf pressSegButton:index];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45/255.0 green:49/255.0 blue:55/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    _loop.frame = self.view.bounds;
    
    if(@available(iOS 11.0, *)){
        seg.safeEdgeInsets = UIEdgeInsetsMake(self.view.safeAreaInsets.top, self.view.safeAreaInsets.left, self.view.safeAreaInsets.bottom/2, self.view.safeAreaInsets.right);
        seg.frame = CGRectMake(0, self.view.frame.size.height - 44 - self.view.safeAreaInsets.bottom, self.view.frame.size.width, 44 + self.view.safeAreaInsets.bottom);
    }
    else {
        seg.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    
    [self layoutInfoViewFrame];
}
#pragma mark -
#pragma mark - action
- (void)pressSegButton:(NSInteger)index {
    
    
    if (index == 0) {
        [self onDeleteCurrentPhoto:nil];
    }
    else if (index == 1) {
        
        [self showInfoView];
    }
    else {
        [self showShareView];
    }
}

- (void)showShareView {
    
}

- (void)showInfoView {
    
    if (!infoView) {
        
        infoView = [[UIView alloc] initWithFrame:self.view.bounds];
        infoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        UILabel *lbNameTitle = [[UILabel alloc] init];
        lbNameTitle.text = NSLocalizedString(@"photo_fileName",@"文件名");
        lbNameTitle.tag = 1001;
        lbNameTitle.font = [UIFont systemFontOfSize:14];
        lbNameTitle.textColor = [UIColor whiteColor];
        [infoView addSubview:lbNameTitle];
        
        UILabel *lbName = [[UILabel alloc] init];
        lbName.text = @"NAME.JPG";
        lbName.adjustsFontSizeToFitWidth = YES;
        lbName.numberOfLines = 0;
        lbName.tag = 1002;
        lbName.font = [UIFont systemFontOfSize:14];
        lbName.textColor = [UIColor whiteColor];
        [infoView addSubview:lbName];
        
        UILabel *lbDateTitle = [[UILabel alloc] init];
        lbDateTitle.text = NSLocalizedString(@"photo_takeDate",@"拍摄时间");
        lbDateTitle.tag = 1003;
        lbDateTitle.font = [UIFont systemFontOfSize:14];
        lbDateTitle.textColor = [UIColor whiteColor];
        [infoView addSubview:lbDateTitle];
        
        UILabel *lbDate = [[UILabel alloc] init];
        lbDate.text = @"2008-01-01";
        lbDate.tag = 1004;
        lbDate.font = [UIFont systemFontOfSize:14];
        lbDate.textColor = [UIColor whiteColor];
        [infoView addSubview:lbDate];
        
        UILabel *lbLocationTitle = [[UILabel alloc] init];
        lbLocationTitle.text = NSLocalizedString(@"photo_takeLocation",@"拍摄位置");
        lbLocationTitle.tag = 1005;
        lbLocationTitle.font = [UIFont systemFontOfSize:14];
        lbLocationTitle.textColor = [UIColor whiteColor];
        [infoView addSubview:lbLocationTitle];
        
        UILabel *lbLocation = [[UILabel alloc] init];
        lbLocation.text = @"深圳";
        lbLocation.tag = 1006;
        lbLocation.font = [UIFont systemFontOfSize:14];
        lbLocation.textColor = [UIColor whiteColor];
        [infoView addSubview:lbLocation];
        
        UILabel *lbPathTitle = [[UILabel alloc] init];
        lbPathTitle.text = NSLocalizedString(@"photo_filePath",@"文件路径");
        lbPathTitle.tag = 1007;
        lbPathTitle.font = [UIFont systemFontOfSize:14];
        lbPathTitle.textColor = [UIColor whiteColor];
        [infoView addSubview:lbPathTitle];
        
        UILabel *lbPath = [[UILabel alloc] init];
        lbPath.text = @"/..";
        lbPath.adjustsFontSizeToFitWidth = YES;
        lbPath.numberOfLines = 0;
        lbPath.tag = 1008;
        lbPath.font = [UIFont systemFontOfSize:14];
        lbPath.textColor = [UIColor whiteColor];
        [infoView addSubview:lbPath];
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = 1009;
        btnClose.titleLabel.font = [UIFont systemFontOfSize:40];
        [btnClose addTarget:self action:@selector(dismissInfoView) forControlEvents:UIControlEventTouchUpInside];
        [btnClose setTitle:@"✕" forState:UIControlStateNormal];
        [infoView addSubview:btnClose];
        
    }
    
    [self freshInfoView];
    
    [self layoutInfoViewFrame];
    
    [[UIApplication sharedApplication].keyWindow addSubview:infoView];
    infoView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self->infoView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)freshInfoView {
    
    if (infoView) {
        
        UILabel *lbName = (UILabel *)[infoView viewWithTag:1002];
        lbName.text = [_currentAdapter name];
        
        UILabel *lbDate = (UILabel *)[infoView viewWithTag:1004];
        lbDate.text = [_currentAdapter groupKey];
        
        UILabel *lbLocation = (UILabel *)[infoView viewWithTag:1006];
        lbLocation.text = [_currentAdapter location];
        
        UILabel *lbPath = (UILabel *)[infoView viewWithTag:1008];
        lbPath.text = [_currentAdapter path];
    }
}

- (void)dismissInfoView {
    
    [UIView animateWithDuration:0.25 animations:^{
        self->infoView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->infoView removeFromSuperview];
        self->infoView = nil;
    }];
}

- (void)layoutInfoViewFrame {
    
    infoView.frame = self.view.bounds;
    
    CGFloat edge_top = 0;
    CGFloat edge_right = 0;
    if (@available(iOS 11.0,*)) {
        edge_top = self.view.safeAreaInsets.top;
        edge_right = self.view.safeAreaInsets.right;
    }
    
    CGFloat space = 15;
    CGFloat h = 20;
    CGFloat l_w = 100;
    CGFloat r_w = infoView.frame.size.width * 0.5 - 10 - edge_right;
    CGFloat start_y = (infoView.frame.size.height - 4 * h - 3 * space)/2;
    CGFloat start_l_x = infoView.frame.size.width * 0.45 - l_w;
    CGFloat start_r_x = infoView.frame.size.width * 0.5;
    
    UILabel *lbNameTitle = (UILabel *)[infoView viewWithTag:1001];
    lbNameTitle.frame = CGRectMake(start_l_x, start_y, l_w, h);
    UILabel *lbName = (UILabel *)[infoView viewWithTag:1002];
    lbName.frame = CGRectMake(start_r_x, start_y, r_w, h);
    
    start_y += h + space;
    UILabel *lbDateTitle = (UILabel *)[infoView viewWithTag:1003];
    lbDateTitle.frame = CGRectMake(start_l_x, start_y, l_w, h);
    UILabel *lbDate = (UILabel *)[infoView viewWithTag:1004];
    lbDate.frame = CGRectMake(start_r_x, start_y, r_w, h);
    
    start_y += h + space;
    UILabel *lbLocationTitle = (UILabel *)[infoView viewWithTag:1005];
    lbLocationTitle.frame = CGRectMake(start_l_x, start_y, l_w, h);
    UILabel *lbLocation = (UILabel *)[infoView viewWithTag:1006];
    lbLocation.frame = CGRectMake(start_r_x, start_y, r_w, h);
    
    start_y += h + space;
    UILabel *lbPathTitle = (UILabel *)[infoView viewWithTag:1007];
    lbPathTitle.frame = CGRectMake(start_l_x, start_y, l_w, h);
    UILabel *lbPath = (UILabel *)[infoView viewWithTag:1008];
    lbPath.frame = CGRectMake(start_r_x, start_y, r_w, h);
    
    UIButton *btn = (UIButton *)[infoView viewWithTag:1009];
    btn.frame = CGRectMake(infoView.frame.size.width - 66, 6 + edge_top, 60, 60);
}

#pragma mark -

- (int)currentAdapterIndex {
    
    int index = (int)[_adapterArray indexOfObject:_currentAdapter];
    if (index >= [_adapterArray count] || index < 0) {
        index = 0;
    }
    
    return index;
}

- (ImageAdapter *)currentNextAdapter {
    
    int index = [self currentAdapterIndex];
    
    if ([_adapterArray count] <= 1) {
        return nil;
    }
    
    if (index == 0) {
        
        return [_adapterArray lastObject];
    }
    
    return [_adapterArray objectAtIndex:index - 1];
}

- (void)onDeleteCurrentPhoto:(id)sender {
    
    __weak DisplayImageViewController *tmpSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"photo_deleteOneAsk",@"是否删除该文件?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [[AlbumManager shareManager] removeLocalDatas:@{tmpSelf.currentAdapter.groupKey:@[tmpSelf.currentAdapter]} isVideo:NO];
        
        ImageAdapter *delete = [tmpSelf currentNextAdapter];
        
        if (delete == nil) {
            [tmpSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            [tmpSelf.adapterArray removeObject:tmpSelf.currentAdapter];
            tmpSelf.currentAdapter = delete;
            
            int index = [tmpSelf currentAdapterIndex];
            [tmpSelf.loop showPage:index];
            tmpSelf.title = [NSString stringWithFormat:@"%d/%d",(int)(index + 1),(int)[tmpSelf.adapterArray count]];
        }
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)share:(id)sender {
    
    id obj = nil;
    
    if (IOS_SystemVersion < 9.0) {
        
        NSURL *url = [NSURL fileURLWithPath:_currentAdapter.path];
        obj = url;
    }
    else {
        UIImage *img = [_currentAdapter originImage];
        obj = img;
    }
    
    if (!obj) {
        
        [HBS_Tools showToast:@"分享内容为空!"];
        
        return;
    }
    
    UIActivityViewController *c = [[UIActivityViewController alloc] initWithActivityItems:@[obj] applicationActivities:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        c.popoverPresentationController.sourceView = self.view;
        c.popoverPresentationController.sourceRect = CGRectMake(SCREEN_W - 50, 0, SCREEN_H, 64);
    }
    
    [self presentViewController:c animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    seg.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollToImageIndex:(NSInteger)index total:(NSInteger)total {
    
    self.title = [NSString stringWithFormat:@"%d/%d",(int)(index + 1),(int)total];
    
    if (index < [_adapterArray count] && index >= 0) {
        
        _currentAdapter = [_adapterArray objectAtIndex:index];
    }
    
}

#pragma mark - 打开文件委托 ---打开文件
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    DBG(@"documentInteractionControllerDidEndPreview");
    self.docInteractionController = nil;
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    
}
#pragma mark -
- (void)didSingleTouchCell:(CE_ScrollCell *)cell loopView:(CE_LoopView *)loopView {
    
    if (seg.hidden) {
        seg.hidden = NO;
        self.navigationController.navigationBar.hidden = NO;
    }
    else {
        seg.hidden = YES;
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)scrollToPage:(NSInteger)pageIndex loopView:(CE_LoopView *)loopView {
    
    pageIndex = (pageIndex + [_adapterArray count]) % [_adapterArray count];
    
    self.title = [NSString stringWithFormat:@"%d/%d",(int)(pageIndex + 1),(int)[_adapterArray count]];
    
    _currentAdapter = [_adapterArray objectAtIndex:pageIndex];
}

- (void)loadScrollCell:(CE_ScrollCell *)cell loopView:(CE_LoopView *)loopView {
    
    NSInteger index = (cell.index + [_adapterArray count]) % [_adapterArray count];
    
    ImageAdapter *obj = [_adapterArray objectAtIndex:index];
    
    cell.ivContent.image = [obj originImage];
}

- (NSInteger)numberOfSource {
    
    return [_adapterArray count];
}

#pragma mark - share menu delegate
@end
