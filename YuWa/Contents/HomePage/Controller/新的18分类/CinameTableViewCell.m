//
//  CinameTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinameTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation CinameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CinemaModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    
    self.cinemaNameLabel.text = self.model.cinema_name;
    self.addressLabel.text = self.model.address;
    self.filmCountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.filmCountLabel.text = [NSString stringWithFormat:@"%@部电影正在上映",self.model.film_count];
    if (self.model.film_count == nil) {
        self.filmCountLabel.text = @"-/-部电影正在上映";
    }
    if (self.model.settle_price == nil) {
       self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.minprice] withFont:self.priceLabel.font withColor:[UIColor colorWithHexString:@"#ff7800"] withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor colorWithHexString:@"#999999"]];
        if (self.model.minprice == nil) {
            self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥-/-"] withFont:self.priceLabel.font withColor:[UIColor colorWithHexString:@"#ff7800"] withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor colorWithHexString:@"#999999"]];

        }
    }else{
      self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.settle_price] withFont:self.priceLabel.font withColor:[UIColor colorWithHexString:@"#ff7800"] withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor colorWithHexString:@"#999999"]];
    }

    self.otherTicketLabel.layer.cornerRadius = 2;
    self.otherTicketLabel.layer.masksToBounds = YES;
    
    self.seatLabel.layer.cornerRadius = 2;
    self.seatLabel.layer.masksToBounds = YES;
    CGFloat distanceNo = [self.model.distance floatValue]/1000;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distanceNo];
    switch ([self.model.goodstype integerValue]) {
        case 0:
            self.otherTicketLabel.text = @"兑";
            self.seatLabel.text = @"座";
            self.seatLabel.hidden = NO;
            self.otherTicketLabel.hidden = NO;
            self.foodLabel.hidden = YES;
            break;
        case 1:
             self.seatLabel.text = @"座";
            self.seatLabel.hidden = NO;
            self.otherTicketLabel.hidden = YES;
            self.foodLabel.hidden = YES;
            break;
        case 2:
            self.seatLabel.text = @"兑";
            self.seatLabel.hidden = YES;
            self.otherTicketLabel.hidden = NO;
            self.foodLabel.hidden = YES;
            break;
        case 3:
//            self.seatLabel.text = @"座";
            self.seatLabel.hidden = YES;
            self.otherTicketLabel.hidden = YES;
            self.foodLabel.hidden = YES;
            break;
        case 4:
            self.seatLabel.text = @"座";
            self.seatLabel.hidden = NO;
            self.otherTicketLabel.hidden = YES;
            self.foodLabel.hidden = YES;
            break;
        case 5:
            self.otherTicketLabel.text = @"兑";
            self.seatLabel.hidden = YES;
            self.otherTicketLabel.hidden = NO;
            self.foodLabel.hidden = YES;
            break;
        default:
            self.seatLabel.hidden = NO;
            self.foodLabel.hidden = YES;
            self.otherTicketLabel.hidden = NO;
            self.otherTicketLabel.text = @"兑";
            self.seatLabel.text = @"座";
            
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
