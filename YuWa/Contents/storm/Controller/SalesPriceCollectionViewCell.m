//
//  SalesPriceCollectionViewCell.m
//  YuWa
//
//  Created by double on 17/7/4.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SalesPriceCollectionViewCell.h"

@implementation SalesPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.textColor = LightColor;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
}

@end
