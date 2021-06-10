//
//  WJPeripheralCell.h
//  WJBlueLists
//
//  Created by wenjuan on 16/5/9.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "WJBaseCell.h"

@interface WJPeripheralCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *identifierLabel;

@property (nonatomic, strong) UILabel *rissLabel;
@end


@interface TitleSwitchTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UISwitch * sevenSwitch;
@end
