//
//  RootViewController.m
//  screenshotsDemo
//
//  Created by wm on 2019/4/17.
//  Copyright © 2019年 wm. All rights reserved.
//

#import "RootViewController.h"
#import "WKViewController.h"

@interface RootViewController ()
@property (nonatomic,strong) UIButton *wkBtn;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
////    NSDictionary *dic = @{@"title":@"test",
////                          @"autoResetToDefaultConfigWhtenOpenLink":@"true",
////                          @"tintColorType":@"1",
////                          @"backButtonType":@"1",
////                          @"autoTopPadding":@"1",
////                          @"barLineHidden":@"0",@"topPadding":@"1",
////                        @"color":@{@"red":@"255",@"green":@"255",@"blue":@"255",@"alpha":@"0"}};
//    NSDictionary *dic = @{
//    @"viewType":@"showSportHeartSetting",
//    @"data":@{},
//    @"shouldCloseWebViewControllerAfterPush":@"isCloseView"
//    };
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 50)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"WKWebView截图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickBtn:(UIButton *)event {
    WKViewController *wkVC = [[WKViewController alloc] init];
    [self.navigationController pushViewController:wkVC animated:YES];
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
