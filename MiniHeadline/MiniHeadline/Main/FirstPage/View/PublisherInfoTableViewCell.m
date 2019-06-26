//
//  PublisherInfoTableViewCell.m
//  MiniHeadline
//
//  Created by Booooby on 2019/6/24.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "PublisherInfoTableViewCell.h"
#import "UIColor+Hex.h"

@interface PublisherInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end

@implementation PublisherInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.image = [UIImage imageNamed:@"university_logo.jpg"];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.publisherLabel.text = @"中山大学";
    self.publisherLabel.textColor = [UIColor blackColor];
    
    self.timeLabel.text = @"5小时前";
    self.timeLabel.textColor = [UIColor grayColor];
    
    self.followButton.backgroundColor = [UIColor colorWithHexString:@"#EE4000"];
    [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.followButton.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"PublisherInfoTableViewCell";
    PublisherInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID]; // 先从缓存中取
    if (cell == nil) { // IB中创建cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PublisherInfoTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

@end
