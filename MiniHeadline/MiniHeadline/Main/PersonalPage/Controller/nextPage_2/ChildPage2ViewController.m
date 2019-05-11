//
//  ChildPage2ViewController.m
//  MiniHeadline
//
//  Created by 蔡倓 on 2019/5/2.
//  Copyright © 2019 Booooby. All rights reserved.
//

#import "ChildPage2ViewController.h"

@interface ChildPage2ViewController ()

@end

@implementation ChildPage2ViewController

- (void)AttentionClick {
    
    NSLog(@"attention markbutton");
    
    [self.attention setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.fans setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

- (void)FansClick {
    
    NSLog(@"fans markbutton");
    
    [self.fans setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.attention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     [self.attention addTarget:self action:@selector(AttentionClick) forControlEvents:UIControlEventTouchUpInside];
     [self.fans addTarget:self action:@selector(FansClick) forControlEvents:UIControlEventTouchUpInside];
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
