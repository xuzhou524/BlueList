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
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(15);
        make.left.equalTo(bgView).offset(15);
    }];
    
    _rissLabel = [UILabel new];
    _rissLabel.textColor = [UIColor colorWithHexString:@"3d3d3d"];
    _rissLabel.font = [UIFont systemFontOfSize:13];
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
    _identifierLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_identifierLabel];
    [_identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-15);
    }];
}
@end
