//
//  NewsDetailViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/21.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "NewsDetailViewController.h"
#import "SearchViewController.h"
#import "UIColor+Hex.h"
#import "NewsDetailViewModel.h"
#import "UIImageView+WebCache.h"
#import "DetailPageHeaderView.h"
#import "DetailPageFooterView.h"
#import "CommentsView.h"
#import "PublisherInfoTableViewCell.h"
#import "UserInfoModel.h"


// 静态全局变量
static CGRect screenBound; // 获取屏幕尺寸（包括状态栏）
static CGRect statusBound; // 获取状态栏尺寸


@interface NewsDetailViewController ()<UITableViewDelegate,
                                       UITableViewDataSource,
                                       WKUIDelegate,
                                       WKNavigationDelegate,
                                       WKScriptMessageHandler,
                                       UIScrollViewDelegate>

@property (nonatomic, strong) DetailPageHeaderView *headerView;
@property (nonatomic, strong) DetailPageFooterView *footerView;

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UILabel *feedTitleLabel;
@property (nonatomic, strong) UIScrollView *tempScrollView;
@property (nonatomic, strong) WKWebView *feedContentWebView;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) CommentsView *commentsView;
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic) NewsDetailViewModel *newsDetailViewModel;

@property (nonatomic) BOOL isStar;
@property (nonatomic) BOOL isLike;
@property (nonatomic) BOOL isTitleBeyond;
@property (nonatomic) BOOL isLogin;
@property (nonatomic) BOOL isIphoneXSeries;
@property (nonatomic) NSInteger uid;
@property (nonatomic) NSInteger commentCount;

@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@end

@implementation NewsDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVar];

    [self addSubViews];
    
    [self loadNewsData];
    [self loadIsStar];
    [self loadIsLike];
    
    [self addBrowsingHistory];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 判断是否为iPhoneX系列
    if (@available(iOS 11.0, *)) {
        if (self.view.safeAreaInsets.bottom > 0) {
            self.isIphoneXSeries = YES;
            NSLog(@"iPhoneXSeries");
        }
    }
    
    // 有没有更好的方案？
    CGFloat footerHeight = self.isIphoneXSeries ? screenBound.size.height - 50 - self.view.safeAreaInsets.bottom : screenBound.size.height - 50;
    self.footerView.frame = CGRectMake(0, footerHeight, screenBound.size.width, 50);
    self.detailTableView.frame = CGRectMake(0, statusBound.size.height + self.headerView.frame.size.height, screenBound.size.width, screenBound.size.height - self.headerView.frame.size.height - self.footerView.frame.size.height - statusBound.size.height - self.view.safeAreaInsets.bottom);
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self.feedContentWebView.scrollView removeObserver:self forKeyPath:@"contentSize"]; // 移除观察者
}


#pragma mark - Init

- (void)initVar {
    screenBound = [UIScreen mainScreen].bounds;
    statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    self.newsDetailViewModel = [[NewsDetailViewModel alloc] init];
    
    self.isLike = NO;
    self.isStar = NO;
    self.isTitleBeyond = NO;
    self.isIphoneXSeries = NO;
    
    UserInfoModel *user = [UserInfoModel testUser];
    self.isLogin = user.isLogin;
    self.uid = user.uid;
    
    self.webViewHeight = 0.0;
    
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.text = self.newsTitle;
    testLabel.numberOfLines = 0;
    testLabel.lineBreakMode = 0;
    testLabel.font = [UIFont systemFontOfSize:25];
    CGSize size = [testLabel.text boundingRectWithSize:CGSizeMake(screenBound.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:testLabel.font} context:nil].size;
    self.titleLabelHeight = size.height;
    
    
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 内容
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBound.size.height + self.headerView.frame.size.height, screenBound.size.width, screenBound.size.height - self.headerView.frame.size.height - self.footerView.frame.size.height - statusBound.size.height) style:UITableViewStylePlain];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.showsHorizontalScrollIndicator = NO;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailTableView];
    
    self.tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, 1)];
    
    self.feedContentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, 1)];
    self.feedContentWebView.UIDelegate = self;
    self.feedContentWebView.navigationDelegate = self;
    self.feedContentWebView.scrollView.bounces = NO;
    self.feedContentWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.feedContentWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.tempScrollView addSubview:self.feedContentWebView];
    [[self.feedContentWebView configuration].userContentController addScriptMessageHandler:self name:@"imageClick"]; // 配置控制器
    [self.feedContentWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil]; // 添加观察者
    
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height)];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.previewImageView];
    self.previewImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *endPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewSingleTap:)];
    [self.previewImageView addGestureRecognizer:endPreview];
    [self.view sendSubviewToBack:self.previewImageView];
}


#pragma mark - LoadData

- (void)loadNewsData {
    [self.newsDetailViewModel getFeedDetailWithGroupID:_groupID success:^(NSString * _Nonnull content) {
        NSLog(@"content:%@", content);
        // 使用富文本
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, attributedString.length)];
        // 需要回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedContentWebView loadHTMLString:content baseURL:nil];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
    }];
}

