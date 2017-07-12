//
//  YWChooseOneTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWChooseOneTableViewCell.h"

@implementation YWChooseOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton*button=[self.contentView viewWithTag:1];
    [button setImage:[UIImage imageNamed:@"whiteChoose.jpg"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"blueChoose.jpg"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:CNaviColor forState:UIControlStateSelected];
    
    UIButton*numberButton=[self.contentView viewWithTag:2];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:CNaviColor forState:UIControlStateSelected];

    
    button.userInteractionEnabled=NO;
    numberButton.userInteractionEnabled=NO;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setIsSelected:(BOOL)isSelected{
//    _isSelected=isSelected;
//    
//     UIButton*button=[self.contentView viewWithTag:1];
//    button.selected=isSelected;
//    
//    UIButton*numberButton=[self.contentView viewWithTag:2];
//    numberButton.selected=isSelected;
//    
//    
//}


@end
