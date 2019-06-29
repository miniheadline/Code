//
//  DetailPageFooterView.m
//  MiniHeadline
//
//  Created by Booooby on 2019/6/4.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "DetailPageFooterView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface DetailPageFooterView()

@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIView *writeCommentView;
@property (nonatomic, strong) UILabel *writeCommentLabel;
@property (nonatomic, strong) UIImageView *writeImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@end


@implementation DetailPageFooterView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 在layoutSubviews里才设置subviews的frame
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-20);
        make.width.and.height.equalTo(@30);
    }];
    
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.likeImageView.mas_left).offset(-20);
        make.width.and.height.equalTo(@30);
    }];
    
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.starImageView.mas_left).offset(-20);
        make.width.and.height.equalTo(@30);
    }];
    
//    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.commentImageView.mas_top).offset(-5);
//        make.right.equalTo(self.commentImageView.mas_right).offset(5);
//        make.width.equalTo(@20);
//        make.height.equalTo(@15);
//    }];
    
    [self.writeCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.commentImageView.mas_left).offset(-50);
        make.height.equalTo(@40);
    }];
    
    [self.writeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.writeCommentView.mas_left).offset(10);
        make.top.equalTo(self.writeCommentView.mas_top).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    [self.writeCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.writeCommentView.mas_top).offset(5);
        make.left.equalTo(self.writeImageView.mas_right).offset(5);
        make.right.equalTo(self.writeCommentView.mas_right).offset(-50);
        make.height.equalTo(@30);
    }];
}


#pragma mark - LazyLoading

- (UIView *)separatorLine {
    if (_separatorLine == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
        [self addSubview:view];
        _separatorLine = view;
    }
    return _separatorLine;
}

- (UIView *)writeCommentView {
    if (_writeCommentView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        view.layer.cornerRadius = 20;
        view.layer.borderColor = [[UIColor colorWithHexString:@"#D9D9D9"] CGColor];
        view.layer.borderWidth = 0.5;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(writeTapGesture:)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        _writeCommentView = view;
    }
    return _writeCommentView;
}

- (UILabel *)writeCommentLabel {
    if (_writeCommentLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"写评论...";
        [self.writeCommentView addSubview:label];
        _writeCommentLabel = label;
    }
    return _writeCommentLabel;
}

- (UIImageView *)writeImageView {
    if (_writeImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"write.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.writeCommentView addSubview:imageView];
        _writeImageView = imageView;
    }
    return _writeImageView;
}

- (UIImageView *)commentImageView {
    if (_commentImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"comments.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _commentImageView = imageView;
    }
    return _commentImageView;
}

- (UILabel *)commentCountLabel {
    if (_commentCountLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"0";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.backgroundColor = [UIColor colorWithHexString:@"#FF7256"];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        _commentCountLabel = label;
    }
    return _commentCountLabel;
}

- (UIImageView *)starImageView {
    if (_starImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"star_unselected.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _starImageView = imageView;
    }
    return _starImageView;
}

- (UIImageView *)likeImageView {
    if (_likeImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"like_unselected.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapGesture:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        _likeImageView = imageView;
    }
    return _likeImageView;
}


#pragma mark - TapGesture

- (void)writeTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.writeViewClick) {
        self.writeViewClick();
    }
}

- (void)commentTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.commentBtnClick) {
        self.commentBtnClick();
    }
}

- (void)starTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.starBtnClick) {
        [self setStarBtnStateWithIsStar:self.starBtnClick()];
    }
}

- (void)likeTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.likeBtnClick) {
        [self setLikeBtnStateWithIsLike:self.likeBtnClick()];
    }
}


#pragma mark - BlcokSetting

- (void)setWriteViewClick:(void (^)(void))writeViewClickBlock {
    _writeViewClick = writeViewClickBlock;
}

- (void)setCommentBtnClick:(void (^)(void))commentBtnClickBlock {
    _commentBtnClick = commentBtnClickBlock;
}

- (void)setStarBtnClick:(BOOL (^)(void))starBtnClickBlock {
    _starBtnClick = starBtnClickBlock;
}

- (void)setLikeBtnClick:(BOOL (^)(void))likeBtnClickBlock {
    _likeBtnClick = likeBtnClickBlock;
}


#pragma mark - AuxiliaryFunction

- (void)setStarBtnStateWithIsStar:(BOOL)isStar {
    NSString *imageName = isStar ? @"star_selected.png" : @"star_unselected.png";
    dispatch_async(dispatch_get_main_queue(), ^{
        self.starImageView.image = [UIImage imageNamed:imageName];
    });
}

- (void)setLikeBtnStateWithIsLike:(BOOL)isLike {
    NSString *imageName = isLike ? @"like_selected.png" : @"like_unselected.png";
    dispatch_async(dispatch_get_main_queue(), ^{
        self.likeImageView.image = [UIImage imageNamed:imageName];
    });
}

- (void)setCommentCountWithNumber:(NSInteger)count {
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    });
}


@end
