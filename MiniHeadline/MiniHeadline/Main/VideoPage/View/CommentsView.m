//
//  CommentsView.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/1.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "CommentsView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"


@interface CommentsView()<UITableViewDelegate>
@property (nonatomic, strong) UILabel *commentViewLabel;

@property (nonatomic, strong) UIButton *closeCommentViewBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, assign) LoadingStatus status2;
@property (nonatomic, assign) NSUInteger pageIndexSecond;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) int offset;
@property (nonatomic, assign) BOOL hasMore;
@end
@implementation CommentsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isLoading = false;
        self.offset = 0;
        self.hasMore = YES;
        /*self.commentViewLabel = [[UILabel alloc]init];
        [self.commentViewLabel setText:@"所有评论"];
        [self addSubview:self.commentViewLabel];*/
        
        /*self.commentViewTableView = ([[UITableView alloc]initWithFrame:CGRectMake(0, 52, self.frame.size.width, 290) style:UITableViewStylePlain]);
        self.commentViewTableView.delegate = self;
        self.commentViewTableView.dataSource = self;
        self.commentViewTableView.tableFooterView = [UIView new];
        [self addSubview:self.commentViewTableView];
        
        /*self.closeCommentViewBtn = [[UIButton alloc] init];
        [self.closeCommentViewBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [self.closeCommentViewBtn addTarget:self action:@selector(closeComment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeCommentViewBtn];*/
        
    }
    return self;
}

#pragma mark- 懒加载
- (UILabel *)commentViewLabel{
    if (_commentViewLabel == nil) {
        UILabel *commentViewLabel = [[UILabel alloc]init];
        [commentViewLabel setText:@"所有回复"];
        commentViewLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:commentViewLabel];
        _commentViewLabel = commentViewLabel;
    }
    return _commentViewLabel;
}

- (IBAction)closeComment:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(closeCommentsViewBtnDelegate:)]){
        //[self.startBtn removeFromSuperview];
        [_delegate closeCommentsViewBtnDelegate:self];
    }
    [self removeFromSuperview];
}

- (UITableView *) commentViewTableView {
    if(_commentViewTableView == nil) {
        UITableView* tableView = ([[UITableView alloc]initWithFrame:CGRectMake(0, 52, self.frame.size.width, 400) style:UITableViewStylePlain]);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = NO;
//        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        tableView.mj_footer = footer;
        [self addSubview:tableView];
        _commentViewTableView = tableView;
    }
    return _commentViewTableView;
}

- (UIButton *) closeCommentViewBtn {
    if(_closeCommentViewBtn == nil) {
        UIButton *closeCommentViewBtn = [[UIButton alloc] init];
        [closeCommentViewBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeCommentViewBtn addTarget:self action:@selector(closeComment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeCommentViewBtn];
        _closeCommentViewBtn = closeCommentViewBtn;
    }
    return _closeCommentViewBtn;
}

- (UIView *) line1 {
    if(_line1 == nil) {
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithHexString:@"#D9D9D9"]];
        [self addSubview:line];
        _line1 = line;
    }
    return _line1;
}

- (UIView *) line2 {
    if(_line2 == nil) {
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self addSubview:line];
        _line2 = line;
    }
    return _line2;
}

#pragma mark- 模型赋值
- (void)setCommentData:(MyComment *)choosenComment{
    _choosenComment = choosenComment;
    //NSArray* commentPart = [self loadComment:1];
    //self.commentsListSecond = [NSMutableArray arrayWithArray:commentPart];
    //self.pageIndexSecond = 0;
    //[self.commentViewTableView reloadData];
    self.commentsListSecond = [[NSMutableArray alloc] init];
    [self loadMoreData];
}

