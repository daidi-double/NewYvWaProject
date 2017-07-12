//
//  CinemaTimeCell.m
//  YuWa
//
//  Created by double on 2017/2/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaTimeCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation CinemaTimeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
  
    }
    return self;
}
- (UILabel*)cinemaName{
    if (!_cinemaName) {
        _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreen_Width*0.8, self.bounds.size.height/2)];
        _cinemaName.textColor = [UIColor blackColor];
        _cinemaName.textAlignment = 0;
        _cinemaName.font = [UIFont systemFontOfSize:15];
         [self.contentView addSubview:_cinemaName];
    }
    return _cinemaName;
}

- (UILabel*)price{
    if (!_price) {
        _price = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height+15, kScreen_Width*0.4f, self.bounds.size.height*0.25f)];
        _price.textAlignment = 0;
        _price.font = [UIFont systemFontOfSize:15];
        _price.textColor = RGBCOLOR(253, 202, 75, 1);
         [self.contentView addSubview:_price];
    }
    return _price;
}
//- (UILabel*)screeningTime{
//    if (!_screeningTime) {
//        _screeningTime = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height*0.8+15, kScreen_Width /2, self.bounds.size.height*0.25)];
//        _screeningTime.text = @"近期场次";
//        _screeningTime.textAlignment = 0;
//        _screeningTime.font = [UIFont systemFontOfSize:14];
//        _screeningTime.textColor = [UIColor lightGrayColor];
//        
//    }
//    return _screeningTime;
//}

- (UILabel*)distance{
    if (!_distance) {
        _distance = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.8, 0, kScreen_Width*0.23, self.bounds.size.height/2)];
        _distance.center = CGPointMake(kScreen_Width*0.8, self.bounds.size.height/2+15);
        _distance.textAlignment = 2;
        _distance.font = [UIFont systemFontOfSize:13];
        _distance.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_distance];
    }
    return _distance;
}
- (UILabel*)otherTicketLabel{
    if (!_otherTicketLabel) {
        _otherTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cinemaName.right, 10, 15, 15)];
        _otherTicketLabel.textAlignment = 1;
        _otherTicketLabel.font = [UIFont systemFontOfSize:13];
        _otherTicketLabel.textColor = [UIColor whiteColor];
        _otherTicketLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_otherTicketLabel];
    }
    return _distance;
}
-(UILabel *)seatLabel{
    if (!_seatLabel) {
        _seatLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.8, 10, 15, 15)];
        _seatLabel.textAlignment = 1;
        _seatLabel.font = [UIFont systemFontOfSize:13];
        _seatLabel.textColor = [UIColor whiteColor];
        _seatLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_seatLabel];
    }
    return _seatLabel;
}
- (void)setModel:(CinemaModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    
    self.cinemaName.text = self.model.cinema_name;

    self.price.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.settle_price] withFont:self.price.font withColor:RGBCOLOR(253, 202, 75, 1) withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:RGBCOLOR(123, 124, 125, 1)];
    if (self.model.minprice == nil) {
        self.price.hidden = YES;
    }
    CGFloat distanceNo = [self.model.distance floatValue]/1000;
    self.distance.text = [NSString stringWithFormat:@"%.2fkm",distanceNo];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
