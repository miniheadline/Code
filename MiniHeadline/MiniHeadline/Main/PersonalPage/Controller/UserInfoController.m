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

@interface UserInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIImageView *moreImageView;

@property(nonatomic, strong) UITableView *publishTableView;
@property (nonatomic, copy) NSMutableArray *tableDataArray;

@property(nonatomic, strong) UILabel* numOfHeadlineLabel;
@property(nonatomic, strong) UILabel* numOfAttentionLabel;
@property(nonatomic, strong) UILabel* numOfFansLabel;
@property(nonatomic, strong) UILabel* numOfLikeLabel;

@property(nonatomic, strong) UIImageView* photoImageView;
@property(nonatomic, strong) UIButton* editInfoButton;
@property(nonatomic, strong) UILabel* emptyDataLabel;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕尺寸（包括状态栏）
    
    UserInfoModel *myUser = [UserInfoModel testUser];
    
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
    self.titleLabel.text = myUser.username;
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
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:myUser.photo];
        imageView.frame = CGRectMake(width + extra, height, screenBound.size.width/3 - 2*extra, screenBound.size.width/3 - 2*extra);
        
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
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",myUser.numOfHeadline] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
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
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",myUser.numOfAttention] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
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
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",myUser.numOfFans] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
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
        NSAttributedString *number = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n",myUser.numOfLike] attributes:@{NSFontAttributeName:bigFont,NSForegroundColorAttributeName:[UIColor blackColor],NSBaselineOffsetAttributeName:@(0)}];
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
    [self.view addSubview:self.emptyDataLabel];
}

#pragma mark ------------ UITableViewDataSource ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%zd", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        if((indexPath.section == 0&&(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5))||(indexPath.section == 3&&indexPath.row==1)){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        else cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
