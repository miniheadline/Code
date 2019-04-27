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
@property(nonatomic, strong) NSArray<NSString*> *items;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    self.items = @[@"夜间模式", @"清除缓存", @"列表显示摘要", @"非WiFi网络流量", @"非WiFi网络播放提示", @"推送通知", @"提示音开关", @"通知栏搜索设置", @"点击返回键获取新资讯", @"H5广告过滤", @"允许给我推荐可能认识的人", @"广告设置", @"检查版本", @"关于小头条"];
    int itemHeight = screenBound.size.height*2/self.items.count;
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBound.size.width, screenBound.size.height*2) style:UITableViewStyleGrouped];
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
            return 11;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 1){
        return @"隐私设置";
    }
    else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%zd", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.items[indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