#pragma mark- 子控件坐标
//这个方法专门用于布局子控件,一般在这里设置子控件的frame
//当控件本身的尺寸发送改变时，系统会自动调用这个方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat personW = self.frame.size.width;
    CGFloat personH = self.frame.size.height;
    
    [self.closeCommentViewBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.width.height.equalTo(25);
    }];
    [self.commentViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeCommentViewBtn.centerY);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(50);
    }];
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentViewLabel.bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(1);
    }];
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentViewLabel.top);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(1);
    }];
    //self.commentViewTableView.frame = CGRectMake(0, 52, self.frame.size.width, 480);
    [self.commentViewTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.bottom);
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self loadMoreData];
}

/*- (void)loadMoreData {
    NSLog(@"loadMoreData");
    self.isLoading = YES;
    CommentIDViewModel *viewModel = [[CommentIDViewModel alloc] init];
    [viewModel getCommentListWithID:self.choosenComment.cid offset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        if(dataArray.count == 0) {
            self.hasMore = NO;
        }
        else {
            self.hasMore = YES;
        }
        if (dataArray != nil) {
            [self.commentsListSecond addObjectsFromArray:dataArray];
        }
        NSLog(@"count: %d", self.commentsListSecond.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentViewTableView reloadData];
//            [self.commentViewTableView.mj_footer endRefreshing];
            self.isLoading = NO;
            self.offset = self.commentsListSecond.count;
        });
    } failure:^(NSError * _Nonnull error) {
//        [self.commentViewTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    else {
        return self.commentsListSecond.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger cellType;
    UITableViewCell* cell;
    if(indexPath.section == 0) {
        cellType = 3;
    }
    else {
        cellType = self.commentsListSecond[indexPath.row].cellType;
    }
    NSString* cellTypeString = [NSString stringWithFormat:@"cellType:%d", cellType];
    cell = [tableView dequeueReusableCellWithIdentifier:cellTypeString];
    if(cell == nil) {
        if(cellType == 0){
            cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            ((LoadingTableViewCell*) cell).status = self.status2;
            cell.selectionStyle = ((self.status2==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
        }
        else if(cellType == 2) {
            cell = [[CommentTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            //[(CommentTableViewCell*)cell setCellData:self.commentsListSecond[indexPath.row]];
            [(CommentTwoTableViewCell*)cell setCellData:self.commentsListSecond[indexPath.row] username:self.choosenComment.authorName];
        }
        else if(cellType == 3) {
            cell = [[ChoosenCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTypeString];
            [(ChoosenCommentTableViewCell*)cell setCellData:self.choosenComment];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            cellType = 3;
        }
    } else {
        if(cellType == 0){
            ((LoadingTableViewCell*) cell).status = self.status2;
            cell.selectionStyle = ((self.status2==LoadingStatusDefault)?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone);
        }
        else if(cellType == 2) {
            [(CommentTwoTableViewCell*)cell setCellData:self.commentsListSecond[indexPath.row] username:self.choosenComment.authorName];
        }
        else if(cellType == 3) {
            [(ChoosenCommentTableViewCell*)cell setCellData:self.choosenComment];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        }
    }
    cell.userInteractionEnabled = NO;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return self.choosenComment.height;
    }
    return self.commentsListSecond[indexPath.row].height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willSelectRowAtIndexPath:%@", indexPath);
    if (indexPath.row == self.commentsListSecond.count - 1 && self.isLoading == NO && _hasMore == YES) {
        [self loadMoreData];
    }
}

- (void)loadNewData {
    NSLog(@"loadNewData");
    self.isLoading = YES;
    CommentIDViewModel *viewModel = [[CommentIDViewModel alloc] init];
    [viewModel getCommentListWithID:self.choosenComment.cid offset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        if(dataArray.count == self.commentsListSecond.count) {
            self.hasMore = NO;
        }
        else {
            self.hasMore = YES;
        }
        if (dataArray != nil && dataArray.count > self.commentsListSecond.count) {
            //[self.commentsList addObjectsFromArray:dataArray];
            if(self.commentsListSecond.count > 0) {
                int count = self.commentsListSecond.count;
                int minID = self.commentsListSecond[count-1].cid;
                //int maxID = self.commentsList[0].cid;
                //NSPredicate *backApredicate = [NSPredicate predicateWithFormat:@"cid<%ld AND cid>=%ld",minID, minID-10];
                NSPredicate *beforeApredicate = [NSPredicate predicateWithFormat:@"cid>%ld", minID];
                if(beforeApredicate != nil) {
                    NSArray *beforeArray = [dataArray filteredArrayUsingPredicate:beforeApredicate];
                    if(beforeArray.count > 0) {
                        [self.commentsListSecond removeAllObjects];
                        [self.commentsListSecond addObjectsFromArray:beforeArray];
                    }
                }
                /*if(backApredicate != nil) {
                 NSArray *afterArray = [dataArray filteredArrayUsingPredicate:backApredicate];
                 if(afterArray.count > 0) {
                 [self.commentsList addObjectsFromArray:afterArray];
                 }
                 }*/
            }
            else {
                int count = dataArray.count < 5 ? dataArray.count : 5;
                for(int i = 0; i < count; i++) {
                    [self.commentsListSecond addObject:dataArray[i]];
                }
            }
        }
        NSLog(@"count: %d", self.commentsListSecond.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.commentViewTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.commentTableView reloadData];
            [self.commentViewTableView.mj_header endRefreshing];
            self.isLoading = NO;
            self.offset = self.commentsListSecond.count;
        });
    } failure:^(NSError * _Nonnull error) {
        [self.commentViewTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
    //[self.detailCell loadNewLikeNum];
    
}

- (void)loadMoreData {
    NSLog(@"loadMoreData");
    self.isLoading = YES;
    CommentIDViewModel *viewModel = [[CommentIDViewModel alloc] init];
    [viewModel getCommentListWithID:self.choosenComment.cid offset:self.offset size:5 success:^(NSMutableArray * _Nonnull dataArray) {
        if(dataArray.count == self.commentsListSecond.count) {
            self.hasMore = NO;
        }
        else {
            self.hasMore = YES;
        }
        if (dataArray != nil && dataArray.count > self.commentsListSecond.count) {
            //[self.commentsList addObjectsFromArray:dataArray];
            if(self.commentsListSecond.count > 0) {
                int count = self.commentsListSecond.count;
                int minID = self.commentsListSecond[count-1].cid;
                int maxID = self.commentsListSecond[0].cid;
                NSPredicate *backApredicate = [NSPredicate predicateWithFormat:@"cid<=%ld AND cid>=%ld",maxID, minID-10];
                //NSPredicate *beforeApredicate = [NSPredicate predicateWithFormat:@"cid>%ld", maxID];
                /*if(beforeApredicate != nil) {
                 NSArray *beforeArray = [dataArray filteredArrayUsingPredicate:beforeApredicate];
                 if(beforeArray.count > 0) {
                 NSRange range = NSMakeRange(0, beforeArray.count);
                 NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                 [self.commentsList insertObjects:beforeArray atIndexes:indexSet];
                 }
                 }*/
                if(backApredicate != nil) {
                    NSArray *afterArray = [dataArray filteredArrayUsingPredicate:backApredicate];
                    if(afterArray.count > 0) {
                        [self.commentsListSecond removeAllObjects];
                        [self.commentsListSecond addObjectsFromArray:afterArray];
                    }
                }
            }
            else {
                int count = dataArray.count < 5 ? dataArray.count : 5;
                for(int i = 0; i < count; i++) {
                    [self.commentsListSecond addObject:dataArray[i]];
                }
            }
        }
        NSLog(@"count: %d", self.commentsListSecond.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            [self.commentViewTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.commentTableView reloadData];
            [self.commentViewTableView.mj_footer endRefreshing];
            self.isLoading = NO;
            self.offset = self.commentsListSecond.count;
        });
    } failure:^(NSError * _Nonnull error) {
        [self.commentViewTableView.mj_footer endRefreshing];
        self.isLoading = NO;
    }];
}
@end
