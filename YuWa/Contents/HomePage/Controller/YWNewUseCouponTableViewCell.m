//
//  YWNewUseCouponTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNewUseCouponTableViewCell.h"

@implementation YWNewUseCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)chooseYouhuiquanAction:(UIButton *)sender {
    
    if (sender.selected) {
        self.chooseImageView.image = [UIImage imageNamed:@"photo_sel"];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"photo_def"];
    }
    sender.selected = !sender.selected;
    [self.delegate useYouhuiquanAction];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
