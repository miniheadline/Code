//
//  NoImageTableViewCell.m
//  MiniHeadline
//
//  Created by Booooby on 2019/5/30.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "NoImageTableViewCell.h"

@interface NoImageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSMutableDictionary *attrDict;

@end

@implementation NoImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.numberOfLines = 0;
    // 设置行距
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"NoImageTableViewCell";
    NoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID]; // 先从缓存中取
    if (cell == nil) { // IB中创建cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoImageTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

// 重写cellData的setter方法
- (void)setCellData:(NewsModel *)cellData {
    _cellData = cellData;
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:cellData.title attributes:self.attrDict];
    self.publisherLabel.text = cellData.publisher;
    self.commentLabel.text = cellData.comments;
    self.timeLabel.text = cellData.time;
}

@end
