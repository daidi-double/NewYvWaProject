//
//  SalesDetailTableViewCell.m
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SalesDetailTableViewCell.h"

@implementation SalesDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 20;
    self.nameLabel.textColor = LightColor;
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.moneyLabel.textColor = MoneyColor;
    self.isNumberOneLabel.layer.masksToBounds = YES;
    self.isNumberOneLabel.layer.cornerRadius = self.isNumberOneLabel.height/2;
    self.isNumberOneLabel.layer.borderColor = CNaviColor.CGColor;
    self.isNumberOneLabel.layer.borderWidth = 0.3f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
