//
//  MultiImageTableViewCell.m
//  MiniHeadline
//
//  Created by Booooby on 2019/5/25.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "MultiImageTableViewCell.h"

@interface MultiImageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (nonatomic, strong) NSMutableDictionary *attrDict;

@end

@implementation MultiImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.numberOfLines = 0;
    self.attrDict = [NSMutableDictionary dictionary];
    self.attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:20.0];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0;
    self.attrDict[NSParagraphStyleAttributeName] = paraStyle;
    
    self.publisherLabel.textColor = [UIColor grayColor];
    self.publisherLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.commentLabel.textColor = [UIColor grayColor];
    self.commentLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:10.0];
    
    self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"MultiImageTableViewCell";
    MultiImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID]; // 先从缓存中取
    if (cell == nil) { // IB中创建cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MultiImageTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

// 重写cellData的setter方法
- (void)setCellData:(NewsModel *)cellData {
    _cellData = cellData;
    self.firstImageView.image = [[UIImage alloc] initWithContentsOfFile:cellData.firstImagePath];
    self.secondImageView.image = [[UIImage alloc] initWithContentsOfFile:cellData.secondImagePath];
    self.thirdImageView.image = [[UIImage alloc] initWithContentsOfFile:cellData.thirdImagePath];
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:cellData.title attributes:self.attrDict];
    self.publisherLabel.text = cellData.publisher;
    self.commentLabel.text = cellData.comments;
    self.timeLabel.text = cellData.time;
}


@end
