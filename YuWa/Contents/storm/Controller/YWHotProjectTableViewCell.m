//
//  YWHotProjectTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHotProjectTableViewCell.h"

@implementation YWHotProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopIconImageView.layer.cornerRadius = 7;
    [self.bigImageView setUserInteractionEnabled:YES];
    self.shopNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.currentPriceLaber.textColor = [UIColor colorWithHexString:@"#333333"];
    self.currentNumber.textColor = [UIColor colorWithHexString:@"#333333"];
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"#ffb155"];
    UITapGestureRecognizer * iconTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toShopPlan)];
    iconTouch.numberOfTapsRequired = 1;
    iconTouch.numberOfTouchesRequired = 1;
    iconTouch.delegate = self;
    [self.bigImageView addGestureRecognizer:iconTouch];
    
}
- (void)toShopPlan{
    [self.delegate toShopPlanPage:self.auctionBtn];
}
//立即抢拍
- (IBAction)auctionAction:(UIButton *)sender {
    
    [self.delegate toShopPlanPage:sender];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
