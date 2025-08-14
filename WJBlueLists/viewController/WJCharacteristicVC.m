//
//  WJCharacteristicVC.m
//  WJBlueLists
//
//  Created by wenjuan on 16/5/13.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "WJCharacteristicVC.h"
#import "OBDBluetooth.h"
#import "WJPeripheralCell.h"
#import "WJCharacteristicCell.h"
@import GoogleMobileAds;

@interface WJCharacteristicVC ()<OBDBluetoothDelegate,GADFullScreenContentDelegate>
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;
@property(nonatomic, strong) GADInterstitialAd *interstitial;
@end

@implementation WJCharacteristicVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [OBDBluetooth shareOBDBluetooth].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"特征";
    
    //创建头文件  tableview的头
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    //    sectionView.backgroundColor = [UIColor orangeColor];
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 0, SCREEN_WIDTH - 15, 80);
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"设备名: %@\nUUID: %@",[OBDBluetooth shareOBDBluetooth].peripheral.name,[OBDBluetooth shareOBDBluetooth].peripheral.identifier.UUIDString];
    
    [sectionView addSubview:label];
    [self.baseTableVC setTableHeaderView:sectionView];
    [self setBarItem];
    
//#ifdef DEBUG
//#else
    [self createAdView];
//#endif
    
}

-(void)createAdView{
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-9353975206269682/9724933629"
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        [self.interstitial presentFromRootViewController:self];
    }];
}

- (void)onClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 属性 懒加载
- (NSMutableArray *)sectionTitleArray {
    if (!_sectionTitleArray) {
        _sectionTitleArray = [NSMutableArray array];
    }
    return _sectionTitleArray;
}


//特征属性解析
- (void)getPropertyArray {
    [self.sectionTitleArray removeAllObjects];
    
    if (self.characteristic.properties & CBCharacteristicPropertyRead) {
        [self.sectionTitleArray addObject:@"可读"];
    }
    if (self.characteristic.properties & CBCharacteristicPropertyWrite) {
        [self.sectionTitleArray addObject:@"可写"];
    }
    if (self.characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [self.sectionTitleArray addObject:@"写无回复"];
    }
    if (self.characteristic.properties & CBCharacteristicPropertyNotify) {
        [self.sectionTitleArray addObject:@"订阅"];
    }
    if (self.characteristic.properties & CBCharacteristicPropertyIndicate) {
        [self.sectionTitleArray addObject:@"声明"];
    }
    [self.sectionTitleArray addObject:@"特征属性值"];
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    [self getPropertyArray];
    
    if (self.characteristic.properties & CBCharacteristicPropertyRead) {
        return 2;
    }else {
        return 1;
    }
}

//每一个分区的头
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ((self.characteristic.properties & CBCharacteristicPropertyRead) && (section == 0)) {
        
        return @"读数据";
        
    }else {
        
        return  @"特征属性值";
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((self.characteristic.properties & CBCharacteristicPropertyRead) && (section == 0)) {
        
        NSMutableArray * mutalbeArray = [[OBDBluetooth shareOBDBluetooth].readDataDic objectForKey:self.characteristic.UUID];
        if ([mutalbeArray count]>10) {
            return 11;
        }else {
            if ([mutalbeArray count] <= 0) {
                return 2;
            }else {
                return [mutalbeArray count] + 1 ;
            }
        }
        
    }else {
        return [self.sectionTitleArray count] - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"peripheralCell";
    WJCharacteristicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WJCharacteristicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ((self.characteristic.properties & CBCharacteristicPropertyRead) && (indexPath.section == 0)) {
        //读数据
        if(indexPath.row == 0) {
            cell.textDataLabel.text = @"读取数据";
            cell.textDataLabel.textColor = [UIColor blueColor];
        }else {
            cell.textDataLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
            NSMutableArray * mutalbeArray = [[OBDBluetooth shareOBDBluetooth].readDataDic objectForKey:self.characteristic.UUID];
            if ([mutalbeArray count] > 0 ) {
                NSString * dataString = [NSString stringWithFormat:@"%@" ,[mutalbeArray objectAtIndex:indexPath.row - 1] ];
                cell.textDataLabel.text = dataString;
            }
            
            
            //  LOG(@"读取数据=======: %@  == %@",[[[OBDBluetooth shareOBDBluetooth]readDataDic]objectForKey:self.characteristic.UUID],dataString);
        }
        
    }else {
        //属性列表
        cell.textDataLabel.text = [self.sectionTitleArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if ([[self.sectionTitleArray objectAtIndex:indexPath.section] isEqualToString:@"读数据"]) {
    //
    //        if(indexPath.row == 0) {
    //            [[OBDBluetooth shareOBDBluetooth] readCharacteristicValue:self.characteristic];
    ////            [self.baseTableVC reloadData];
    //            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //        }
    //
    //    }
    //
    //    if ([[self.sectionTitleArray objectAtIndex:indexPath.section] isEqualToString:@"写数据"]) {
    //        if(indexPath.row == 0) {
    //            [[OBDBluetooth shareOBDBluetooth]writeValue:@"66" andCharacteristic:self.characteristic];
    //            [self.baseTableVC reloadData];
    //        }
    //
    //    }
    
    if ((self.characteristic.properties & CBCharacteristicPropertyRead) && (indexPath.section == 0)) {
        if(indexPath.row == 0) {
            [[OBDBluetooth shareOBDBluetooth] readCharacteristicValue:self.characteristic];
            //            [self.baseTableVC reloadData];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    }
    
    
}

- (void)readDataForString {
    LOG(@"特征读数据界面");
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.baseTableVC reloadData];
    });
    
}

- (void)didDisconnectPeripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -GADInterstitialDelegate

- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
    _interstitial = nil;
}

- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self hide];
}

- (void)Timered:(NSTimer*)timer {
    [self hide];
}

@end
