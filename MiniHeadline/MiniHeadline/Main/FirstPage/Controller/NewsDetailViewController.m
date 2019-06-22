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
#import "Masonry.h"


// 静态全局变量
static CGRect screenBound; // 获取屏幕尺寸（包括状态栏）
static CGRect statusBound; // 获取状态栏尺寸


@interface NewsDetailViewController ()<WKNavigationDelegate,
                                       WKScriptMessageHandler>

@property (nonatomic, strong) DetailPageHeaderView *headerView;
@property (nonatomic, strong) DetailPageFooterView *footerView;

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) UILabel *feedTitleLabel;
@property (nonatomic, strong) WKWebView *feedContentWebView;
@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic, strong) CommentsView *commentsView;

@property (nonatomic) NewsDetailViewModel *newsDetailViewModel;
@property (nonatomic) BOOL isStar;
@property (nonatomic) BOOL isLike;

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

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}


#pragma mark - Init

- (void)initVar {
    screenBound = [UIScreen mainScreen].bounds;
    statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    self.newsDetailViewModel = [[NewsDetailViewModel alloc] init];
    
    self.isLike = NO;
    self.isStar = NO;
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 内容
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBound.size.height + self.headerView.frame.size.height, screenBound.size.width, screenBound.size.height - self.headerView.frame.size.height - self.footerView.frame.size.height - statusBound.size.height)];
    self.detailScrollView.backgroundColor = [UIColor whiteColor];
    self.detailScrollView.showsVerticalScrollIndicator = NO;
    self.detailScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.detailScrollView];
    
    self.feedContentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(5, 5, self.detailScrollView.frame.size.width - 10, self.detailScrollView.frame.size.height - 10)];
//    self.feedContentWebView = [[WKWebView alloc] init];
    self.feedContentWebView.navigationDelegate = self;
    self.feedContentWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.feedContentWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.detailScrollView addSubview:self.feedContentWebView];
    [[self.feedContentWebView configuration].userContentController addScriptMessageHandler:self name:@"imageClick"]; // 配置控制器
    
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height)];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.previewImageView];
    self.previewImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *endPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewSingleTap:)];
    [self.previewImageView addGestureRecognizer:endPreview];
    [self.view sendSubviewToBack:self.previewImageView];
    
//    self.commentsView = [[CommentsView alloc] init];
//    [self.detailScrollView addSubview:self.commentsView];
}

- (void)updateViewConstraints {
    [self.feedContentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.detailScrollView);
        make.height.equalTo(self.detailScrollView);
        make.top.equalTo(self.detailScrollView.mas_top).with.offset(10);
        //        make.bottom.equalTo(self.detailScrollView.mas_bottom).with.offset(10);
    }];
    
    [self.commentsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedContentWebView.mas_bottom).with.offset(20);
    }];
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


#pragma mark - LazyLoading

- (DetailPageHeaderView *)headerView {
    if (_headerView == nil) {
//        DetailPageHeaderView *header = [[DetailPageHeaderView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, 50)];
        DetailPageHeaderView *header = [[DetailPageHeaderView alloc] init];
        header.frame = CGRectMake(0, statusBound.size.height, screenBound.size.width, 50);
        
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
                    NSLog(@"completed");
                } else  {
                    NSLog(@"cancled");
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
        DetailPageFooterView *footer = [[DetailPageFooterView alloc] initWithFrame:CGRectMake(0, screenBound.size.height - 60, screenBound.size.width, 60)];
        
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
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
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


@end
