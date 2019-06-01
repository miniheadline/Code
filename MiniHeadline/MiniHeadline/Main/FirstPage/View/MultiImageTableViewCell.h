//
//  MultiImageTableViewCell.h
//  MiniHeadline
//
//  Created by Booooby on 2019/5/25.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiImageTableViewCell : UITableViewCell

@property (nonatomic, strong) NewsModel *cellData;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
