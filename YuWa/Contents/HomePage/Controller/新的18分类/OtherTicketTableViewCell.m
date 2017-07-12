//
//  OtherTicketTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketTableViewCell.h"

@implementation OtherTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(OtherTicketModel *)model{
    _model = model;
    [self setData];
}

-(void)setData{
    self.BGView.layer.cornerRadius = 5;
    self.BGView.layer.masksToBounds = YES;
    
    CGFloat sellerPrice = [self.model.price floatValue]/100;
    NSString * showType;//兑换放映类型（0：2D 1：3D 2：IMAX2D 3：IMAX3D 4：中国巨幕2D 5：中国巨幕3D）
    switch ([self.model.showType integerValue]) {
        case 0:
            showType = @"2D";
            break;
        case 1:
            showType = @"3D";
            break;
        case 2:
            showType = @"IMAX2D";
            break;
        case 3:
            showType = @"IMAX3D";
            break;
        case 4:
            showType = @"中国巨幕2D";
            break;
        default:
            showType = @"中国巨幕3D";
            break;
    }
    
    self.filmTypeLabel.text = [NSString stringWithFormat:@"%@",showType];
    self.sellerPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",sellerPrice];
    self.markLabel.text = [NSString stringWithFormat:@"可在本影院兑换%@电影票",showType];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
