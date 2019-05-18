//
//  AddFreindPageViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/16.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "AddFreindPageViewController.h"
#import "PersonInfoCell.h"
#import "NSPerson.h"

@interface AddFreindPageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)IBOutlet UITextField *textField;
@property (nonatomic, retain)IBOutlet UIButton *btn;

@property (nonatomic, strong) NSMutableArray<NSPerson*> *items;
@property (nonatomic, retain)IBOutlet UITableView* tableView;

@end

@implementation AddFreindPageViewController

- (void)tableLoad {
    
    NSPerson* person1 = [[NSPerson alloc] initWithDict:@"用户1号" introduction:@"中山大学本科生" Fans:@"125" picture:@""];
    NSPerson* person2 = [[NSPerson alloc] initWithDict:@"用户2号" introduction:@"中山大学本科生" Fans:@"1287" picture:@""];
    NSPerson* person3 = [[NSPerson alloc] initWithDict:@"用户3号" introduction:@"中山大学本科生" Fans:@"45" picture:@""];
    
    self.items = [[NSMutableArray alloc] initWithArray:@[person1, person2, person3]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self tableLoad];
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

