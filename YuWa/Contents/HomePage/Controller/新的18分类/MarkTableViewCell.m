//
//  MarkTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MarkTableViewCell.h"

@implementation MarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = RGBCOLOR(239, 239, 244, 1);
    self.textFildBGView.layer.cornerRadius = 21;
    self.textFildBGView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
