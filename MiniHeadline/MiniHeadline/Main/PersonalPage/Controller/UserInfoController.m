//
//  UserInfoController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "UserInfoController.h"
#import "UIColor+Hex.h"
#import "UserInfoModel.h"
#import "EditInfoController.h"
#import "nextPage_1/InfoTableViewCell.h"
#import "nextPage_1/InfoTableViewCellWithPicture.h"
#import "nextPage_1/NSComment.h"
#import "UIImageView+WebCache.h"

@interface UserInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIImageView *moreImageView;

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSComment*> *items;

@property(nonatomic, strong) UILabel* numOfHeadlineLabel;
@property(nonatomic, strong) UILabel* numOfAttentionLabel;
@property(nonatomic, strong) UILabel* numOfFansLabel;
@property(nonatomic, strong) UILabel* numOfLikeLabel;

@property(nonatomic, strong) UIImageView* photoImageView;
@property(nonatomic, strong) UIButton* editInfoButton;
@property(nonatomic, strong) UILabel* emptyDataLabel;

@property(nonatomic, strong) UserInfoModel* user;

@end

@implementation UserInfoController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationBar
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO; // 取消隐藏navigationBar
    [super viewWillDisappear:animated];
}

- (void)backSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"backSingleTap");
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"searchSingleTap");
}

- (void)moreSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"moreSingleTap");
}

- (void)photoSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"photoSingleTap");
}

- (void)numOfHeadlineSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"numOfHeadlineSingleTap");
}

- (void)numOfAttentionSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"numOfAttentionSingleTap");
}

- (void)numOfFansSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"numOfFansSingleTap");
}

- (void)numOfLikeSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"numOfLikeSingleTap");
}

- (void)editInfoSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"editInfoSingleTap");
    EditInfoController *controller = [[EditInfoController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)tableLoad {
    
    NSString* icon = [[NSString alloc] initWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558155437522&di=d98c8427648c6c4b4a38316d524dc4b2&imgtype=0&src=http%3A%2F%2Fku.90sjimg.com%2Felement_origin_min_pic%2F01%2F37%2F86%2F37573c65819a30c.jpg"];
    
    NSComment* first = [[NSComment alloc] initWithDict:@"本故事纯属虚构，如有雷同，纯属瞎搞，是否继续阅读？" iconUrl:icon username:@"用户1号" picture:@"" share:3 comment:12 like:11];
    NSComment* second = [[NSComment alloc] initWithDict:@"小学每天会发一袋牛奶，他特别希望上学，小学午饭不好吃，所以来出初中吃午饭，后来他对大学的食堂也充满了期待，呵呵呵，毕竟民以食为天。" iconUrl:icon username:@"用户2号" picture:@"" share:4 comment:12 like:11];
    NSComment* thrid = [[NSComment alloc] initWithDict:@"这篇文章的详细信息为..." iconUrl:icon username:@"用户3号" picture:icon share:10 comment:12 like:11];
    
    self.items = [[NSMutableArray alloc] initWithArray:@[first, second, thrid]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕尺寸（包括状态栏）
    
    self.user = [UserInfoModel testUser];
    
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, 50)];
    [self.view addSubview:self.header];
    self.headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.header.frame.size.height - 0.5, screenBound.size.width, 0.5)];
    self.headerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.header addSubview:self.headerLine];
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenBound.size.width - 160) / 2, 10, 160, 30)];
    self.titleLabel.text = self.user.username;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [self.header addSubview:self.titleLabel];
    
    // 返回
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    self.backImageView = [[UIImageView alloc] initWithImage:backImage];
    self.backImageView.frame = CGRectMake(10, 10, 30, 30);
    [self.header addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSingleTap:)];
    [self.backImageView addGestureRecognizer:back];
    
    // 搜索
    UIImage *searchImage = [UIImage imageNamed:@"find.png"];
    self.searchImageView = [[UIImageView alloc] initWithImage:searchImage];
    self.searchImageView.frame = CGRectMake(screenBound.size.width - 90, 10, 30, 30);
    [self.header addSubview:self.searchImageView];
    self.searchImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchSingleTap:)];
    [self.searchImageView addGestureRecognizer:search];
    
    // 更多
    UIImage *moreImage = [UIImage imageNamed:@"more.png"];
    self.moreImageView = [[UIImageView alloc] initWithImage:moreImage];
    self.moreImageView.frame = CGRectMake(screenBound.size.width - 40, 10, 30, 30);
    [self.header addSubview:self.moreImageView];
    self.moreImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *more = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSingleTap:)];
    [self.moreImageView addGestureRecognizer:more];
    
    int width = 0;
    int height = statusBound.size.height + 50;
    int extra = 10;
    
    self.photoImageView = ({
        UIImageView *imageView =  [[UIImageView alloc] init];
        imageView.frame = CGRectMake(width + extra, height, screenBound.size.width/3 - 2*extra, screenBound.size.width/3 - 2*extra);
        NSLog(@"%@",self.user.pic_url);
        NSURL *url = [NSURL URLWithString:self.user.pic_url];
        [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"error:%@", error);
        }];
        
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoSingleTap:)];
        [imageView addGestureRecognizer:gesture];
        imageView;
    });
    [self.view addSubview:self.photoImageView];
    
    width += screenBound.size.width/3;
    self.numOfHeadlineLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width/6, screenBound.size.width/6)];
        UIFont *bigFont = [UIFont systemFontOfSize:16];
        UIFont *smallFont = [UIFont systemFontOfSize:bigFont.pointSize/2];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",self.user.numOfHeadline] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"头条" attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        [attributedString appendAttributedString:number];
        [attributedString appendAttributedString:title];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numOfHeadlineSingleTap:)];
        [label addGestureRecognizer:gesture];
        label;
        
    });
    [self.view addSubview:self.numOfHeadlineLabel];
    
    width += screenBound.size.width/6;
    
    self.numOfAttentionLabel= ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width/6, screenBound.size.width/6)];
        UIFont *bigFont = [UIFont systemFontOfSize:16];
        UIFont *smallFont = [UIFont systemFontOfSize:bigFont.pointSize/2];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",self.user.numOfAttention] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"关注" attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        [attributedString appendAttributedString:number];
        [attributedString appendAttributedString:title];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numOfAttentionSingleTap:)];
        [label addGestureRecognizer:gesture];
        label;
        
    });
    [self.view addSubview:self.numOfAttentionLabel];
    
    width += screenBound.size.width/6;
    
    self.numOfFansLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width/6, screenBound.size.width/6)];
        UIFont *bigFont = [UIFont systemFontOfSize:16];
        UIFont *smallFont = [UIFont systemFontOfSize:bigFont.pointSize/2];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",self.user.numOfFans] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"粉丝" attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        [attributedString appendAttributedString:number];
        [attributedString appendAttributedString:title];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numOfFansSingleTap:)];
        [label addGestureRecognizer:gesture];
        label;
        
    });
    [self.view addSubview:self.numOfFansLabel];
    
    width += screenBound.size.width/6;
    
    self.numOfLikeLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width/6, screenBound.size.width/6)];
        UIFont *bigFont = [UIFont systemFontOfSize:16];
        UIFont *smallFont = [UIFont systemFontOfSize:bigFont.pointSize/2];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",self.user.numOfLike] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"获赞" attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
        [attributedString appendAttributedString:number];
        [attributedString appendAttributedString:title];
        label.attributedText = attributedString;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numOfLikeSingleTap:)];
        [label addGestureRecognizer:gesture];
        label;
        
    });
    [self.view addSubview:self.numOfLikeLabel];
    width = screenBound.size.width/2;
    height += screenBound.size.width/6;
    
    self.editInfoButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width/3, screenBound.size.width/6 - 30)];
        [button setTitle:@"编辑资料" forState:UIControlStateNormal];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 10;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        // 设置边框的宽度
        [button.layer setBorderWidth:1.0];
        // 设置边框的颜色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorRef = CGColorCreate(colorSpace, (CGFloat[]){ 245/255.0, 245/255.0,
            245/255.0, 1 });
        [button.layer setBorderColor:colorRef];
        
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editInfoSingleTap:)];
        [button addGestureRecognizer:gesture];
        
        button;
    });
    [self.view addSubview:self.editInfoButton];
    
    width = 0;
    height += screenBound.size.width/6;
    self.emptyDataLabel = ({
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(width, height, screenBound.size.width, screenBound.size.height - height)];
        label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0];
        label.text = @"TA还没有发布内容哦~";
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    //[self.view addSubview:self.emptyDataLabel];
    
    [self tableLoad];
    
    int itemHeight = 175;
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width, screenBound.size.height - height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = itemHeight;
        tableView;
    });
    
    [self.view addSubview: self.tableView];
}

