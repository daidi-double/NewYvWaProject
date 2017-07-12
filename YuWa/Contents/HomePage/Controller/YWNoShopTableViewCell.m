//
//  YWNoShopTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNoShopTableViewCell.h"

@implementation YWNoShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)toBuyShopAction:(UIButton *)sender {
    [self.delegate toBuyShop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
