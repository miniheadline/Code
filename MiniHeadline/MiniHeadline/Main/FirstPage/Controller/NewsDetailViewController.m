//
//  NewsDetailViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/21.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "NewsDetailViewController.h"
#import "UIColor+Hex.h"
#import "NewsDetailViewModel.h"
#import "UIImageView+WebCache.h"
#import "DetailPageHeaderView.h"
#import "DetailPageFooterView.h"


// 静态全局变量
static CGRect screenBound; // 获取屏幕尺寸（包括状态栏）
static CGRect statusBound; // 获取状态栏尺寸


@interface NewsDetailViewController ()<WKNavigationDelegate,
                                       WKScriptMessageHandler>

@property (nonatomic, strong) DetailPageHeaderView *headerView;
@property (nonatomic, strong) DetailPageFooterView *footerView;

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) UILabel *feedTitleLabel;
@property (nonatomic, strong) UITextView *feedContentTextView;
@property (nonatomic, strong) WKWebView *feeeContentWebView;
@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic) BOOL isStar;
@property (nonatomic) BOOL isLike;

@end

@implementation NewsDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenBound = [UIScreen mainScreen].bounds;
    statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    [self addSubViews];
    
    self.isStar = NO;
    self.isLike = NO;
    
    NSLog(@"%@", _groupID);
    
    
    // for test
    NewsDetailViewModel *newsDetailViewModel = [[NewsDetailViewModel alloc] init];
    [newsDetailViewModel getFeedDetailWithGroupID:_groupID success:^(NSString * _Nonnull content) {
        NSLog(@"content:%@", content);
        // 使用富文本
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, attributedString.length)];
        // 需要回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.feedContentTextView.attributedText = attributedString;
            [self.feeeContentWebView loadHTMLString:content baseURL:nil];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 内容
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBound.size.height + self.headerView.frame.size.height, screenBound.size.width, screenBound.size.height - self.headerView.frame.size.height - self.footerView.frame.size.height - statusBound.size.height)];
    self.detailScrollView.backgroundColor = [UIColor whiteColor];
    self.detailScrollView.showsVerticalScrollIndicator = NO;
    self.detailScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.detailScrollView];
    
    self.feeeContentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(5, 5, self.detailScrollView.frame.size.width - 10, self.detailScrollView.frame.size.height - 10)];
    self.feeeContentWebView.navigationDelegate = self;
    self.feeeContentWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.feeeContentWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.detailScrollView addSubview:self.feeeContentWebView];
    [[self.feeeContentWebView configuration].userContentController addScriptMessageHandler:self name:@"imageClick"]; // 配置控制器
    
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height)];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.previewImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.previewImageView];
    self.previewImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *endPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewSingleTap:)];
    [self.previewImageView addGestureRecognizer:endPreview];
    [self.view sendSubviewToBack:self.previewImageView];
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
        }];
        
        [header setMoreBtnClickWithBlock:^{
            NSLog(@"moreBtnClick");
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
        
        [footer setShareBtnClick:^{
            NSLog(@"shareBtnClick");
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
