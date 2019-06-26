//
//  InfoTableViewCellWithPicture.h
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/17.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoTableViewCellWithPicture : UITableViewCell

@property (nonatomic, retain)IBOutlet UIButton *username;
@property (nonatomic, retain)IBOutlet UIImageView *person;
@property (nonatomic, retain)IBOutlet UILabel *text;
@property (nonatomic, retain)IBOutlet UIImageView *picture;

@property (nonatomic, retain)IBOutlet UILabel *shareNums;
@property (nonatomic, retain)IBOutlet UILabel *likeNums;
@property (nonatomic, retain)IBOutlet UILabel *commentNums;

@end

NS_ASSUME_NONNULL_END
