//
//  ChildPageNetworkModel.h
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/6/28.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChildPageNetworkModel : NSObject

- (void)getFeedsListWithOffset:(NSInteger)offset count:(NSInteger)count success:(void (^)(NSMutableArray *dataArray))success failure:(void (^)(NSError *error))failure;
- (void)downloadImageWithURL:(NSString *)url index:(NSString *)index success:(void (^)(NSString *imagePath))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
