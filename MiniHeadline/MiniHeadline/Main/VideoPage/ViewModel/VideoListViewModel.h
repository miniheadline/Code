//
//  VideoListViewModel.h
//  MiniHeadline
//
//  Created by huangscar on 2019/6/19.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListViewModel : NSObject
- (void)getFeedsListWithOffset:(int)offset size:(int)size success:(void (^)(NSMutableArray *dataArray))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
