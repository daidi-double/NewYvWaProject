//
//  PlayTimeCell.m
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PlayTimeCell.h"

@implementation PlayTimeCell
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataArray:(NSMutableArray *)ary{
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//       
//    }
//    return self;
//}

- (UILabel*)beginTime{
    if (!_beginTime) {
        _beginTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreen_Width/5, self.height/2)];
        _beginTime.textColor = [UIColor blackColor];
        _beginTime.font = [UIFont systemFontOfSize:15];
        
    }
    return _beginTime;
}

- (UILabel*)language{
    if (!_language) {
        _language = [[UILabel alloc]initWithFrame:CGRectMake(20 + self.beginTime.width, 10, kScreen_Width/5, self.height/2-10)];
        _language.textColor = [UIColor blackColor];
        _language.font = [UIFont systemFontOfSize:13];
       
    }
    return _language;
}
- (UILabel*)endTimeAndPlace{
    if (!_endTimeAndPlace) {
        _endTimeAndPlace = [[UILabel alloc]initWithFrame:CGRectMake(10,self.beginTime.height+5, kScreen_Width*2/5, self.height/3)];
        _endTimeAndPlace.textColor = [UIColor lightGrayColor];
        _endTimeAndPlace.font = [UIFont systemFontOfSize:12];
        
    }
    return _endTimeAndPlace;
}
-(UILabel*)sell_price{
    if (!_sell_price) {
        _sell_price = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.6f, 10, kScreen_Width/5, self.height/3)];
        _sell_price.textColor = CNaviColor;
        _sell_price.centerY = self.height/2;
        _sell_price.font = [UIFont systemFontOfSize:15];
        _sell_price.textAlignment = 2;

    }
    return _sell_price;

}

- (UILabel*)price{
    if (!_price) {
        _price = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.6f, self.height/2, kScreen_Width/4, self.height/3)];
        _price.textColor = [UIColor lightGrayColor];
        _price.font = [UIFont systemFontOfSize:12];

    }
    return _price;
}

- (void)setModel:(FilmShowTimeModel *)model{
    _model = model;
    
}
- (void)setData{
    [self.contentView addSubview:self.beginTime];
    [self.contentView addSubview:self.endTimeAndPlace];
    [self.contentView addSubview:self.language];
    
    //        [self.contentView addSubview:self.price];
    [self.contentView addSubview:self.sell_price];
    
    
    
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
