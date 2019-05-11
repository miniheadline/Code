//
//  ChildPageViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/1.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ChildPageViewController.h"
#import "InfoTableViewCell.h"

@interface ChildPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)IBOutlet UIButton *bt1;
@property (nonatomic, retain)IBOutlet UIButton *bt2;
@property (nonatomic, retain)IBOutlet UIButton *bt3;
@property (nonatomic, retain)IBOutlet UIButton *bt4;
@property (nonatomic, retain)IBOutlet UIButton *bt5;

@property (nonatomic, retain)IBOutlet UIButton *editor;
@property (nonatomic, retain)IBOutlet UIButton *search;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString*> *items;

@end


@implementation ChildPageViewController

- (void)MarkButtonClick {
    
    NSLog(@"click markbutton");
    
    self.items = @[@"我的关注", @"消息通知", @"扫一扫"];
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)CommentButtonClick {
    
    NSLog(@"click comment button");
    
    self.items = @[@"我的关注", @"消息通知"];
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)LikeButtonClick {
    
    NSLog(@"click like button");
    
    self.items = @[@"我的关注", @"消息通知", @"扫一扫", @"消息通知", @"扫一扫"];
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)HistoryButtonClick {
    
    NSLog(@"click history button");
    
    self.items = @[@"我的关注", @"消息通知", @"扫一扫", @"消息通知", @"扫一扫"];
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.tableView registerNib:[UINib nibWithNibName:@"TableCellView" //bundle:nil] forCellReuseIdentifier:@"TableCellView"];
    
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    
    int width = 0;
    int height = screenBound.size.height/4;
    self.items = @[@"我的关注", @"消息通知", @"扫一扫", @"用户反馈", @"系统设置"];
    
    int itemHeight = 165;
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(width, height, screenBound.size.width, screenBound.size.height*0.75) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = itemHeight;
        tableView;
    });
    
    [self.view addSubview: self.tableView];
    
    [self.bt1 addTarget:self action:@selector(MarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt2 addTarget:self action:@selector(CommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt3 addTarget:self action:@selector(LikeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bt4 addTarget:self action:@selector(HistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)SelectPage:(int) select {
    
    switch (select) {
        case 1:
            NSLog(@"1");
            [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 2:
            NSLog(@"2");
            [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 3:
            NSLog(@"3");
            [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 4:
            NSLog(@"4");
            [self.bt4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
    }
    
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
    
    /*NSString *cellID = [NSString stringWithFormat:@"commentCell:%zd", indexPath.section];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    InfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 250);
    */
    static NSString *identifier = @"MyCell";
    BOOL nibsRegistered = NO;
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([InfoTableViewCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegistered = YES;
    }
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}

#pragma mark ------------ UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
