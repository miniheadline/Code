//
//  NewsDetailViewController.h
//  MiniHeadline
//
//  Created by Booooby on 2019/4/21.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewController : UIViewController

@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic) NSInteger nid;

@end

NS_ASSUME_NONNULL_END
