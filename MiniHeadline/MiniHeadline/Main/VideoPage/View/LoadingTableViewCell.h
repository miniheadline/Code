//
//  LoadingTableViewCell.h
//  MiniHeadline
//
//  Created by huangscar on 2019/4/25.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    LoadingStatusDefault,
    LoadingStatusLoding,
    LoadingStatusNoMore
} LoadingStatus;

@interface LoadingTableViewCell : UITableViewCell
@property(nonatomic, assign) LoadingStatus status;
@end

NS_ASSUME_NONNULL_END
