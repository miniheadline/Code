//
//  EditInfoController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/8.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "EditInfoController.h"
#import "UIColor+Hex.h"
#import "UserInfoModel.h"
#import "UIImageView+WebCache.h"

@interface EditInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString*> *section1;
@property(nonatomic, strong) NSArray<NSString*> *section2;

@property(nonatomic, strong) UserInfoModel *user;

@end

@implementation EditInfoController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕尺寸（包括状态栏）
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
    self.titleLabel.text = @"编辑资料";
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
    
    self.user = [UserInfoModel testUser];
    
    self.section1 = @[@"头像", @"用户名", @"介绍"];
    self.section2 = @[@"性别", @"生日", @"地区"];
    
    int itemHeight = screenBound.size.height/2/(self.section1.count+self.section2.count);
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBound.size.height+50, screenBound.size.width, screenBound.size.height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = itemHeight;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark ------------ UITableViewDataSource ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.section1.count;
        case 1:
            return self.section2.count;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%zd", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        if((indexPath.section == 0&&indexPath.row == 1)||indexPath.section == 1){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        else cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0){
        cell.textLabel.text = self.section1[indexPath.row];
        if(indexPath.row == 0){
            UIImageView *imageView = [[UIImageView alloc] init];
            NSURL *url = [NSURL URLWithString:self.user.pic_url];
            [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"error:%@", error);
            }];
            CGRect cellBound = cell.bounds;
            int extra = 10;
            imageView.frame = CGRectMake(cellBound.size.width - 50, cellBound.origin.y + extra, cellBound.size.height - 2 * extra,cellBound.size.height - 2 * extra);
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            cell.accessoryView = imageView;
        }
        else if(indexPath.row == 1){
            cell.detailTextLabel.text = self.user.username;
        }
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.section2[indexPath.row];
        cell.detailTextLabel.text = @"待完善";
        cell.detailTextLabel.textColor = [UIColor blueColor];
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
