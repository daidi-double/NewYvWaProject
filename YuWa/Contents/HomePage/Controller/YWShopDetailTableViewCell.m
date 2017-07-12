//
//  YWShopDetailTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopDetailTableViewCell.h"

@implementation YWShopDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ShopdetailModel *)model{
    _model = model;
    [self setInfo];
}
- (void)setInfo{
    [self.shopIconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.company_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLabel.text = self.model.company_name;
    self.scoreLabel.text = self.model.star;
    self.monthPayNumberLabel.text = [NSString stringWithFormat:@"月售%@单",self.model.monthSale];
    self.addressLabel.text = self.model.company_near;
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber=self.model.star;
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=40; i<45; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        if (imageView.tag-40<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-40==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
