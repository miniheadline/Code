//
//  DetailPageHeaderView.m
//  MiniHeadline
//
//  Created by Booooby on 2019/6/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "DetailPageHeaderView.h"
#import "UIColor+Hex.h"

@interface DetailPageHeaderView()

@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, strong) UIView *writeCommentView;
@property (nonatomic, strong) UILabel *writeCommentLabel;

@end


@implementation DetailPageHeaderView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 在layoutSubviews里才设置subviews的frame
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.titleLabel.frame = CGRectMake(110, 10, width - 220, 30);
    self.backImageView.frame = CGRectMake(10, 10, 30, 30);
    self.searchImageView.frame = CGRectMake(width - 100, 10, 30, 30);
    self.moreImageView.frame = CGRectMake(width - 50, 10, 30, 30);
    self.separatorLine.frame = CGRectMake(0, height - 0.5, width, 0.5);
}


#pragma mark - LazyLoading

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        // 初始化时不需要设置frame
        UILabel *label = [[UILabel alloc] init];
        label.text = @"微头条";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        // 初始化时不需要设置frame
        UIImage *image = [UIImage imageNamed:@"back.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _backImageView = imageView;
    }
    return _backImageView;
}

- (UIImageView *)searchImageView {
    if (_searchImageView == nil) {
        // 初始化时不需要设置frame
        UIImage *image = [UIImage imageNamed:@"find.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _searchImageView = imageView;
    }
    return _searchImageView;
}

- (UIImageView *)moreImageView {
    if (_moreImageView == nil) {
        // 初始化时不需要设置frame
        UIImage *image = [UIImage imageNamed:@"more.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _moreImageView = imageView;
    }
    return _moreImageView;
}

- (UIView *)separatorLine {
    if (_separatorLine == nil) {
        // 初始化时不需要设置frame
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
        [self addSubview:view];
        _separatorLine = view;
    }
    return _separatorLine;
}


#pragma mark - TapGesture

- (void)backTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.backBtnClick) {
        self.backBtnClick();
    }
}

- (void)searchTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.searchBtnClick) {
        self.searchBtnClick();
    }
}

- (void)moreTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.backBtnClick) {
        self.moreBtnClick();
    }
}


#pragma mark - BlcokSetting

- (void)setBackBtnClickWithBlock:(void (^)(void))backBtnClickBlock {
    _backBtnClick = backBtnClickBlock;
}

- (void)setSearchBtnClickWithBlock:(void (^)(void))searchBtnClickBlock {
    _searchBtnClick = searchBtnClickBlock;
}

- (void)setMoreBtnClickWithBlock:(void (^)(void))moreBtnClickBlock {
    _moreBtnClick = moreBtnClickBlock;
}


@end
