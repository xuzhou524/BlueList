//
//  TodayViewController.h
//  WJBlueListWidget
//
//  Created by gozap on 16/11/24.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@end
@interface TodayLabelBtn : UIView
@property(nonatomic,strong)UIImageView * iconImageVeiw;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)NSArray * buttonIconArray;
@property(nonatomic,assign)NSInteger selectedIndex;
@end
