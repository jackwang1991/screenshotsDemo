//
//  LSscreensShotsHandler.m
//  screenshotsDemo
//
//  Created by wm on 2019/4/22.
//  Copyright © 2019年 wm. All rights reserved.
//

#import "LSScreenshotsHandler.h"
#import <WebKit/WebKit.h>

#define DELAY_TIME_DRAW 0.1

@interface LSScreenshotsHandler () {
    BOOL _isCapturing;
    UIView *_captureView;
}

@end

@implementation LSScreenshotsHandler

+ (instancetype)defaultHandler {
    static LSScreenshotsHandler *defaultHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultHandler = [[LSScreenshotsHandler alloc] init];
    });
    return defaultHandler;
}

- (void)screensShotsForView:(__kindof UIView *)view {
    if (!view || _isCapturing) {
        return;
    }
    
    _captureView = view;
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        
    } else if ([view isKindOfClass:[UIWebView class]]) {
        
        
    } else if ([view isKindOfClass:[WKWebView class]]) {
        [self screenshotForWKWebView:(WKWebView *)view];
    }
}

- (void)screenshotForWKWebView:(WKWebView *)webView {
    UIView *screenshotsView = [webView snapshotViewAfterScreenUpdates:YES];
    screenshotsView.frame = webView.frame;
    [webView.superview addSubview:screenshotsView];
    
    CGPoint currentOffset = webView.scrollView.contentOffset;
    CGRect currentFrame = webView.frame;
    UIView *currentSuperView = webView.superview;
    NSUInteger currentIndex = [webView.superview.subviews indexOfObject:webView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:webView.bounds];
    [webView removeFromSuperview];
    [containerView addSubview:webView];
    
    CGSize totalSize = webView.scrollView.contentSize;
    NSInteger page = ceil(totalSize.height / containerView.bounds.size.height);
    
    webView.scrollView.contentOffset = CGPointZero;
    webView.frame = CGRectMake(0, 0, containerView.bounds.size.width, webView.scrollView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(totalSize, YES, UIScreen.mainScreen.scale);
    [self drawContentPage:containerView webView:webView index:0 maxIndex:page completion:^{
        UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [webView removeFromSuperview];
        [currentSuperView insertSubview:webView atIndex:currentIndex];
        webView.frame = currentFrame;
        webView.scrollView.contentOffset = currentOffset;
        
        [screenshotsView removeFromSuperview];
        
        self->_isCapturing = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(screenshotHandler:didFinish:forView:)]) {
            [self.delegate screenshotHandler:self didFinish:screenshotImage forView:self->_captureView];
        }
        
    }];

}

- (void)drawContentPage:(UIView *)targetView webView:(WKWebView *)webView index:(NSInteger)index maxIndex:(NSInteger)maxIndex completion:(dispatch_block_t)completion
{
    CGRect splitFrame = CGRectMake(0, index * CGRectGetHeight(targetView.bounds), targetView.bounds.size.width, targetView.frame.size.height);
    CGRect myFrame = webView.frame;
    myFrame.origin.y = -(index * targetView.frame.size.height);
    webView.frame = myFrame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_TIME_DRAW * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if (index < maxIndex) {
            [self drawContentPage:targetView webView:webView index:index + 1 maxIndex:maxIndex completion:completion];
        } else {
            completion();
        }
    });
}

#pragma mark - UIScrollView

- (void)screenshotForScrollView:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    CGRect currentFrame = scrollView.frame;
    
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, UIScreen.mainScreen.scale);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scrollView.contentOffset = currentOffset;
    scrollView.frame = currentFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenshotHandler:didFinish:forView:)]) {
        [self.delegate screenshotHandler:self didFinish:screenshotImage forView:self->_captureView];
    }
}

@end
