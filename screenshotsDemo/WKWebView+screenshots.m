//
//  WKWebView+screenshots.m
//  screenshotsDemo
//
//  Created by wm on 2019/4/21.
//  Copyright © 2019年 wm. All rights reserved.
//

#import "WKWebView+screenshots.h"

@implementation WKWebView (screenshots)

- (UIImage *)screenshots {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, true, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = self.scrollView.contentOffset;
        CGRect savedFrame = self.scrollView.frame;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        for (UIView * subiView in self.subviews) {
            [subiView drawViewHierarchyInRect:subiView.bounds afterScreenUpdates:YES];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        self.scrollView.contentOffset = savedContentOffset;
        self.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return image;
}

@end
