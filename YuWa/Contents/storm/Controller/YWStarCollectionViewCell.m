//
//  YWStarCollectionViewCell.m
//  YuWa
//
//  Created by double on 17/6/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStarCollectionViewCell.h"

@implementation YWStarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.starIconImageView.layer.masksToBounds = YES;
    self.starIconImageView.layer.cornerRadius = self.starIconImageView.width/4;
}

@end
