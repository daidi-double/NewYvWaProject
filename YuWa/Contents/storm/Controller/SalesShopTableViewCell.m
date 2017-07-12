//
//  SalesShopTableViewCell.m
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SalesShopTableViewCell.h"

@implementation SalesShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addressLabel.textColor= LightColor;
    self.addressLabel.layer.masksToBounds = YES;
    self.addressLabel.layer.cornerRadius = self.addressLabel.height/2;
    self.addressLabel.layer.borderWidth = 0.3f;
    self.addressLabel.layer.borderColor = LightColor.CGColor;
    self.characteristicLabel.textColor = LightColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
