//
//  CommentInputView.m
//  MiniHeadline
//
//  Created by Booooby on 2019/6/28.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "CommentInputView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@interface CommentInputView()

@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation CommentInputView

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];

    // 在layoutSubviews里才设置subviews的frame
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.height.greaterThanOrEqualTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
}


#pragma mark - LazyLoading

- (UIView *)separatorLine {
    if (_separatorLine == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        [self addSubview:view];
        _separatorLine = view;
    }
    return _separatorLine;
}

- (UIButton *)sendButton {
    if (_sendButton == nil || _sendButton == NULL) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"发布" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 15.0;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapGesture:)];
        [button addGestureRecognizer:tap];
        [self addSubview:button];
        _sendButton = button;
    }
    return _sendButton;
}

- (UITextView *)inputTextView {
    if (_inputTextView == nil || _inputTextView == NULL) {
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        textView.layer.borderColor = [[UIColor colorWithHexString:@"#D9D9D9"] CGColor];
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 10;
        textView.layer.masksToBounds = YES;
        textView.font = [UIFont systemFontOfSize:15];
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [self addSubview:textView];
        _inputTextView = textView;
    }
    return _inputTextView;
}


#pragma mark - TapGesture

- (void)commentTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.commentBtnClick) {
        self.commentBtnClick(self.inputTextView.text);
        [self.inputTextView setText:@""];
    }
}


#pragma mark - BlcokSetting

- (void)setCommentBtnClick:(void (^)(NSString * _Nonnull))commentBtnClickBlock {
    _commentBtnClick = commentBtnClickBlock;
}


@end
