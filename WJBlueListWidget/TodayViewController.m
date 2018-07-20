//
//  TodayViewController.m
//  WJBlueListWIDGET
//
//  Created by gozap on 16/11/24.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 90);
    self.view.backgroundColor = [UIColor colorWithRed:(80.0/ 255) green:(90.0 / 255) blue:(80.0 / 255) alpha:0.9];
    TodayLabelBtn * sousuoBtn = [[TodayLabelBtn alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0 -50, 20, ([UIScreen mainScreen].bounds.size.width -50)/4.0, 100)];
    sousuoBtn.iconImageVeiw.image = [UIImage imageNamed:@"longdaishequ_W"];
    sousuoBtn.label.text=@"蓝牙搜索";
    [self.view addSubview:sousuoBtn];
    UITapGestureRecognizer *sousuoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sousuoTapClickAction)];
    [sousuoBtn addGestureRecognizer:sousuoTap];
}

-(void)sousuoTapClickAction{
    NSString*urlStr = [NSString stringWithFormat:@"WJBlueApp://"];
    NSURL*url = [NSURL URLWithString:urlStr];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}



@end
@implementation TodayLabelBtn
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sebViews];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sebViews];
    }
    return self;
}
-(void)sebViews{
    _iconImageVeiw=[[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width -50)/4.0/2.0-17.5, 0, 35, 35)];
    _iconImageVeiw.image = [UIImage imageNamed:@"bonus_1"];
    [self addSubview:_iconImageVeiw];
    _iconImageVeiw.userInteractionEnabled=NO;
    
    _label=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, ([UIScreen mainScreen].bounds.size.width -50)/4.0, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor=[UIColor whiteColor];
    _label.font=[UIFont fontWithName:@"Helvetica" size:(13)];
    _label.text=@"我的资产";
    [self addSubview:_label];
}
@end

