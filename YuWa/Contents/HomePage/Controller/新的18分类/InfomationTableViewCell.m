//
//  InfomationTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "InfomationTableViewCell.h"

@implementation InfomationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleBtn.layer.borderColor = CNaviColor.CGColor;
    self.titleBtn.layer.borderWidth = 1;
    self.titleBtn.layer.cornerRadius = 5;
    [self.titleBtn.layer setMasksToBounds:YES];
}

-(void)setModel:(CinemaLabelModel *)model{
    _model = model;
    [self setData];
    
}

- (void)setData{
    [self.titleBtn setTitle:self.model.name forState:UIControlStateNormal];
    self.infoLabel.text = self.model.introduce;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
