//
//  CustomTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/2.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self customTitleBtn];
    // Initialization code
}
- (void)customTitleBtn{
    [self.titleBtn setTitleColor:RGBCOLOR(132, 132, 132, 1) forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
