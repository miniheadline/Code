//
//  ChildPage2ViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/2.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ChildPage2ViewController.h"
#import "PersonInfoCell.h"
#import "AddFreindPageViewController.h"
#import "NSPerson.h"

@interface ChildPage2ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)IBOutlet UIButton *attention;
@property (nonatomic, retain)IBOutlet UIButton *fans;
@property (nonatomic, retain)IBOutlet UIButton *addFriendIcon;
@property (nonatomic, retain)IBOutlet UIButton *addFriend;
@property (nonatomic, retain)IBOutlet UITextField *no_fans_data;

@property (nonatomic, retain)IBOutlet UIImageView *backImageView;

@property int select;
@property (nonatomic, strong) NSMutableArray<NSString*> *items;
@property (nonatomic, strong) NSMutableArray<NSString*> *itemsOfbt1;
@property (nonatomic, strong) NSMutableArray<NSString*> *itemsOfbt2;
@property (nonatomic, retain)IBOutlet UITableView* tableView;


@end

@implementation ChildPage2ViewController

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



- (void)AttentionClick {
    
    NSLog(@"attention markbutton");
    
    [self.attention setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.fans setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.items = self.itemsOfbt1;
    self.select = 1;
    self.tableView.hidden = FALSE;
    
    if ( self.itemsOfbt1.count == 0 ) {
        self.tableView.hidden = TRUE;
        self.no_fans_data.hidden = FALSE;
        self.addFriend.hidden = FALSE;
        
        [self.no_fans_data setText:@"暂无关注数据"];
    }
    else {
        self.tableView.hidden = FALSE;
        self.no_fans_data.hidden = TRUE;
        self.addFriend.hidden = TRUE;
        
    }

}

- (void)FansClick {
    
    NSLog(@"fans markbutton");
    
    [self.fans setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.attention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.items = self.itemsOfbt2;
    self.select = 2;
    self.tableView.hidden = FALSE;
    
    if ( self.itemsOfbt2.count == 0 ) {
        self.tableView.hidden = TRUE;
        self.no_fans_data.hidden = FALSE;
        self.addFriend.hidden = FALSE;
        
        [self.no_fans_data setText:@"暂无粉丝数据"];
    }
    else {
        self.tableView.hidden = FALSE;
        self.no_fans_data.hidden = TRUE;
        self.addFriend.hidden = TRUE;
        
    }
    
}

- (void)AddFriendClick {
    
    NSLog(@"add friend markbutton");
    
    AddFreindPageViewController *controller = [[AddFreindPageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
    
}

- (void)tableLoad {
    
    NSPerson* person1 = [[NSPerson alloc] initWithDict:@"儿科医生鲍秀兰" introduction:@"知名医师" Fans:@"12万粉丝" picture:@""];
    NSPerson* person2 = [[NSPerson alloc] initWithDict:@"家常菜日记" introduction:@"优秀美食领域创作者" Fans:@"93万粉丝" picture:@""];
    NSPerson* person3 = [[NSPerson alloc] initWithDict:@"金莎" introduction:@"歌手 演员" Fans:@"61万粉丝" picture:@""];
    
    self.itemsOfbt1 = [[NSMutableArray alloc] initWithArray:@[person1, person2, person3]];
    self.itemsOfbt1 = [[NSMutableArray alloc] initWithArray:@[person1, person3]];
    
    self.items = self.itemsOfbt2;
    self.select = 2;
    
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    
    int width = 0;
    int height = screenBound.size.height/4;
    
    int itemHeight = 165;
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width, screenBound.size.height*0.75) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = itemHeight;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.attention addTarget:self action:@selector(AttentionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.fans addTarget:self action:@selector(FansClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addFriend addTarget:self action:@selector(AddFriendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addFriendIcon addTarget:self action:@selector(AddFriendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self tableLoad];
    
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSingleTap:)];
    [self.backImageView addGestureRecognizer:back];
    
    [self viewWillAppear:FALSE];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ------------ UITableViewDataSource ------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PersonInfoCell";
    BOOL nibsRegistered = NO;
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([PersonInfoCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegistered = YES;
    }
    
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSPerson* person = self.items[indexPath.row];
    [cell.label1 setText: person.name];
    [cell.label2 setText: person.introduction];
    [cell.label3 setText: person.FansNum];
    
    UIImage* image;
    if ([person.iconUrl isEqualToString:@""]) {
        person.iconUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558161078896&di=3028f36748f99727fb60e9300406f29f&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01786557e4a6fa0000018c1bf080ca.png";
    }
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: person.iconUrl]];
    image = [UIImage imageWithData:data];
    
    [cell.image setImage:image];
    
    return cell;
}

#pragma mark ------------ UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.tableView.editing = YES;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //        [self.tableView reloadData];
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        // 退出编辑模式
        self.tableView.editing = NO;
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        switch(self.select) {
            case 1:
                [self.itemsOfbt1 removeObjectAtIndex:indexPath.row];
                break;
                
            case 2:
                [self.itemsOfbt2 removeObjectAtIndex:indexPath.row];
                break;
        }
        
    }];
    return @[action1,action];
}

#pragma mark - 按钮的点击
- (IBAction)remove {
    // 进入编辑模式
    //    self.tableView.editing = !self.tableView.isEditing;
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}


@end
