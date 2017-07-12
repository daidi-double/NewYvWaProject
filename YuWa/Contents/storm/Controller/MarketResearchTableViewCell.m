//
//  MarketResearchTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MarketResearchTableViewCell.h"

@implementation MarketResearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


    self.goodContentLabel.textColor = LightColor;
    self.goodContentLabel.text = @"1、专注于优质生态黑猪的供应链，为菜场肉铺提供优势/高性价比生态黑猪肉   \n 2、通过旗下侬门刀客培训";
    self.goodTitleLabel.textColor = LightColor;
    self.marketOne.textColor = LightColor;
    self.marketTwo.textColor = LightColor;
    self.marketTypeName.textColor = LightColor;
    self.marketTypeLabel.textColor = LightColor;
    self.goalNumberLabel.textColor = LightColor;
    self.goalMarketNumberT.textColor = LightColor;
    self.marketTitleLabel.textColor = LightColor;
    self.teamLabel.textColor = LightColor;
    self.otherGoodLabel.textColor = LightColor;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
