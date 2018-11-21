//
//  WJBaseCV.m
//  WJBlueLists
//
//  Created by wenjuan on 16/5/4.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "WJBaseCV.h"
#import "WJBaseCell.h"
@import GoogleMobileAds;

@interface WJBaseCV ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) GADBannerView  *bottomView;
@end

@implementation WJBaseCV

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self tableViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
   
    //tableview 的footview
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.baseTableVC.tableFooterView = footView;
    
    
    LOG(@"google version = %@", [GADRequest sdkVersion]);
    _bottomView = [[GADBannerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [self.view addSubview:_bottomView];
    //ca-app-pub-3469552292226288/9081240452
//    self.bottomView .adUnitID = @"ca-app-pub-3469552292226288/9081240452";
//    self.bottomView .rootViewController = self;
//    GADRequest *request = [GADRequest request];
//    request.testDevices = @[
//                            @"281aa25148dd68a8a1202b620799c3ce"  // Eric's iPod Touch
//                            ];
//    [self.bottomView  loadRequest:[GADRequest request]];
}

#pragma mark - 属相 懒加载
- (UITableView *)baseTableVC {

    if (!_baseTableVC) {
        _baseTableVC = [[UITableView alloc]initWithFrame:CGRectZero style: UITableViewStyleGrouped];
        _baseTableVC.dataSource = self;
        _baseTableVC.delegate = self;
        _baseTableVC.separatorStyle = UITableViewCellAccessoryNone;
      
    }
    return _baseTableVC;
}


- (NSMutableArray *)tableDataArray {

    if (!_tableDataArray) {
        _tableDataArray = [NSMutableArray array];
    }
    return _tableDataArray;
}



#pragma mark - 本类的方法

- (void)tableViewFrame:(CGRect)frame {
    self.baseTableVC.frame = frame;
    [self.view addSubview:_baseTableVC];
}

-(void)setBarItem {
    //设置左侧返回按钮
    UIButton *liftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [liftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    liftBtn.tag = -1;
    liftBtn.imageEdgeInsets = UIEdgeInsetsMake( 2, 0, 2, 5);
    [liftBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * liftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftBtn];
    self.navigationItem.leftBarButtonItem = liftButtonItem;
}

//导航栏上的BarButtonItem的响应事件
-(void)onClick:(id)sender {
    UIButton * btn = (UIButton*)sender;
    if (btn.tag ==-1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - tableview 代理方法
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"baseCell";
    WJBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WJBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
