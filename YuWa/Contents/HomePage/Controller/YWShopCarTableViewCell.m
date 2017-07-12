//
//  YWShopCarTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCarTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation YWShopCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setModel:(ShopDetailGoodsModel *)model{
    _model = model;
    [self setshopInfo];
}
-(void)setshopInfo{
    self.goods_id = self.model.goods_id;
    self.shopNameLabel.text = self.model.goods_name;
    NSString * price;
    
    if ([self.model.goods_disprice floatValue] == 0.00) {
        
        price = self.model.goods_price;
    }else{
        price = self.model.goods_disprice;
    }
    NSString * num;
    if ([self.model.number floatValue] == 0.00) {
        
        num = self.model.goods_num;
    }else{
        num = self.model.number;
    }
    CGFloat shopTotalPrice = [price floatValue] * [num integerValue];
    self.priceLabel.attributedText = [NSString stringWithFirstStr:@"￥" withFont:[UIFont systemFontOfSize:12.f] withColor:RGBCOLOR(255, 152, 125, 1) withSecondtStr:[NSString stringWithFormat:@"%.2f",shopTotalPrice] withFont:[UIFont systemFontOfSize:15.f] withColor:RGBCOLOR(255, 152, 125, 1)];
    self.numbelLabel.text = num;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addShop1" object:nil userInfo:@{@"button": sender}];
}
- (IBAction)reduceAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reduceShop1" object:nil userInfo:@{@"button": sender}];
}
-(void)dealloc  {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
