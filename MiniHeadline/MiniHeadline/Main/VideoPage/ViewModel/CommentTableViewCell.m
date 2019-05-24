//
//  CommentTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/5/3.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "../Model/MyComment.h"


@interface CommentTableViewCell()

@property (nonatomic, strong) UIButton* icon;
@property (nonatomic, strong) UIButton* name;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *comments;
@property (nonatomic, strong) UILabel *time;

@end

@implementation CommentTableViewCell

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
    [self.contentView addSubview:self.name];
    self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(348, 18, 46, 23)];
    [self.likeBtn setImage:[UIImage imageNamed:@"like_23.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.likeBtn];
    self.comments = [[UILabel alloc] initWithFrame:CGRectMake(54, 49, 340, 30)];
    self.comments.font = [UIFont systemFontOfSize:20.0];
    self.comments.numberOfLines = 0;
    [self.contentView addSubview:self.comments];
    self.time = [[UILabel alloc] init];
    self.time.font = [UIFont systemFontOfSize:17.0];
    [self.contentView addSubview:self.time];
}

- (void)setCellData:(MyComment*) data {
    self.data = data;
    [self.icon setBackgroundImage:data.icon forState:UIControlStateNormal];
    [self.comments setText:data.comment];
    CGRect rect = [data.authorName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.name.font} context:nil];
    [self.name setFrame:CGRectMake(54, 12, rect.size.width, 33)];
    [self.name setTitle:data.authorName forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", data.likeNum] forState:UIControlStateNormal];
    if(data.isLike == YES) {
        [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_23.png"] forState:UIControlStateNormal];
    }
    rect = [data.comment boundingRectWithSize:CGSizeMake(340, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.comments.font} context:nil];
    NSInteger commentsHeight = ceil(rect.size.height)+1;
    [self.comments setFrame:CGRectMake(54, 49, 340, commentsHeight)];
    [self.comments setText:data.comment];
    [self.time setFrame:CGRectMake(54, 49+commentsHeight+20, 340, 21)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [self.time setText:[dateFormatter stringFromDate:data.date]];
    self.height += commentsHeight-30;
    
}

@end
