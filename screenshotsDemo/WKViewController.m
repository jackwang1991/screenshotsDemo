//
//  WKViewController.m
//  screenshotsDemo
//
//  Created by wm on 2019/4/17.
//  Copyright © 2019年 wm. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>

@interface WKViewController ()
@property (nonatomic,strong) WKWebView *wkWebView;
@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)createWebView {
    
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
