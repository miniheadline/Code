//
//  NewsModel.h
//  MiniHeadline
//
//  Created by Booooby on 2019/4/23.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *firstImagePath;
@property (nonatomic, copy) NSString *groupID;

+ (instancetype)initWithTitle:(NSString *)title imagePath:(NSString *)imagePath groupID:(NSString *)groupID;

@end

NS_ASSUME_NONNULL_END
