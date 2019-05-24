//
//  PersonInfoCell.h
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/16.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonInfoCell : UITableViewCell

@property (nonatomic, retain)IBOutlet UIImageView *image;
@property (nonatomic, retain)IBOutlet UILabel *label1;
@property (nonatomic, retain)IBOutlet UILabel *label2;
@property (nonatomic, retain)IBOutlet UILabel *label3;
@property (nonatomic, retain)IBOutlet UIButton *btn;

@end

NS_ASSUME_NONNULL_END
