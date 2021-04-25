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
#define kPulseAnimation @"kPulseAnimation"

@interface WJPeripheralVC ()<OBDBluetoothDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic, strong) NSMutableArray *rissArray;
@property (nonatomic, strong) UILabel *noPeripheralView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView * refreshImageView;
@end

@implementation WJPeripheralVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //每次显示界面  重新设置代理  扫描设别
    [OBDBluetooth shareOBDBluetooth].delegate = self;
    [[OBDBluetooth shareOBDBluetooth] scanPeripheral];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    //在没有搜索到设备的时候  提示用户没有搜索到设备
    _noPeripheralView  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    _noPeripheralView.text = @"亲\n\n搜索不到设备！\n\n请打开您要连接的设备";
    _noPeripheralView.font = WJFont(18);
    _noPeripheralView.textAlignment = NSTextAlignmentCenter;
    _noPeripheralView.numberOfLines = 0;
    [self.view addSubview:_noPeripheralView];
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
    return 110;
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
        if ([self.tableDataArray count] > 0) {
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
