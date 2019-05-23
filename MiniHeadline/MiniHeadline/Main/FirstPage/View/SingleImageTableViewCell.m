//
//  SingleImageTableViewCell.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "SingleImageTableViewCell.h"

@interface SingleImageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@end


@implementation SingleImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:20.0];
    
    self.publisherLabel.textColor = [UIColor grayColor];
    self.publisherLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.commentsLabel.textColor = [UIColor grayColor];
    self.commentsLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"cell";
    SingleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID]; // 先从缓存中取
    if (cell == nil) { // IB中创建cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SingleImageTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

// 重写cellData的setter方法
- (void)setCellData:(NewsModel *)cellData {
    _cellData = cellData;
    self.firstImageView.image = [[UIImage alloc] initWithContentsOfFile:cellData.firstImagePath];
    self.titleLabel.text = cellData.title;
    self.publisherLabel.text = cellData.publisher;
    self.commentsLabel.text = cellData.comments;
    self.timeLabel.text = cellData.time;
}

@end