- (void)loadIsStar {
    [self.newsDetailViewModel getIsStarWithUid:1 nid:1 success:^(BOOL isStar) {
        self.isStar = isStar;
        [self.footerView setStarBtnStateWithIsStar:isStar];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadIsLike {
    [self.newsDetailViewModel getIsLikeWithUid:1 nid:1 success:^(BOOL isLike) {
        self.isLike = isLike;
        [self.footerView setLikeBtnStateWithIsLike:isLike];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadCommentCount {
    
}


#pragma mark - LazyLoading

- (DetailPageHeaderView *)headerView {
    if (_headerView == nil) {
        DetailPageHeaderView *header = [[DetailPageHeaderView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, 50)];
        
        // 设置回调的Block
        [header setBackBtnClickWithBlock:^{
            NSLog(@"backBtnClick");
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        [header setSearchBtnClickWithBlock:^{
            NSLog(@"searchBtnClick");
            SearchViewController *searchVC = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:searchVC animated:NO];
        }];
        
        [header setMoreBtnClickWithBlock:^{
            NSLog(@"moreBtnClick");
            NSString *titleToShare = self.newsTitle;
            NSArray *activityItems = @[titleToShare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
            // 不出现在活动项目
            activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
            [self presentViewController:activityVC animated:YES completion:nil];
            // 分享之后的回调
            activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                if (completed) {
                    NSLog(@"share completed");
                } else  {
                    NSLog(@"share cancled");
                }
            };
        }];
        
        [self.view addSubview:header];
        _headerView = header;
    }
    return _headerView;
}

- (DetailPageFooterView *)footerView {
    if (_footerView == nil) {
        DetailPageFooterView *footer = [[DetailPageFooterView alloc] initWithFrame:CGRectMake(0, screenBound.size.height - 50, screenBound.size.width, 50)];
        
        // 设置回调的Block
        [footer setWriteViewClick:^{
            NSLog(@"writeViewClick");
        }];
        
        [footer setCommentBtnClick:^{
            NSLog(@"commentBtnClick");
        }];
        
        [footer setStarBtnClick:^{
            NSLog(@"starBtnClick");
            
            self.isStar = !self.isStar;
            return self.isStar;
        }];
        
        [footer setLikeBtnClick:^{
            NSLog(@"likeBtnClick");
            self.isLike = !self.isLike;
            return self.isLike;
        }];
        
        [self.view addSubview:footer];
        _footerView = footer;
    }
    return _footerView;
}


#pragma mark - TapGesture

- (void)previewSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"previewSingleTap");
    self.previewImageView.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:self.previewImageView];
}


#pragma mark - AuxiliaryFunction

- (void)addBrowsingHistory {
    [self.newsDetailViewModel readNewsWithUid:1 nid:1 success:^{
        NSLog(@"success");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"observe value: contentSize");
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.feedContentWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.tempScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.tempScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - WKNavigationDelegate

// JS调用OC
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.webkit.messageHandlers.imageClick.postMessage(this.src)}}}" completionHandler:nil];
    [webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:nil];
    
}


#pragma mark - WKScriptMessageHandler

// OC调用JS
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"imageClick"]) {
        NSLog(@"%@", message.body);
        [self.previewImageView sd_setImageWithURL:message.body completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"error:%@", error);
            self.previewImageView.backgroundColor = [UIColor blackColor];
            [self.view bringSubviewToFront:self.previewImageView];
        }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.titleLabelHeight + 20;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return self.webViewHeight;
            break;
        default:
            return 50;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *titleCell = [[UITableViewCell alloc] init];
            titleCell.textLabel.text = self.newsTitle;
            titleCell.textLabel.font = [UIFont systemFontOfSize:25];
            titleCell.textLabel.numberOfLines = 0;
            titleCell.textLabel.lineBreakMode = 0;
            titleCell.userInteractionEnabled = NO;
            return titleCell;
            break;
        }
        case 1: {
            PublisherInfoTableViewCell *publisherCell = [PublisherInfoTableViewCell cellWithTableView:tableView];
            publisherCell.userInteractionEnabled = NO;
            return publisherCell;
            break;
        }
        case 2: {
            UITableViewCell *webCell = [[UITableViewCell alloc] init];
            [webCell.contentView addSubview:self.tempScrollView];
            return webCell;
            break;
        }
        default: {
            UITableViewCell *defaultCell = [[UITableViewCell alloc] init];
            NSLog(@"default");
            return defaultCell;
            break;
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.titleLabelHeight + 70 && self.isTitleBeyond == NO) {
        [self.headerView changeTitleWithPublisher:@"中山大学"];
        self.isTitleBeyond = YES;
        NSLog(@"changeTitle");
    }
    else if (scrollView.contentOffset.y < self.titleLabelHeight + 70 && self.isTitleBeyond == YES) {
        [self.headerView resetTitle];
        self.isTitleBeyond = NO;
        NSLog(@"resetTitle");
    }
}


@end
