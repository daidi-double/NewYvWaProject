//
//  YWWinnersCollectionViewCell.m
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWWinnersCollectionViewCell.h"

@implementation YWWinnersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.getAwardBtn.layer.masksToBounds = YES;
    self.getAwardBtn.layer.cornerRadius = 5;
    [self.getAwardBtn setHidden:YES];
    
}
- (IBAction)getAwardAction:(UIButton *)sender {
    [self.delegate pushToGetAward:sender.tag];
}

@end