#pragma mark ------------ UITableViewDataSource ------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSComment* comment = self.items[indexPath.row];
    BOOL cellType = (comment.pictureUrl.length < 1); //为空代表无插图；
    
    if (cellType) {
        NSLog(@"No picture cell.");
        
        static NSString *identifier = @"MyCell";
        BOOL nibsRegistered = NO;
        
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([InfoTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            nibsRegistered = YES;
        }
        
        InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        NSData *urlAddress1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:comment.iconUrl]];
        UIImage* image1 = [UIImage imageWithData:urlAddress1];
        
        [cell.username setTitle:comment.name forState:UIControlStateNormal];
        [cell.label1 setText: [NSString stringWithFormat:@"%d", comment.shareNums]];
        [cell.label2 setText: [NSString stringWithFormat:@"%d", comment.commentNums]];
        [cell.label3 setText: [NSString stringWithFormat:@"%d", comment.likeNums]];
        [cell.text setText:comment.text];
        [cell.person setImage:image1];
        
        return cell;
    }
    else {
        
        static NSString *identifier = @"MyCellWithPIcture";
        BOOL nibsRegistered = NO;
        
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([InfoTableViewCellWithPicture class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            nibsRegistered = YES;
        }
        
        InfoTableViewCellWithPicture *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        NSData *urlAddress1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:comment.iconUrl]];
        NSData *urlAddress2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:comment.pictureUrl]];
        UIImage* image1 = [UIImage imageWithData:urlAddress1];
        UIImage* image2 = [UIImage imageWithData:urlAddress2];
        
        [cell.username setTitle:comment.name forState:UIControlStateNormal];
        [cell.shareNums setText: [NSString stringWithFormat:@"%d", comment.shareNums]];
        [cell.commentNums setText: [NSString stringWithFormat:@"%d", comment.commentNums]];
        [cell.likeNums setText: [NSString stringWithFormat:@"%d", comment.likeNums]];
        [cell.text setText:comment.text];
        [cell.person setImage:image1];
        [cell.picture setImage:image2];
        
        return cell;
    }
    
}

#pragma mark ------------ UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

