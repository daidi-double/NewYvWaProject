//
//  OrdelShopCellView.m
//  YuWa
//
//  Created by double on 17/3/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OrdelShopCellView.h"

@implementation OrdelShopCellView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.numberLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.width/2, 34)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
       
    }
    return _titleLabel;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.7f, 5, 30, 34)];
        _numberLabel.textColor = [UIColor lightGrayColor];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _numberLabel;
}
- (UILabel*)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.85f, 5, kScreen_Width * 0.1f, 34)];
        _priceLabel.textColor = [UIColor darkGrayColor];
        _priceLabel.font = [UIFont systemFontOfSize:14];
       
    }
    return _priceLabel;
}
@end
