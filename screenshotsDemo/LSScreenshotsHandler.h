//
//  LSscreensShotsHandler.h
//  screenshotsDemo
//
//  Created by wm on 2019/4/22.
//  Copyright © 2019年 wm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LSScreenshotsHandler;

@protocol LSScreenshotsDelegate <NSObject>

@optional

- (void)screenshotHandler:(LSScreenshotsHandler *)screenshotHandler didFinish:(UIImage *)captureImage forView:(UIView *)view;

@end

@interface LSScreenshotsHandler : NSObject

+ (instancetype)defaultHandler;

- (void)screensShotsForView:(__kindof UIView *)view;

@property (nonatomic, weak) id<LSScreenshotsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
