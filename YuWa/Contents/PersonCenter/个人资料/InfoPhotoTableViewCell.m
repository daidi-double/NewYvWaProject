//
//  InfoPhotoTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "InfoPhotoTableViewCell.h"

@implementation InfoPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UIImageView*imageView=[self viewWithTag:1];
    imageView.layer.cornerRadius=32.5;
    imageView.layer.masksToBounds=YES;
//    imageView.image=[UIImage imageNamed:@"placeholder"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
