//
//  OtherTicketPayTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayTableViewCell.h"

@implementation OtherTicketPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSInteger number = [self.numberLabel.text integerValue];
    if (number == 1) {
       self.reduceBtn.enabled = NO;
    }
    // Initialization code
}
- (IBAction)reduceAction:(UIButton *)sender {
    NSInteger number = [self.numberLabel.text integerValue];
    if (number == 2) {
        sender.enabled = NO;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%zi",number-1];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.model.price floatValue]/100 * [self.numberLabel.text integerValue]];
    [self.delegate reduceOrAddTicket:2];
    
}
- (IBAction)addAction:(UIButton *)sender {
    self.reduceBtn.enabled = YES;
    NSInteger number = [self.numberLabel.text integerValue];
    self.numberLabel.text = [NSString stringWithFormat:@"%zi",number+1];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.model.price floatValue]/100 * [self.numberLabel.text integerValue]];
    [self.delegate reduceOrAddTicket:1];
    
}

- (IBAction)useCouponAction:(UIButton *)sender {
    [self.delegate useCouponActionTouch:sender];
}

- (void)setModel:(OtherTicketModel *)model{
    _model = model;
    [self setData];
}
-(void)setData{
    self.cinemaNameLabel.text = self.model.range;
    NSString * showType;
    switch ([self.model.showType integerValue]) {
        
        case 0:
            showType = @"2D";
            break;
        case 1:
            showType = @"3D";
            break;
        case 2:
            showType = @"MAX2D";
            break;
        case 3:
            showType = @"MAX3D";
            break;
        case 4:
            showType = @"中国巨幕2D";
            break;
        default:
            showType = @"中国巨幕3D";
            break;

    }
    self.ticketTypeLabel.text = [NSString stringWithFormat:@"%@通兑票",showType];
    switch ([self.model.validType integerValue]) {
        case 0:
            
            self.timeLabel.text = [NSString stringWithFormat:@"%@天",self.model.validDays];
            break;
            
        default:
            self.timeLabel.text = [NSString stringWithFormat:@"有效期%@",self.model.validDate];
            break;
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"总价:￥%.2f",[self.model.price floatValue]/100 * [self.numberLabel.text integerValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
