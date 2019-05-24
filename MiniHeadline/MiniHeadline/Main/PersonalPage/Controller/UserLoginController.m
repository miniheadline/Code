//
//  UserLoginController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/5/15.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "UserLoginController.h"
#import "UIColor+Hex.h"
#import "UserInfoModel.h"

@interface UserLoginController ()

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *headlineImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *smallHintLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end

@implementation UserLoginController

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


- (void)confirmClick{
    NSLog(@"Confirm Click");
    
    
}

- (void) usernameTextFieldChange:(UITextField*) sender {
    self.username = sender.text;
}

- (void) passwordTextFieldChange:(UITextField*) sender {
    self.password = sender.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕尺寸（包括状态栏）
    
    UserInfoModel *myUser = [UserInfoModel testUser];
    self.username = @"";
    self.password = @"";
    
    
    CGRect screenBound = [UIScreen mainScreen].bounds;
    // 获取状态栏尺寸
    CGRect statusBound = [[UIApplication sharedApplication] statusBarFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, statusBound.size.height, screenBound.size.width, 50)];
    [self.view addSubview:self.header];
    self.headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.header.frame.size.height - 0.5, screenBound.size.width, 0.5)];
    self.headerLine.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [self.header addSubview:self.headerLine];
    
    // 返回
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    self.backImageView = [[UIImageView alloc] initWithImage:backImage];
    self.backImageView.frame = CGRectMake(10, 10, 30, 30);
    [self.header addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *back = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSingleTap:)];
    [self.backImageView addGestureRecognizer:back];
    
    
    self.headlineImageView = ({
        UIImage *headlineImage = [UIImage imageNamed:@"logo.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:headlineImage];
        imageView.frame = CGRectMake(50, 100, 80, 80);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 10.0;
        imageView;
    });
    [self.view addSubview:self.headlineImageView];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, screenBound.size.width - 150, 80)];
        label.text = @"账号登录";
        UIFont *bigFont = [UIFont systemFontOfSize:32];
        label.font = bigFont;
        label;
    });
    [self.view addSubview:self.titleLabel];
    
    self.smallHintLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, screenBound.size.width - 50, 20)];
        label.text = @"登录表示同意“用户协议”和“隐私政策”";
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        label.font = smallFont;
        label;
    });
    [self.view addSubview:self.smallHintLabel];
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 250, screenBound.size.width - 50, 100)];
        textField.placeholder = @"用户名";
        textField.keyboardType = UIKeyboardTypeDefault;
        UIFont *bigFont = [UIFont systemFontOfSize:28];
        textField.font = bigFont;
        [textField addTarget:self action:@selector(usernameTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField;
        
    });
    [self.view addSubview:self.usernameTextField];
    
    UILabel *grayline1 = ({
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, 328, screenBound.size.width - 100, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        line;
    });
    [self.view addSubview:grayline1];
    
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 350, screenBound.size.width - 50, 100)];
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
        UIFont *bigFont = [UIFont systemFontOfSize:28];
        textField.font = bigFont;
        [textField addTarget:self action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });
    [self.view addSubview:self.passwordTextField];
    UILabel *grayline2 = ({
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, 428, screenBound.size.width - 100, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        line;
    });
    [self.view addSubview:grayline2];
    
    self.confirmButton = ({
        UIImage *image = [UIImage imageNamed:@"jiantou.png"];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(screenBound.size.width/2-40, 500, 80, 80)];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.width/2;
        [button setImage:image forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
        [button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.confirmButton];
}
@end
