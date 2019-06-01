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

@interface NewsDetailViewController ()<WKNavigationDelegate,
                                       WKScriptMessageHandler>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;

@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UIView *footerLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIImageView *writeImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIImageView *shareImageView;

@property (nonatomic, strong) UIView *writeCommentView;
@property (nonatomic, strong) UILabel *writeCommentLabel;

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) UILabel *feedTitleLabel;
@property (nonatomic, strong) UITextView *feedContentTextView;
@property (nonatomic, strong) WKWebView *feeeContentWebView;
@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic) BOOL isStar;
@property (nonatomic) BOOL isLike;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // 获取屏幕尺寸（包括状态栏）
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, 50)];
    [self.view addSubview:self.header];
    
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, screenBound.size.height - 60, screenBound.size.width, 60)];
    [self.view addSubview:self.footer];
    
    self.headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.header.frame.size.height - 0.5, screenBound.size.width, 0.5)];
    self.headerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.header addSubview:self.headerLine];
    
    self.footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, 0.5)];
    self.footerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.footer addSubview:self.footerLine];
    
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenBound.size.width - 160) / 2, 10, 160, 30)];
    self.titleLabel.text = @"今日头条";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [self.header addSubview:self.titleLabel];
    
    // 返回
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    self.backImageView = [[UIImageView alloc] initWithImage:backImage];
    self.backImageView.frame = CGRectMake(10, 10, 30, 30);
    [self.header addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSingleTap:)];
    [self.backImageView addGestureRecognizer:back];
    
    // 搜索
    UIImage *searchImage = [UIImage imageNamed:@"find.png"];
    self.searchImageView = [[UIImageView alloc] initWithImage:searchImage];
    self.searchImageView.frame = CGRectMake(screenBound.size.width - 90, 10, 30, 30);
    [self.header addSubview:self.searchImageView];
    self.searchImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchSingleTap:)];
    [self.searchImageView addGestureRecognizer:search];
    
    // 更多
    UIImage *moreImage = [UIImage imageNamed:@"more.png"];
    self.moreImageView = [[UIImageView alloc] initWithImage:moreImage];
    self.moreImageView.frame = CGRectMake(screenBound.size.width - 40, 10, 30, 30);
    [self.header addSubview:self.moreImageView];
    self.moreImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *more = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSingleTap:)];
    [self.moreImageView addGestureRecognizer:more];
    
    // 写评论
    self.writeCommentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 150, 40)];
    self.writeCommentView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    self.writeCommentView.layer.cornerRadius = 20;
    self.writeCommentView.layer.masksToBounds = YES;
    self.writeCommentView.layer.borderColor = [[UIColor colorWithHexString:@"#D9D9D9"] CGColor];
    self.writeCommentView.layer.borderWidth = 0.5;
    [self.footer addSubview:self.writeCommentView];
    self.writeCommentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *write = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(writeCommentSingleTap:)];
    [self.writeCommentView addGestureRecognizer:write];
    
    UIImage *writeImage = [UIImage imageNamed:@"write.png"];
    self.writeImageView = [[UIImageView alloc] initWithImage:writeImage];
    self.writeImageView.frame = CGRectMake(10, 5, 30, 30);
    [self.writeCommentView addSubview:self.writeImageView];
    
    self.writeCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 30)];
    self.writeCommentLabel.text = @"写评论...";
    [self.writeCommentView addSubview:self.writeCommentLabel];
    
    // 评论
    UIImage *commentImage = [UIImage imageNamed:@"comments.png"];
    self.commentImageView = [[UIImageView alloc] initWithImage:commentImage];
    self.commentImageView.frame = CGRectMake(screenBound.size.width - 220, 10, 30, 30);
    [self.footer addSubview:self.commentImageView];
    self.commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *comment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readCommentSingleTap:)];
    [self.commentImageView addGestureRecognizer:comment];
    
    // 收藏
    UIImage *starImage = [UIImage imageNamed:@"star_unselected.png"];
    self.starImageView = [[UIImageView alloc] initWithImage:starImage];
    self.starImageView.frame = CGRectMake(screenBound.size.width - 160, 10, 30, 30);
    [self.footer addSubview:self.starImageView];
    self.starImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *star = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starSingleTap:)];
    [self.starImageView addGestureRecognizer:star];
    
    // 点赞
    UIImage *likeImage = [UIImage imageNamed:@"like_unselected.png"];
    self.likeImageView = [[UIImageView alloc] initWithImage:likeImage];
    self.likeImageView.frame = CGRectMake(screenBound.size.width - 100, 10, 30, 30);
    [self.footer addSubview:self.likeImageView];
    self.likeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *like = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeSingleTap:)];
    [self.likeImageView addGestureRecognizer:like];
    
    // 分享
    UIImage *shareImage = [UIImage imageNamed:@"share.png"];
    self.shareImageView = [[UIImageView alloc] initWithImage:shareImage];
    self.shareImageView.frame = CGRectMake(screenBound.size.width - 40, 10, 30, 30);
    [self.footer addSubview:self.shareImageView];
    self.shareImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *share = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareSingleTap:)];
    [self.shareImageView addGestureRecognizer:share];
    
    // 内容
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBound.size.height + self.header.frame.size.height, screenBound.size.width, screenBound.size.height - self.header.frame.size.height - self.footer.frame.size.height - statusBound.size.height)];
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

#pragma mark - TapFunctionDefinition

- (void)backSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"backSingleTap");
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"searchSingleTap");
}

- (void)moreSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"moreSingleTap");
}

- (void)writeCommentSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"writeCommentSingleTap");
}

- (void)readCommentSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"readCommentSingleTap");
}

- (void)starSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"starSingleTap");
    
    if (self.isStar == NO) {
        self.isStar = YES;
        self.starImageView.image = [UIImage imageNamed:@"star_selected.png"];
    }
    else {
        self.isStar = NO;
        self.starImageView.image = [UIImage imageNamed:@"star_unselected.png"];
    }
}

- (void)likeSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"likeSingleTap");
    
    if (self.isLike == NO) {
        self.isLike = YES;
        self.likeImageView.image = [UIImage imageNamed:@"like_selected.png"];
    }
    else {
        self.isLike = NO;
        self.likeImageView.image = [UIImage imageNamed:@"like_unselected.png"];
    }
}

- (void)shareSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"shareSingleTap");
}

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
