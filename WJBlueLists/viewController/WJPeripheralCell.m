//
//  WJPeripheralCell.m
//  WJBlueLists
//
//  Created by wenjuan on 16/5/9.
//  Copyright © 2016年 wenjuan. All rights reserved.
//

#import "WJPeripheralCell.h"

@implementation WJPeripheralCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellView];
    }
    return self;
}

- (void)createCellView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    UIView * bgView  = [UIView new];
    bgView.layer.cornerRadius = 5;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(15);
        make.left.equalTo(bgView).offset(15);
    }];
    
    _rissLabel = [UILabel new];
    _rissLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    _rissLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_rissLabel];
    [_rissLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(bgView).offset(-15);
    }];
    
    UIImageView * xinHaoImageView = [UIImageView new];
    xinHaoImageView.image = [UIImage imageNamed:@"xinhao"];
    [bgView addSubview:xinHaoImageView];
    [xinHaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rissLabel);
        make.right.equalTo(_rissLabel.mas_left).offset(-5);
        make.width.height.equalTo(@20);
    }];
    
    _identifierLabel = [UILabel new];
    _identifierLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    _identifierLabel.adjustsFontSizeToFitWidth = YES;
    _identifierLabel.numberOfLines = 0;
    _identifierLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_identifierLabel];
    [_identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-10);
    }];
}
@end


@implementation TitleSwitchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self sebViews];
    }
    return self;
}

-(void)sebViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(bgView);
    }];
    
    _sevenSwitch = [UISwitch new];
    _sevenSwitch.onTintColor = [UIColor colorWithRed:30/255.0 green:151/255.0 blue:254/255.0 alpha:1];
    _sevenSwitch.thumbTintColor = [UIColor colorWithHexString:@"3d3d3d"];
    [bgView addSubview:_sevenSwitch];
    [_sevenSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];

}
@end
