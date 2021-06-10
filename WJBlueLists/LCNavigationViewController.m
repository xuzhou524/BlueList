//
//  LCNavigationViewController.m
//  LittleSesame
//
//  Created by xuzhou on 2018/7/11.
//  Copyright © 2018年 chenyk. All rights reserved.
//

#import "LCNavigationViewController.h"

@interface LCNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LCNavigationViewController

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:30/255.0 green:151/255.0 blue:254/255.0 alpha:1]]
                             forBarMetrics:UIBarMetricsDefault];
    //navigationBar Title 样式
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:17],
                                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                                 }];
    [self.navigationBar setShadowImage:[self createImageWithColor:[UIColor colorWithRed:30/255.0 green:151/255.0 blue:254/255.0 alpha:1]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

#pragma mark 返回按钮
-(void)popself {
    UIViewController *currentVC = [self.viewControllers lastObject] ;
    if ( [currentVC respondsToSelector:@selector(popself)] ) {
        [currentVC performSelector:@selector(popself)];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark 创建返回按钮
-(UIBarButtonItem *)createBackButton {
    UIButton *liftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    UIImage * arrowIamge = [[UIImage imageNamed:@"d_Arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    liftBtn.tintColor = [UIColor whiteColor];
    liftBtn.imageEdgeInsets = UIEdgeInsetsMake( 0, -5, 0, 5);
    [liftBtn setImage:arrowIamge forState:UIControlStateNormal];
    [liftBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * liftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftBtn];
    return liftButtonItem;
}

#pragma mark 重写方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断子控制器的数量
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
}

//-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
//    // 判断子控制器的数量
//    if (viewControllers.count > 1) {
//        UIViewController * lastViewController = viewControllers.lastObject;
//        lastViewController.hidesBottomBarWhenPushed = YES;
//    }
//    [super setViewControllers:viewControllers animated:animated];
//    for (UIViewController * viewController in viewControllers) {
//        if (viewController.navigationItem.leftBarButtonItem == nil) {
//            viewController.navigationItem.leftBarButtonItem =[self createBackButton];
//        }
//    }
//}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
