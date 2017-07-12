//
//  YWBankTableViewCell.m
//  YuWaShop
//
//  Created by double on 17/3/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBankTableViewCell.h"

@implementation YWBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self makeUI];
   
}
- (void)setBankModel:(YWBankModel *)bankModel{
    _bankModel = bankModel;
    [self makeUI];
}

- (void)makeUI{
    
    UIImageView * iconImageView = [self viewWithTag:1];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 22;
    iconImageView.image = [UIImage imageNamed:self.bankModel.bankName];
    
    UILabel * bankName = [self viewWithTag:2];
    bankName.text = self.bankModel.bankName;
    
    UILabel *bankCategory = [self viewWithTag:3];

    if (self.bankModel.bankCategory == nil ||[self.bankModel.bankCategory isEqualToString:@""]) {
        bankCategory.hidden = YES;
    }
    
    NSString * bankCard;
    UILabel *bankID = [self viewWithTag:4];
    if (self.bankModel.bankCard.length <19) {
        bankCard = @"";
    }else{
        bankCard =  [self.bankModel.bankCard substringFromIndex:15];
    }
    bankID.text = [NSString stringWithFormat:@"**** ******* **** %@",bankCard];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
