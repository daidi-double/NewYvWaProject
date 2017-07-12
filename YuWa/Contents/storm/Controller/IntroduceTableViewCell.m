//
//  IntroduceTableViewCell.m
//  YuWa
//
//  Created by double on 17/7/5.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "IntroduceTableViewCell.h"

@implementation IntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleNameLabel.textColor = LightColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
