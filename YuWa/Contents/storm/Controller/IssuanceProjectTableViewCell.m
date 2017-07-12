//
//  IssuanceProjectTableViewCell.m
//  YuWa
//
//  Created by double on 17/7/5.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "IssuanceProjectTableViewCell.h"

@implementation IssuanceProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = LightColor;
    self.contentTextFild.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
