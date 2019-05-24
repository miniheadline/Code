//
//  NewsDetailViewModel.h
//  MiniHeadline
//
//  Created by Booooby on 2019/5/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewModel : NSObject

- (void)getFeedDetailWithGroupID:(NSString *)groupID success:(void (^)(NSString *content))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END