//
//  WKViewController.m
//  screenshotsDemo
//
//  Created by wm on 2019/4/17.
//  Copyright © 2019年 wm. All rights reserved.
//

#import "WKViewController.h"
#import <WebKit/WebKit.h>
#import "WXApi.h"
#import "LSScreenshotsHandler.h"

@interface WKViewController ()<WKNavigationDelegate,LSScreenshotsDelegate>
@property (nonatomic,strong) WKWebView *wkWebView;
@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtn)];
    [self createWebView];
    _wkWebView.navigationDelegate = self;
}

- (void)createWebView {
    CGFloat h_y = [self getTop];
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, h_y, self.view.frame.size.width, self.view.frame.size.height-h_y)];
    [self.view addSubview:_wkWebView];
    NSURL *url = [NSURL URLWithString:@"https://leetcode-cn.com/"];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - event
- (void)shareBtn {
    NSLog(@"分享");
    LSScreenshotsHandler.defaultHandler.delegate = self;
    [LSScreenshotsHandler.defaultHandler screensShotsForView:self.wkWebView];
    
}

- (void)screenshotHandler:(LSScreenshotsHandler *)screenshotHandler didFinish:(UIImage *)captureImage forView:(UIView *)view {
    LSScreenshotsHandler.defaultHandler.delegate = nil;
    
    NSData *imageData = UIImageJPEGRepresentation(captureImage, 0.7);
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];

}

#pragma mark - UIWebViewDelegate

/*! @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"----1");
    NSLog(@"----是否允许这个导航");
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"----2");
    NSLog(@"----知道返回内容之后，是否允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"----3");
    NSLog(@"----开始加载");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"----4");
    NSLog(@"----跳转到其他的服务器");
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"----5");
    NSLog(@"----加载失败");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"----6");
    NSLog(@"----网页开始接收网页内容");
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"----7");
    NSLog(@"----网页导航加载完毕");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"----8");
    NSLog(@"----加载失败,失败原因:%@",[error description]);
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSLog(@"----9");
//    NSLog(@"----此方法当web视图需要响应身份验证挑战时进行调用");
//}

/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    NSLog(@"----10");
    NSLog(@"----网页加载内容进程终止");
}

#pragma mark - 判断是否是iphoneX
- (BOOL)isiPhoneX {
    // 先判断当前设备是否为 iPhone 或 iPod touch
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // 获取屏幕的宽度和高度，取较大一方判断是否为 812.0 或 896.0
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat maxLength = screenWidth > screenHeight ? screenWidth : screenHeight;
        if (maxLength == 812.0f || maxLength == 896.0f) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)getTop {
    if ([self isiPhoneX]) {
        return 88;
    }
    return 64;
}

@end
