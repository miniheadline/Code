//
//  InfoTableViewCell.h
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/10.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoTableViewCell : UITableViewCell

@property (nonatomic, retain)IBOutlet UIButton* username;
@property (nonatomic, retain)IBOutlet UIImageView* person;
@property (nonatomic, retain)IBOutlet UILabel* text;
@property (nonatomic, retain)IBOutlet UILabel* label1;
@property (nonatomic, retain)IBOutlet UILabel* label2;
@property (nonatomic, retain)IBOutlet UILabel* label3;
@property (nonatomic, retain)IBOutlet UIImageView* image1;
@property (nonatomic, retain)IBOutlet UIImageView* image2;
@property (nonatomic, retain)IBOutlet UIImageView* image3;


@end

NS_ASSUME_NONNULL_END
