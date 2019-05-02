//
//  SettingViewController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/4/26.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString*> *section1;
@property(nonatomic, strong) NSArray<NSString*> *section2;
@property(nonatomic, strong) NSArray<NSString*> *section3;
@property(nonatomic, strong) NSArray<NSString*> *section4;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    self.section1 = @[@"夜间模式", @"清除缓存", @"字体大小", @"列表显示摘要", @"非WiFi网络流量", @"非WiFi网络播放提示", @"推送通知", @"提示音开关", @"通知栏搜索设置", @"点击返回键获取新资讯", @"H5广告过滤"];
    self.section2 = @[@"允许给我推荐可能认识的人"];
    self.section3 = @[@"广告设置"];
    self.section4 = @[@"小头条封面", @"检查版本", @"关于小头条"];
    
    int itemHeight = screenBound.size.height*1.5/(self.section1.count+self.section2.count+self.section3.count+self.section4.count);
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height) style:UITableViewStyleGrouped];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 1:
            return @"隐私设置";
            
        default:
            return @"";
    }
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
