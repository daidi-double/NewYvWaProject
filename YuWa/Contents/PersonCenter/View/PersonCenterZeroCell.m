//
//  PersonCenterZeroCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PersonCenterZeroCell.h"

@implementation PersonCenterZeroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitleString:(NSString *)titleString{
    _titleString=titleString;
    
    UILabel*label=[self viewWithTag:1];
    label.text=titleString;
    
}


+(CGFloat)CalculateCellHeight:(NSString *)str{
//    NSLog(@"%@",str);
    CGFloat cellHeight=[str boundingRectWithSize:CGSizeMake(kScreen_Width-30, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    return 22+cellHeight;
    
}

@end
