//
//  ShopPlanFirstTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopPlanFirstTableViewCell.h"

@implementation ShopPlanFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopNameLabel.textColor = LightColor;
    self.characteristicLabel.textColor = LightColor;
    self.categoryLabel.textColor = LightColor;
    self.shopIntroduceLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.introLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.currentPriceLabel.textColor = LightColor;
    self.priceLabel.textColor = LightColor;
    self.lookPeopleNumberLabel.textColor = LightColor;
    self.minPriceLabel.textColor = LightColor;
    self.cautionMoneyLabel.textColor = LightColor;
    self.geiPriceNumberLabel.textColor = LightColor;
    self.shopIconImageView.layer.cornerRadius = 5;
    self.shopIconImageView.layer.masksToBounds = YES;
}
- (IBAction)allIntroAction:(UIButton *)sender {
    MyLog(@"全部介绍");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
