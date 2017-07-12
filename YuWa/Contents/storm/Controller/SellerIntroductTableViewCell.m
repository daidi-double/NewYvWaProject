//
//  SellerIntroductTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SellerIntroductTableViewCell.h"

@implementation SellerIntroductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sellerIconImageView.layer.masksToBounds = YES;
    self.sellerIconImageView.layer.cornerRadius = 25;
    self.sellerNameLabel.textColor = LightColor;
    self.identityLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.identityLabel.layer.masksToBounds = YES;
    self.identityLabel.layer.cornerRadius = 10;
    
    self.identityTwoLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.identityTwoLabel.layer.masksToBounds = YES;
    self.identityTwoLabel.layer.cornerRadius = 10;
    
    self.identityThreeLabel.textColor = [UIColor colorWithHexString:@"#666666"];

    CGFloat imageWidth = (kScreen_Width-100-70)/4;
    for (int i = 0; i <4; i++) {
        UIImageView * produceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50+(imageWidth+24)*i, 0, imageWidth, imageWidth)];
        produceImageView.centerY = self.projectScrollView.height/2-10;
        produceImageView.image = [UIImage imageNamed:@"baobaoBG3"];
        produceImageView.layer.masksToBounds = YES;
        produceImageView.layer.cornerRadius = 5;
        [self.projectScrollView addSubview:produceImageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
