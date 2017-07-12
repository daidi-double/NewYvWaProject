//
//  scheduleTwoTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "scheduleTwoTableViewCell.h"

@implementation scheduleTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.manButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [self.manButton setImage:[UIImage imageNamed:@"seoected.png"] forState:UIControlStateSelected];
    [self.LadyButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [self.LadyButton setImage:[UIImage imageNamed:@"seoected.png"] forState:UIControlStateSelected];

    self.manButton.imageEdgeInsets=UIEdgeInsetsMake(0, -10,0, 10);
    [self.manButton addTarget:self action:@selector(touchManButton:) forControlEvents:UIControlEventTouchUpInside];
    self.LadyButton.imageEdgeInsets=UIEdgeInsetsMake(0,-10,0,10);
    [self.LadyButton addTarget:self action:@selector(touchLadyButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchManButton:(UIButton*)sender{
    sender.selected=YES;
    self.LadyButton.selected=NO;
    if (self.touchSelectedSexBlock) {
        self.touchSelectedSexBlock(@"先生");
    }
    
}

-(void)touchLadyButton:(UIButton*)sender{
    sender.selected=YES;
    self.manButton.selected=NO;
    if (self.touchSelectedSexBlock) {
        self.touchSelectedSexBlock(@"女士");
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
