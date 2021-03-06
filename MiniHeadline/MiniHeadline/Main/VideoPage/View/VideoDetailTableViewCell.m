//
//  VideoDetailTableViewCell.m
//  MiniHeadline
//
//  Created by huangscar on 2019/6/11.
//  Copyright © 2019 Booooby. All rights reserved.
//
// 定义这个常量，就可以不用在开发过程中使用mas_前缀。
#define MAS_SHORTHAND
// 定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
#import "VideoDetailTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "PostViewModel.h"
#import "UserInfoModel.h"

@interface VideoDetailTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *icon;
@property (nonatomic, strong) UILabel *name;
//@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UILabel *moreDetail;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) MyVideo *myVideo;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) int uid;
@end

@implementation VideoDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UserInfoModel *user = [UserInfoModel testUser];
        self.isLogin = user.isLogin;
        self.uid = user.uid;
        
        [self initSubView];
    }
    return self;
}

- (void)setData {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin){
        [viewModel getIsLikeWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLike) {
            self.myVideo.isLike = isLike;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isLike) {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
        [viewModel getLikeNumWithUid:self.uid vid:self.myVideo.vid success:^(int likeNumGet) {
            self.myVideo.likeNum = likeNumGet;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
    }
}

- (void)initSubView {
    CGRect screenBound = [UIScreen mainScreen].bounds;
    //[self.icon setBackgroundImage:self.myVideo.icon forState:UIControlStateNormal];
    self.icon = [[UIButton alloc] init];
    [self.contentView addSubview:self.icon];
    self.name = [[UILabel alloc] init];
    //self.name = [[UILabel alloc] initWithFrame:CGRectMake(62, 311, 254, 35)];
    self.name.font = [UIFont systemFontOfSize:17];
    //[self.name setText:self.myVideo.authorName];
    [self.contentView addSubview:self.name];
    //self.followBtn = [[UIButton alloc] initWithFrame:CGRectMake(324, 313, 70, 30)];
    /*self.followBtn = [[UIButton alloc] init];
    self.followBtn.layer.cornerRadius = 5;*/
    /*if(self.myVideo.isFollow == NO) {
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#B54434"];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else {
        self.followBtn.backgroundColor = [UIColor grayColor];
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }*/
    /*[self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.followBtn];*/
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setNumberOfLines:0];
    //[self.titleLabel setText:self.myVideo.title];
    [self.contentView addSubview:self.titleLabel];
    self.moreDetail = [[UILabel alloc] init];
    //self.moreDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 393, 374, 21)];
    self.moreDetail.font = [UIFont systemFontOfSize:17];
    self.moreDetail.textColor = [UIColor grayColor];
    [self.moreDetail setText:@"随便下的视频"];
    [self.moreDetail setNumberOfLines:0];
    [self.contentView addSubview:self.moreDetail];
    self.likeBtn = [[UIButton alloc] init];
    //self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 436, 71, 25)];
    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
    //[self.likeBtn setTitle:@" 1234" forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.likeBtn];
    self.moreBtn = [[UIButton alloc] init];
    //self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(290, 435, 104, 26)];
    [self.moreBtn setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@" 了解更多" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.moreBtn];
    [self.icon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(20);
        make.width.and.height.equalTo(30);
    }];
    [self.name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.right).with.offset(10);
        make.centerY.equalTo(self.icon.centerY);
    }];
    /*[self.followBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-20);
        make.centerY.equalTo(self.icon.centerY);
        make.width.equalTo(70);
        make.height.equalTo(30);
    }];*/
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.icon.bottom).with.offset(15);
        make.width.equalTo(screenBound.size.width-40);
    }];
    [self.moreDetail makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).with.offset(15);
        make.width.equalTo(screenBound.size.width-40);
    }];
    [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.moreDetail.bottom).with.offset(20);
    }];
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-20);
        make.centerY.equalTo(self.likeBtn.centerY);
    }];
    
    [self.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setCellData:(MyVideo*) data {
    //self.myVideo = [data copy];
    self.myVideo = data;
    [self setData];
    [self.icon setBackgroundImage:data.icon forState:UIControlStateNormal];
    [self.name setText:data.authorName];
    /*if(self.myVideo.isFollow == NO) {
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#B54434"];
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else {
        self.followBtn.backgroundColor = [UIColor grayColor];
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }*/
    if(data.isLike) {
        //[self.likeBtn setImage:@"like-fill_25.png" forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
    }
    [self.titleLabel setText:data.title];
    [self.moreDetail setText:data.detail];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", data.likeNum] forState:UIControlStateNormal];
    //[self.likeBtn setTitle:data. forState:<#(UIControlState)#>]
}

- (void) likeBtnClick:(UIButton *)button {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin) {
        [viewModel likeVideoWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLikeGet, int likeNumGet) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isLikeGet) {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                    self.myVideo.likeNum++;
                    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.myVideo.likeNum] forState:UIControlStateNormal];
                }
                else {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                    self.myVideo.likeNum--;
                    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.myVideo.likeNum] forState:UIControlStateNormal];
                }
                
            });
            /*[viewModel getLikeNumWithUid:self.uid vid:self.myVideo.vid success:^(int likeNumGet) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", likeNumGet] forState:UIControlStateNormal];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"请求失败 error:%@",error.description);
            }];*/
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.myVideo.likeNum+1] forState:UIControlStateNormal];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(videoLikeBtnDelegate:)]){
        //[self.startBtn removeFromSuperview];
        [_delegate videoLikeBtnDelegate:self];
    }
}

- (void)videoLikeBarBtnDelegate:(VideoDetailViewController *)controller {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    if(self.isLogin) {
        /*[viewModel getIsLikeWithUid:self.uid vid:self.myVideo.vid success:^(BOOL isLike) {
            self.myVideo.isLike = isLike;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isLike) {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
                }
                else {
                    [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
                }
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];*/
        self.myVideo.isLike = !self.myVideo.isLike;
        if(self.myVideo.isLike) {
            [self.likeBtn setImage:[UIImage imageNamed:@"like-fill_25.png"] forState:UIControlStateNormal];
            self.myVideo.likeNum++;
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.myVideo.likeNum] forState:UIControlStateNormal];
        }
        else {
            [self.likeBtn setImage:[UIImage imageNamed:@"like_25.png"] forState:UIControlStateNormal];
            self.myVideo.likeNum--;
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", self.myVideo.likeNum] forState:UIControlStateNormal];
        }
        /*[viewModel getLikeNumWithUid:self.uid vid:self.myVideo.vid success:^(int likeNumGet) {
            self.myVideo.likeNum = likeNumGet;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", likeNumGet] forState:UIControlStateNormal]; 
            });
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"请求失败 error:%@",error.description);
        }];*/
        
    }
}

- (void)loadNewLikeNum {
    PostViewModel *viewModel = [[PostViewModel alloc] init];
    [viewModel getLikeNumWithUid:self.uid vid:self.myVideo.vid success:^(int likeNumGet) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", likeNumGet] forState:UIControlStateNormal];
            self.myVideo.likeNum = likeNumGet;
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 error:%@",error.description);
    }];
}

@end
