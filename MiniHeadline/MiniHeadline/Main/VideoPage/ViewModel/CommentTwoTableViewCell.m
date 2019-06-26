//
//  CommentTwoTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/26.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "CommentTwoTableViewCell.h"
#import "../Model/MyComment.h"
#import "Masonry.h"

@interface CommentTwoTableViewCell()

@property (nonatomic, strong) UIButton* icon;
@property (nonatomic, strong) UIButton* name;
//@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *comments;
@property (nonatomic, strong) UILabel *time;

@end

@implementation CommentTwoTableViewCell

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
        self.height = 133;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.icon = [[UIButton alloc] initWithFrame:CGRectMake(16, 15, 30, 30)];
    [self.contentView addSubview:self.icon];
    self.name = [[UIButton alloc] init];
    [self.name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.name.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.name];
    /*self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(348, 18, 46, 23)];
     [self.likeBtn setImage:[UIImage imageNamed:@"like_23.png"] forState:UIControlStateNormal];
     [self.contentView addSubview:self.likeBtn];*/
    self.comments = [[UILabel alloc] initWithFrame:CGRectMake(54, 49, 340, 30)];
    self.comments.font = [UIFont systemFontOfSize:17];
    self.comments.numberOfLines = 0;
    [self.contentView addSubview:self.comments];
    self.time = [[UILabel alloc] init];
    self.time.font = [UIFont systemFontOfSize:12];
    [self.time setTextColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.time];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(15);
        make.height.and.width.equalTo(30);
    }];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon.centerY);
        make.left.equalTo(self.icon.right).with.offset(10);
    }];
    /*[self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.equalTo(self.icon.centerY);
     make.right.equalTo(self.contentView).with.offset(-15);
     }];*/
    [self.comments makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.bottom).with.offset(10);
        make.left.equalTo(self.name.left);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
    [self.time makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comments.bottom).with.offset(10);
        make.left.equalTo(self.comments.left);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

- (void)setCellData:(MyComment*) data username:(NSString*)username {
    self.data = data;
    [self.icon setBackgroundImage:data.icon forState:UIControlStateNormal];
    [self.comments setText:data.comment];
    //CGRect rect = [data.authorName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.name.font} context:nil];
    //[self.name setFrame:CGRectMake(54, 12, rect.size.width, 33)];
    NSString* nameStr = [NSString stringWithFormat:@"%@  回复  %@", data.authorName, username];
    [self.name setTitle:nameStr forState:UIControlStateNormal];
    /*[self.likeBtn setTitle:[NSString stringWithFormat:@"%d", data.likeNum] forState:UIControlStateNormal];*/
    //rect = [data.comment boundingRectWithSize:CGSizeMake(340, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.comments.font} context:nil];
    //NSInteger commentsHeight = ceil(rect.size.height)+1;
    //[self.comments setFrame:CGRectMake(54, 49, 340, commentsHeight)];
    [self.comments setText:data.comment];
    //[self.time setFrame:CGRectMake(54, 49+commentsHeight+20, 340, 21)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.time setText:[dateFormatter stringFromDate:data.date]];
    //self.height += commentsHeight-30;
    
}

@end
