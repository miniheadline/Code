//
//  PersonalPageViewController.m
//  MiniHeadline
//
//  Created by Booooby on 2019/4/20.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "UIButton+ImageTitleStyle.h"
#import "SettingViewController.h"

@interface PersonalPageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString*> *items;
@property(nonatomic, strong) UIButton* likeButton;
@property(nonatomic, strong) UIButton* commentButton;
@property(nonatomic, strong) UIButton* historyButton;
@property(nonatomic, strong) UIButton* markButton;
@property(nonatomic, strong) UIButton* loginButton;

- (void)LoginButtonClick;
- (void)MarkButtonClick;
- (void)LikeButtonClick;
- (void)CommentButtonClick;
- (void)HistoryButtonClick;

@end

@implementation PersonalPageViewController

- (void)LoginButtonClick {
    
}

- (void)MarkButtonClick {


}
- (void)LikeButtonClick {
    
}
- (void)CommentButtonClick {
    
}
- (void)HistoryButtonClick {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    
    int extra = 30;
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screenBound.size.width/4+extra, screenBound.size.width/4, screenBound.size.width/2-2*extra, screenBound.size.width/2-2*extra);
        [button setBackgroundColor:[UIColor redColor]];
        // 圆形按钮
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.width/2;
        [button setTitle:@"登 录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:32];
        [button addTarget:self action:@selector(LoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    //收藏，点赞，评论，历史按钮
    
    int width = 0;
    int height = screenBound.size.height/2 - screenBound.size.width/4;
    
    self.markButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width, height, screenBound.size.width/4, screenBound.size.width/4);
        [button setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 默认标题
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
        NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"我的收藏" attributes:attributes];
        [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
        [button verticalCenterImageAndTitle:5.0f];
        [button addTarget:self action:@selector(MarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    width += screenBound.size.width/4;
    
    self.likeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width, height, screenBound.size.width/4, screenBound.size.width/4);
        [button setImage:[UIImage imageNamed:@"dianzan.png" ] forState:UIControlStateNormal];
        // 默认标题
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
        NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"我的点赞" attributes:attributes];
        [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
        [button verticalCenterImageAndTitle:5.0f];
        [button addTarget:self action:@selector(LikeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    width += screenBound.size.width/4;
    
    self.commentButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width, height, screenBound.size.width/4, screenBound.size.width/4);
        [button setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        // 默认标题
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
        NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"我的评论" attributes:attributes];
        [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
        [button verticalCenterImageAndTitle:5.0f];
        [button addTarget:self action:@selector(CommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    width += screenBound.size.width/4;
    
    self.historyButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width, height, screenBound.size.width/4, screenBound.size.width/4);
        [button setImage:[UIImage imageNamed:@"lishixiao.png"] forState:UIControlStateNormal];
        // 默认标题
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
        NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"浏览历史" attributes:attributes];
        [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
        [button verticalCenterImageAndTitle:5.0f];
        [button addTarget:self action:@selector(HistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.items = @[@"我的关注", @"消息通知", @"扫一扫", @"用户反馈", @"系统设置"];
    int itemHeight = screenBound.size.height/2/self.items.count;
    self.tableView = ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenBound.size.height/2, screenBound.size.width, screenBound.size.height/2) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = itemHeight;
        tableView;
    });
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.markButton];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.commentButton];
    [self.view addSubview:self.historyButton];
    [self.view addSubview:self.loginButton];
    
}

#pragma mark ------------ UITableViewDataSource ------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
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

#pragma mark ------------ UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.items[indexPath.row] isEqual:@"系统设置"]) {
        SettingViewController *controller = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
