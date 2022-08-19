//
//  WJPeripheralVC.m
//  WJBlueLists
//
//  Created by wenjuan on 16/5/9.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "WJPeripheralVC.h"
#import "WJPeripheralCell.h"
#import "OBDBluetooth.h"
#import "WJServerVC.h"
#import "SettingViewController.h"
#import <StoreKit/StoreKit.h>
#define kPulseAnimation @"kPulseAnimation"

@import GoogleMobileAds;

@interface WJPeripheralVC ()<OBDBluetoothDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic, strong) NSMutableArray *rissArray;
@property (nonatomic, strong) UILabel *noPeripheralView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView * refreshImageView;

@property(nonatomic, strong) GADBannerView *bannerView;
@end

@implementation WJPeripheralVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];

    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-90);
    }];
    [self.view bringSubviewToFront:_noPeripheralView];

    //每次显示界面  重新设置代理  扫描设别
    [OBDBluetooth shareOBDBluetooth].delegate = self;
    [[OBDBluetooth shareOBDBluetooth] scanPeripheral];
#ifdef DEBUG
#else
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        [SKStoreReviewController requestReview];
    }
#endif
#ifdef DEBUG
#else
    [self createAdView];
#endif
    
}

-(void)refreshClick{
    BOOL isAnimating = NO;
    NSArray *layerArr = [NSArray arrayWithArray:_refreshImageView.superview.layer.sublayers];
    for (CALayer *layer in layerArr) {
        if ([layer.animationKeys containsObject:kPulseAnimation]) {
            isAnimating = YES;
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }
    }
    if (!isAnimating) {
        [self waveAnimationLayerWithView:_refreshImageView diameter:180 duration:1.0];
        [self.tableView reloadData];
    }
}

-(void)createAdView{
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 110,SCREEN_WIDTH - 30 , 85)];
    self.bannerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-9353975206269682/4408139710";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";

    //在没有搜索到设备的时候  提示用户没有搜索到设备
    _noPeripheralView  = [[UILabel alloc]initWithFrame:CGRectMake(25, 100, [UIScreen mainScreen].bounds.size.width - 50, 250)];
    _noPeripheralView.text = @"蓝牙通：是一款链接蓝牙外设的小工具，展示数据帮助您学习蓝牙知识等。\n\n暂时还未搜索到附近蓝牙设备！请检查如下可能：\n\n1.检查手机是否打开蓝牙功能;\n\n2.检查App是否开启蓝牙权限;\n\n3.请打开您要连接的蓝牙设备.";
    _noPeripheralView.font = WJFont(13);
    _noPeripheralView.textColor = [UIColor grayColor];
    _noPeripheralView.textAlignment = NSTextAlignmentLeft;
    _noPeripheralView.numberOfLines = 0;
    [self.view addSubview:_noPeripheralView];
    [self.view bringSubviewToFront:_noPeripheralView];
    
//    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    UIImage * addIamge = [[UIImage imageNamed:@"ic_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    rightBtn.tintColor = [UIColor whiteColor];
//    [rightBtn setImage:addIamge forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//
//    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];

}

-(void)rightBtnClick{
    SettingViewController * setvc = [SettingViewController new];
    [self.navigationController pushViewController:setvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 属相 懒加载
- (NSMutableArray *)rissArray {
    if (!_rissArray) {
        _rissArray = [NSMutableArray array];
    }
    return _rissArray;
}
- (NSMutableArray *)tableDataArray {
    if (!_tableDataArray) {
        _tableDataArray = [NSMutableArray array];
    }
    return _tableDataArray;
}

#pragma mark - tableview 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"peripheralCell";
    WJPeripheralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WJPeripheralCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CBPeripheral *peripheral = [self.tableDataArray objectAtIndex:indexPath.row];
    //LOG(@"%@",peripheral);
    
    cell.titleLabel.text = peripheral.name;
    //peripheral.identifier.UUIDString
    //    NSString *idenfirierS = [NSString stringWithFormat:@"%d服务",[peripheral.services count]];
    cell.identifierLabel.text =  peripheral.identifier.UUIDString;
    cell.rissLabel.text = [NSString stringWithFormat:@"%@",[self.rissArray objectAtIndex:indexPath.row]];
    
    return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = [self.tableDataArray objectAtIndex:indexPath.row];
    
    [[OBDBluetooth shareOBDBluetooth] connectPeripheral:peripheral];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - 蓝牙代理方法
- (void) reloadTableView:(NSMutableArray *) peripheralA andRissArray:(NSMutableArray *)rissArray {
    self.tableDataArray = peripheralA;
    self.rissArray = rissArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tableDataArray.count > 0 && self.rissArray.count > 0 && self.tableDataArray.count == self.rissArray.count) {
            _noPeripheralView.hidden = YES;
        }else {
            _noPeripheralView.hidden = NO;
        }
        //if (self.tableDataArray.count <= 0) {
        //     [[OBDBluetooth shareOBDBluetooth] stopPeripheral];
            [self.tableView reloadData];
        //}
    });
}

-(void)nextVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        LOG(@"界面跳转");
        [self.navigationController pushViewController:[[WJServerVC alloc]init] animated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
    });
}

- (void)didDisconnectPeripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

- (void)readDataForString {
    LOG(@"读取到数据的 代理方法");
}

//diameter 扩散的大小
- (CALayer *)waveAnimationLayerWithView:(UIView *)view diameter:(CGFloat)diameter duration:(CGFloat)duration {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    waveLayer.cornerRadius = diameter / 2; //设置圆角变为圆形
    waveLayer.position = view.center;
    waveLayer.backgroundColor = [[UIColor colorWithRed:255/ 255.0 green:255/ 255.0 blue:255/ 255.0 alpha:1] CGColor];
    [view.superview.layer insertSublayer:waveLayer below:view.layer];//把扩散层放到播放按钮下面
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = INFINITY; //重复无限次
    animationGroup.removedOnCompletion = NO;
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0; //开始的大小
    scaleAnimation.toValue = @0.4; //最后的大小
    scaleAnimation.duration = duration;
    scaleAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0; //开始的大小
    opacityAnimation.toValue = @0.0; //最后的大小
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [waveLayer addAnimation:animationGroup forKey:kPulseAnimation];
    
    return waveLayer;
}
@end
