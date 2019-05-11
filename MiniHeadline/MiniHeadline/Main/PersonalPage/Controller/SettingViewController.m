//
//  SettingViewController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/4/26.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "SettingViewController.h"
#import "UIColor+Hex.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *backImageView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString*> *section1;
@property(nonatomic, strong) NSArray<NSString*> *section2;
@property(nonatomic, strong) NSArray<NSString*> *section3;
@property(nonatomic, strong) NSArray<NSString*> *section4;

@end

@implementation SettingViewController

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
    self.titleLabel.text = @"设置";
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
    
    self.section1 = @[@"夜间模式", @"清除缓存", @"字体大小", @"列表显示摘要", @"非WiFi网络流量", @"非WiFi网络播放提示", @"推送通知", @"提示音开关", @"通知栏搜索设置", @"点击返回键获取新资讯", @"H5广告过滤"];
    self.section2 = @[@"允许给我推荐可能认识的人"];
    self.section3 = @[@"广告设置"];
    self.section4 = @[@"小头条封面", @"检查版本", @"关于小头条"];
    
    int itemHeight = screenBound.size.height*1.5/(self.section1.count+self.section2.count+self.section3.count+self.section4.count);
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBound.size.height+50, screenBound.size.width, screenBound.size.height-100) style:UITableViewStyleGrouped];
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
        case 2:
            return self.section3.count;
        case 3:
            return self.section4.count;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;//section头部高度
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 1){
        return @"隐私设置";
    }
    else{
        return @" ";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
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
    if(indexPath.section == 0){
        cell.textLabel.text = self.section1[indexPath.row];
        if(indexPath.row == 1){
            cell.detailTextLabel.text = @"0B";
        }
        else if(indexPath.row == 2){
            cell.detailTextLabel.text = @"中";
        }
        else if(indexPath.row == 4){
            cell.detailTextLabel.text = @"最佳效果(下载大图)";
        }
        else if(indexPath.row == 5){
            cell.detailTextLabel.text = @"提醒一次";
        }
        else {
            cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
        }
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = self.section2[indexPath.row];
        cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    else if(indexPath.section == 2){
        cell.textLabel.text = self.section3[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 3){
        cell.textLabel.text = self.section4[indexPath.row];
        if(indexPath.row == 1){
            cell.detailTextLabel.text = @"1.0.0";
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
