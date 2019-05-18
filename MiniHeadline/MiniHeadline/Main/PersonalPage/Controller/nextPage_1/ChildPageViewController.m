//
//  ChildPageViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/1.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ChildPageViewController.h"
#import "InfoTableViewCell.h"
#import "InfoTableViewCellWithPicture.h"
#import "NSComment.h"

@interface ChildPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)IBOutlet UIButton *bt1;
@property (nonatomic, retain)IBOutlet UIButton *bt2;
@property (nonatomic, retain)IBOutlet UIButton *bt3;
@property (nonatomic, retain)IBOutlet UIButton *bt4;
@property (nonatomic, retain)IBOutlet UIButton *bt5;

@property (nonatomic, retain)IBOutlet UIButton *editor;
@property (nonatomic, retain)IBOutlet UIButton *search;

@property (nonatomic, strong) UITableView *tableView;

@property int select;
@property (nonatomic, strong) NSMutableArray<NSComment*> *items;
@property (nonatomic, strong) NSMutableArray<NSComment*> *itemsOfbt1;
@property (nonatomic, strong) NSMutableArray<NSComment*> *itemsOfbt2;
@property (nonatomic, strong) NSMutableArray<NSComment*> *itemsOfbt3;
@property (nonatomic, strong) NSMutableArray<NSComment*> *itemsOfbt4;
@property (nonatomic, strong) NSMutableArray<NSComment*> *itemsOfbt5;

@end


@implementation ChildPageViewController

- (void)MarkButtonClick {
    
    NSLog(@"click markbutton");
    
    self.items = self.itemsOfbt1;
    self.select = 1;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)CommentButtonClick {
    
    NSLog(@"click comment button");
    
    self.items = self.itemsOfbt2;
    self.select = 2;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)LikeButtonClick {
    
    NSLog(@"click like button");
    
    self.items = self.itemsOfbt3;
    self.select = 3;
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



- (void)HistoryButtonClick {
    
    NSLog(@"click history button");
    
    self.items = self.itemsOfbt4;
    self.select = 4;
    
    
    [self.tableView  reloadData];
    [self.bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bt4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bt5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)tableLoad {
    
    NSString* icon = [[NSString alloc] initWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558155437522&di=d98c8427648c6c4b4a38316d524dc4b2&imgtype=0&src=http%3A%2F%2Fku.90sjimg.com%2Felement_origin_min_pic%2F01%2F37%2F86%2F37573c65819a30c.jpg"];
    
    NSComment* first = [[NSComment alloc] initWithDict:@"这篇文章的详细信息为..." iconUrl:icon username:@"用户1号" picture:@"" share:3 comment:12 like:11];
    NSComment* second = [[NSComment alloc] initWithDict:@"这篇文章的详细信息为..." iconUrl:icon username:@"用户2号" picture:@"" share:4 comment:12 like:11];
    NSComment* thrid = [[NSComment alloc] initWithDict:@"这篇文章的详细信息为..." iconUrl:icon username:@"用户3号" picture:icon share:10 comment:12 like:11];
    
    self.itemsOfbt1 = [[NSMutableArray alloc] initWithArray:@[first, second, thrid]];
    self.itemsOfbt2 = [[NSMutableArray alloc] initWithArray:@[first]];
    self.itemsOfbt3 = [[NSMutableArray alloc] initWithArray:@[second]];
    self.itemsOfbt4 = [[NSMutableArray alloc] initWithArray:@[thrid]];
    self.itemsOfbt5 = [[NSMutableArray alloc] initWithArray:@[second, thrid]];
    
}


- (void)viewDidLoad {
    
    
    [self tableLoad];

    self.items = self.itemsOfbt1;
    self.select = 1;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.tableView registerNib:[UINib nibWithNibName:@"TableCellView" //bundle:nil] forCellReuseIdentifier:@"TableCellView"];
    
    CGRect mainscreenBound =  [UIScreen mainScreen].bounds;
    CGRect statusBarBound = [[UIApplication sharedApplication] statusBarFrame];
    CGRect screenBound = CGRectMake(0, 0, mainscreenBound.size.width, mainscreenBound.size.height-statusBarBound.size.height-50);
    
    int width = 0;
    int height = screenBound.size.height/4;
    
    int itemHeight = 175;
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
    
    [self.editor addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    
    NSComment* comment = self.items[indexPath.row];
    BOOL cellType = [comment.pictureUrl isEqualToString:@""]; //为空代表无插图；
    
    if (!cellType) {
        
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
        [cell.picture setImage:image1];
        
        return cell;
    }
    
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
            
            case 3:
                [self.itemsOfbt3 removeObjectAtIndex:indexPath.row];
                break;
                
            case 4:
                [self.itemsOfbt4 removeObjectAtIndex:indexPath.row];
                break;
                
            case 5:
                [self.itemsOfbt5 removeObjectAtIndex:indexPath.row];
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
