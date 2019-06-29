//
//  ChoosenCommentTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/5/24.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "ChoosenCommentTableViewCell.h"
#import "MyComment.h"
#import "Masonry.h"

@interface ChoosenCommentTableViewCell()
@property (strong, nonatomic) UIButton *icon;
@property (strong, nonatomic) UIButton *name;
@property (nonatomic, strong) UILabel *tagLabel;
//@property (strong, nonatomic) UIButton *followBtn;
@property (strong, nonatomic) UILabel *comment;
@property (strong, nonatomic) UILabel *detail;
//@property (strong, nonatomic) UIButton *likeBtn;
@end

@implementation ChoosenCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.icon = [[UIButton alloc] init];
    self.name = [[UIButton alloc] init];
    [self.name setFont:[UIFont systemFontOfSize:15]];
    [self.name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.tagLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.tagLabel];
    /*self.followBtn = [[UIButton alloc] init];
    [self.followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];*/
    self.comment = [[UILabel alloc] init];
    self.comment.numberOfLines = 0;
    [self.comment setFont:[UIFont systemFontOfSize:17]];
    self.detail = [[UILabel alloc] init];
    [self.detail setFont:[UIFont systemFontOfSize:12]];
    [self.detail setTextColor:[UIColor lightGrayColor]];
    //self.likeBtn = [[UIButton alloc] init];
    //[self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.name];
    //[self.contentView addSubview:self.followBtn];
    [self.contentView addSubview:self.comment];
    [self.contentView addSubview:self.detail];
    //[self.contentView addSubview:self.likeBtn];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.contentView).with.offset(20);
        make.height.and.width.equalTo(30);
    }];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.right).with.offset(10);
        make.top.equalTo(self.icon.top);
    }];
    [self.tagLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.right).with.offset(5);
        make.top.equalTo(self.name.top);
        make.width.equalTo(10);
        make.height.equalTo(5);
    }];
    /*[self.followBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.icon.top);
    }];*/
    [self.comment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.bottom).with.offset(10);
        make.left.equalTo(self.name.left);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
    /*[self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.bottom).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];*/
    [self.detail makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.bottom).with.offset(10);
        make.left.equalTo(self.comment.left);
        make.right.equalTo(self.right).with.offset(10);
     }];
}

- (void)setCellData:(MyComment*) data {
    [self.icon setBackgroundImage:data.icon forState:UIControlStateNormal];
    [self.name setTitle:data.authorName forState:UIControlStateNormal];
    [self.comment setText:data.comment];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.detail setText:[dateFormatter stringFromDate:data.date]];
}

- (void)setTagLabel:(NSString *)tag {
    [self.tagLabel setText:tag];
}

@end
