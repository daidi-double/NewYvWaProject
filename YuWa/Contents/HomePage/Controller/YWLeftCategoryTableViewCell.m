//
//  YWLeftCategoryTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWLeftCategoryTableViewCell.h"

@implementation YWLeftCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.numberLabel.backgroundColor= [UIColor redColor];
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.numberLabel.backgroundColor = [UIColor redColor];
}
@end
