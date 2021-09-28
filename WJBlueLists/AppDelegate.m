//
//  AppDelegate.m
//  WJBlueLists
//
//  Created by wenjuan on 16/5/4.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "AppDelegate.h"
#import "WJPeripheralVC.h"
#import "LCNavigationViewController.h"

@import GoogleMobileAds;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
#else
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
#endif
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    LCNavigationViewController *na = [[LCNavigationViewController alloc]initWithRootViewController:[[WJPeripheralVC alloc] init]];
    self.window.rootViewController = na;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
