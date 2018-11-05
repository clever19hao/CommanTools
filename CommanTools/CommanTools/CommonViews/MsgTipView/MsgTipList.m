//
//  MsgTipList.m
//  HBSDrone
//
//  Created by Arvin on 2018/7/11.
//  Copyright © 2018年 钟发军. All rights reserved.
//

#import "MsgTipList.h"
#import "MsgTipCell.h"

@interface TipMsg : NSObject

@property (nonatomic,copy) NSString *msg;
@property (nonatomic,assign) double duration;
@property (nonatomic,assign) TipMsgType type;
@property (nonatomic,copy) DismissHandle handle;//显示时间到期回调，

@end

@implementation TipMsg

@end

@interface MsgTipList () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tbMsgList;
@property (nonatomic,strong) NSMutableArray <TipMsg *> *msgArray;

@end

@implementation MsgTipList
{
    float LIST_H;
    float cell_h;
}

- (id)initWithMaxFrame:(CGRect)rect inView:(UIView *)inView {
    
    if (self = [super init]) {
        
        if (rect.size.height == 0) {
            LIST_H = 150;
        }
        else {
            LIST_H = rect.size.height;
        }
        
        cell_h = LIST_H/5;
        
        _msgArray = [NSMutableArray arrayWithCapacity:1];
        
        _tbMsgList = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, cell_h) style:UITableViewStylePlain];
        _tbMsgList.backgroundColor = [UIColor clearColor];
        _tbMsgList.separatorColor = [UIColor clearColor];
        _tbMsgList.userInteractionEnabled = NO;
        _tbMsgList.delegate = self;
        _tbMsgList.dataSource = self;
        [_tbMsgList registerClass:[MsgTipCell class] forCellReuseIdentifier:@"MsgListCellId"];
        _tbMsgList.rowHeight = cell_h;
        
        if (@available(iOS 11.0,*)) {
            _tbMsgList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [inView addSubview:_tbMsgList];
    }
    
    return self;
}

- (TipMsg *)tipMsgWithMsg:(NSString *)msg {
    
    for (TipMsg *tip in _msgArray) {
        
        if ([tip.msg isEqualToString:msg]) {
            
            return tip;
        }
    }
    
    return nil;
}

#pragma mark -
- (void)addMsg:(NSString *)msg {
    [self addMsg:msg duration:3 type:TipMsgTypeDesc dismissHandle:nil];
}

- (void)addMsg:(NSString *)msg type:(TipMsgType)type {
    [self addMsg:msg duration:3 type:type dismissHandle:nil];
}

- (void)addMsg:(NSString *)msg duration:(double)duration {
    [self addMsg:msg duration:duration type:TipMsgTypeDesc dismissHandle:nil];
}

- (void)addMsg:(NSString *)msg duration:(double)duration type:(TipMsgType)type {
    [self addMsg:msg duration:duration type:type dismissHandle:nil];
}

- (void)addMsg:(NSString *)msg duration:(double)duration type:(TipMsgType)type dismissHandle:(DismissHandle)handle {
    
    TipMsg *tip = [self tipMsgWithMsg:msg];
    if (tip) {
        if (tip.duration > 0) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideMsg:) object:tip];
        }
        
        tip.duration = duration;
        tip.type = type;
        tip.handle = handle;
        
        if (duration > 0) {
            
            NSInteger index = [_msgArray indexOfObject:tip];
            
            if (index >= 0 && index < [_msgArray count]) {
                [_msgArray removeObjectAtIndex:index];
                [_tbMsgList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                
                [_msgArray insertObject:tip atIndex:0];
                [_tbMsgList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            }

            [self performSelector:@selector(delayHideMsg:) withObject:tip afterDelay:duration];
        }
    }
    else {
        tip = [[TipMsg alloc] init];
        [_msgArray insertObject:tip atIndex:0];
        
        tip.msg = msg;
        tip.duration = duration;
        tip.type = type;
        tip.handle = handle;
        
        if (tip.duration > 0) {
            [self performSelector:@selector(delayHideMsg:) withObject:tip afterDelay:tip.duration];
        }
        
        [_tbMsgList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self adjustTableFrame];
    }
}

- (void)delayHideMsg:(TipMsg *)tip {
    
    [self removeTipMsg:tip];
    
    if (tip.handle) {
        tip.handle(tip.msg);
    }
}

- (void)removeTipMsg:(TipMsg *)tip {
    
    NSInteger index = [_msgArray indexOfObject:tip];
    if (index >= 0 && index < [_msgArray count]) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideMsg:) object:tip];
        
        [_msgArray removeObjectAtIndex:index];
        [_tbMsgList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self adjustTableFrame];
    }
}

- (void)hideMsg:(NSString *)msg {
    
    TipMsg *tip = [self tipMsgWithMsg:msg];
    if (tip) {
        [self removeTipMsg:tip];
    }
}

- (BOOL)isExsitMsg:(NSString *)msg {
    
    TipMsg *tip = [self tipMsgWithMsg:msg];
    
    return tip != nil;
}

- (void)hideAllMsg {
    
    [_msgArray removeAllObjects];
    [_tbMsgList reloadData];
    
    [self adjustTableFrame];
}

- (void)adjustTableFrame {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSInteger count = [_msgArray count];
        if (count == 0) {
            count = 1;
        }
        else if (count > 5) {
            count = 5;
        }
        
        _tbMsgList.frame = CGRectMake(_tbMsgList.frame.origin.x, _tbMsgList.frame.origin.y, _tbMsgList.frame.size.width, count * cell_h);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_msgArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgTipCell *cell = (MsgTipCell *)[tableView dequeueReusableCellWithIdentifier:@"MsgListCellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    TipMsg *tip = [_msgArray objectAtIndex:indexPath.row];
    
    if (tip.type == TipMsgTypeDesc) {
        cell.ivMsgFlag.image = [UIImage imageNamed:@"H117A_msgTip_desc"];
        cell.lbMsg.textColor = [UIColor colorWithRed:117/255.0 green:250/255.0 blue:219/255.0 alpha:1];
    }
    else if (tip.type == TipMsgTypeForbid) {
        cell.ivMsgFlag.image = [UIImage imageNamed:@"H117A_msgTip_suggest"];
        cell.lbMsg.textColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:84/255.0 alpha:1];
    }
    else {
        cell.ivMsgFlag.image = [UIImage imageNamed:@"H117A_msgTip_warning"];
        cell.lbMsg.textColor = [UIColor colorWithRed:235/255.0 green:75/255.0 blue:86/255.0 alpha:1];
    }
    cell.lbMsg.text = tip.msg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)test {
    
    __block int count = 0;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0.01 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        count++;
        
        [self addMsg:[NSString stringWithFormat:@"%d %@",count,[self randstring]] duration:rand()%5 + 1 type:rand()%3 dismissHandle:nil];
        
        if (count == 20) {
            
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

- (NSString *)randstring {
    
    int len = rand()%20 + 1;
    
    NSMutableString *str = [NSMutableString string];
    
    for (int i = 0; i < len; i++) {
        [str appendString:@"我"];
    }
    
    return str;
}
@end
