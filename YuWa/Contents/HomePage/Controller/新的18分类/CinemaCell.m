//
//  CinemaCell.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CinemaCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation CinemaCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}
- (void)setModel:(HomeCinemaListModel *)model{
    _model = model;
    [self setData];
}

-(void)setData{
    self.cinemaName.text = self.model.cinema_name;
        self.price.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"￥%@",self.model.minprice] withFont:self.price.font withColor:RGBCOLOR(253, 202, 75, 1) withSecondtStr:@"起" withFont:[UIFont systemFontOfSize:13] withColor:RGBCOLOR(123, 124, 125, 1)];    if (self.model.minprice == nil) {
        self.price.hidden = YES;
    }
    CGFloat distanceNo = [self.model.distance floatValue] /1000;

    self.distance.text = [NSString stringWithFormat:@"%.2fkm",distanceNo];
    
}
- (UILabel*)cinemaName{
    if (!_cinemaName) {
        _cinemaName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreen_Width*0.8, self.bounds.size.height/2)];
        _cinemaName.textColor = RGBCOLOR(112, 114, 113, 1);
        _cinemaName.textAlignment = 0;
        _cinemaName.font = [UIFont systemFontOfSize:15];
        _cinemaName.text = @"";
         [self addSubview:self.cinemaName];
    }
    return _cinemaName;
}

- (UILabel*)price{
    if (!_price) {
        _price = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cinemaName.height+15, kScreen_Width*0.4f, self.bounds.size.height*0.25f)];
        _price.textAlignment = 0;
        _price.font = [UIFont systemFontOfSize:13];
        _price.textColor = RGBCOLOR(255, 196, 15, 1);
        _price.text = @"";
         [self addSubview:self.price];
    }
    return _price;
}
//- (UILabel*)discount{
//    if (!_discount) {
//        _discount = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height*0.8+15, kScreen_Width /2, self.bounds.size.height*0.25)];
//        _discount.text = @"更优惠";
//        _discount.textAlignment = 0;
//        _discount.font = [UIFont systemFontOfSize:12];
//        _discount.textColor = [UIColor lightGrayColor];
//
//    }
//    return _discount;
//}

- (UILabel*)distance{
    if (!_distance) {
        _distance = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.6-15, 0, kScreen_Width*0.4, self.bounds.size.height/2)];
        _distance.center = CGPointMake(kScreen_Width*0.8, self.bounds.size.height/2+15);
        _distance.text = @"";
        _distance.textAlignment = 2;
        _distance.font = [UIFont systemFontOfSize:13];
        _distance.textColor = RGBCOLOR(112, 113, 114, 1);
        
        [self addSubview:self.distance];
    }
    return _distance;
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
