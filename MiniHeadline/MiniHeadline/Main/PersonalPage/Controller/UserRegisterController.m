//
//  UserRegisterController.m
//  MiniHeadline
//
//  Created by Vicent Zhang on 2019/6/14.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "UserRegisterController.h"
#import "UserInfoModel.h"
#import "Toast.h"
#import "UIColor+Hex.h"

@interface UserRegisterController ()

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *headlineImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *smallHintLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirm;
@property (nonatomic, copy) NSString *error_code;

@end

@implementation UserRegisterController

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
    
    //UserInfoModel *myUser = [UserInfoModel testUser];
    if([self.username isEqualToString:@""]||[self.password isEqualToString:@""]||[self.confirm isEqualToString:@""]){
        [[[Toast alloc] init] popUpToastWithMessage:@"输入框不能为空"];
    }
    else if(![self.password isEqualToString:self.confirm]){
        [[[Toast alloc] init] popUpToastWithMessage:@"两次密码输入不一致"];
    }
    else{
        [self sendrRegisterPost];
    }
}

- (void) sendrRegisterPost{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://149.28.26.98:8082/miniheadline/Login"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *param = [NSString stringWithFormat:@"{\"post_type\":1, \"username\":\"%@\", \"password\":\"%@\"}",self.username,self.password];
    NSLog(@"%@",param);
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil){
            self.error_code = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",self.error_code);
            if([self.error_code isEqualToString:@"{\"error_code\":1}"]){
                [[[Toast alloc] init] popUpToastWithMessage:@"用户名已存在"];
            }
            else if([self.error_code isEqualToString:@"{\"error_code\":0}"]){
                [[[Toast alloc] init] popUpToastWithMessage:@"注册成功"];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }];
    [dataTask resume];
    
}

- (void) usernameTextFieldChange:(UITextField*) sender {
    self.username = sender.text;
}

- (void) passwordTextFieldChange:(UITextField*) sender {
    self.password = sender.text;
}

- (void) confirmTextFieldChange:(UITextField *)sender{
    self.confirm = sender.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取屏幕尺寸（包括状态栏）
    
    
    self.username = @"";
    self.password = @"";
    self.confirm = @"";
    self.error_code = @"";
    
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
    
    double scale = screenBound.size.width/414;
    
    self.headlineImageView = ({
        UIImage *headlineImage = [UIImage imageNamed:@"logo.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:headlineImage];
        imageView.frame = CGRectMake(scale*50, scale*100, scale*80, scale*80);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 10.0;
        imageView;
    });
    [self.view addSubview:self.headlineImageView];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scale*150, scale*100, screenBound.size.width - scale*150, scale*80)];
        label.text = @"账号注册";
        UIFont *bigFont = [UIFont systemFontOfSize:scale*32];
        label.font = bigFont;
        label;
    });
    [self.view addSubview:self.titleLabel];
    
    self.smallHintLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scale*50, scale*200, screenBound.size.width - scale*50, scale*20)];
        label.text = @"注册表示同意“用户协议”和“隐私政策”";
        UIFont *smallFont = [UIFont systemFontOfSize:12];
        label.font = smallFont;
        label;
    });
    [self.view addSubview:self.smallHintLabel];
    
    self.usernameTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(scale*50, scale*250, screenBound.size.width - scale*50, scale*100)];
        textField.placeholder = @"用户名";
        textField.keyboardType = UIKeyboardTypeDefault;
        UIFont *bigFont = [UIFont systemFontOfSize:scale*28];
        textField.font = bigFont;
        [textField addTarget:self action:@selector(usernameTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });
    [self.view addSubview:self.usernameTextField];
    
    UILabel *grayline1 = ({
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(scale*50, scale*328, screenBound.size.width - scale*100, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        line;
    });
    [self.view addSubview:grayline1];
    
    self.passwordTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(scale*50, scale*350, screenBound.size.width - scale*50, scale*100)];
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
        UIFont *bigFont = [UIFont systemFontOfSize:scale*28];
        textField.font = bigFont;
        [textField addTarget:self action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });
    [self.view addSubview:self.passwordTextField];
    UILabel *grayline2 = ({
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(scale*50, scale*428, screenBound.size.width - scale*100, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        line;
    });
    [self.view addSubview:grayline2];
    
    self.confirmTextField = ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(scale*50, scale*450, screenBound.size.width - scale*50, scale*100)];
        textField.placeholder = @"确认密码";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeDefault;
        UIFont *bigFont = [UIFont systemFontOfSize:scale*28];
        textField.font = bigFont;
        [textField addTarget:self action:@selector(confirmTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });
    [self.view addSubview:self.confirmTextField];
    UILabel *grayline3 = ({
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(scale*50, scale*528, screenBound.size.width - scale*100, 2)];
        line.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        line;
    });
    [self.view addSubview:grayline3];
    
    self.confirmButton = ({
        UIImage *image = [UIImage imageNamed:@"jiantou.png"];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(screenBound.size.width/2-scale*40, scale*600, scale*80, scale*80)];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.width/2;
        [button setImage:image forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
        [button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.confirmButton];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
}

@end
