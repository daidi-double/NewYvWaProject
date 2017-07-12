//
//  YWNewShopInfoTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNewShopInfoTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
@implementation YWNewShopInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (void)setModel:(YWShopInfoListModel *)model{
    _model = model;
    [self setDataForCell];
}
-(void)setCart:(NSArray *)cart{
    _cart = cart;
    
}
- (void)setDataForCell{
    self.shopNameLabel.text = self.shopName;
    self.shop_id = self.model.shop_id;

    NSArray*specail=self.cart;
    CGFloat top = 40.0;
    CGFloat left = 13.0;
    //首先移除所有的东西
    for (UIView*view in self.saveAllImage) {
        [view removeFromSuperview];
    }
    
    for (UIView*view2 in self.saveAllLabel) {
        [view2 removeFromSuperview];
    }
    if (specail.count>0) {
        for (int i=0; i<specail.count; i++) {
            YWShopInfoListModel * listModel = self.dataAry[i];
            UIImageView*speImage=[self viewWithTag:100+i];
            speImage.width = kScreen_Width/7;
            speImage.height = speImage.width;
            if (!speImage) {
                speImage=[[UIImageView alloc]initWithFrame:CGRectMake(left, top, kScreen_Width/7, kScreen_Width/7)];
                speImage.tag=10+i;
            }
            [self.contentView addSubview:speImage];
            [self.saveAllImage addObject:speImage];
            [speImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",listModel.goods_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            UILabel*shopNameLabel=[self viewWithTag:200+i];
            if (!shopNameLabel) {
                shopNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(left+kScreen_Width /7+15, top, kScreen_Width-110, kScreen_Width/7 *0.6f)];
                
                shopNameLabel.font=[UIFont systemFontOfSize:15];
                shopNameLabel.textColor = RGBCOLOR(41, 42, 43, 1);
                shopNameLabel.tag=200+i;
                
            }
            shopNameLabel.text = listModel.goods_name;
            [self.contentView addSubview:shopNameLabel];
            [self.saveAllLabel addObject:shopNameLabel];
            
            UILabel*shopNumberLabel=[self viewWithTag:300+i];
            if (!shopNumberLabel) {
                shopNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(left+kScreen_Width /7+15, top + kScreen_Width/7*0.6f, 100, kScreen_Width/7*0.4f)];
                shopNumberLabel.font=[UIFont systemFontOfSize:13];
                shopNumberLabel.textColor = RGBCOLOR(141, 142, 143, 1);
                shopNumberLabel.tag=300+i;
                
            }
            shopNumberLabel.text = [NSString stringWithFormat:@"x%@",listModel.goods_num];
            [self.contentView addSubview:shopNumberLabel];
            [self.saveAllLabel addObject:shopNumberLabel];
            
            UILabel*newPriceLaber=[self viewWithTag:500+i];
            NSString * price;
            NSString * total;
            if ([listModel.goods_disprice floatValue] == 0.00 || listModel.goods_disprice == nil || [listModel.goods_disprice isKindOfClass:[NSNull class]]) {
                
                price = listModel.goods_price;
                
            }else{
                price = listModel.goods_disprice;
                
            }
            total = [NSString stringWithFormat:@"%.2f",[price floatValue] * [listModel.goods_num  floatValue]];
            if (!newPriceLaber) {
                newPriceLaber=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 15, top + 30, 100, 20)];
                newPriceLaber.font=[UIFont systemFontOfSize:13];
                newPriceLaber.textColor = RGBCOLOR(141, 142, 143, 1);
                newPriceLaber.tag=500+i;
                
            }
            newPriceLaber.attributedText = [NSString stringWithFirstStr:@"￥" withFont:[UIFont systemFontOfSize:15.f] withColor:RGBCOLOR(255, 152, 125, 1) withSecondtStr:[NSString stringWithFormat:@"%@",total]  withFont:[UIFont systemFontOfSize:15.f] withColor:RGBCOLOR(255, 152, 125, 1)];
            CGRect shopNameWidth = [newPriceLaber.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kScreen_Width/7* 0.6f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: newPriceLaber.font} context:nil];
            newPriceLaber.frame= CGRectMake(kScreen_Width - shopNameWidth.size.width -15, top + 30, shopNameWidth.size.width , kScreen_Width/7* 0.6f);
            
            [self.contentView addSubview:newPriceLaber];
            [self.saveAllLabel addObject:newPriceLaber];
            
            UILabel*oldPriceLaber=[self viewWithTag:400+i];
            if (!oldPriceLaber) {
                oldPriceLaber=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width - 15, top + 30, 100, kScreen_Width/7* 0.4f)];
                oldPriceLaber.font=[UIFont systemFontOfSize:13];
                oldPriceLaber.textColor = RGBCOLOR(141, 142, 143, 1);
                oldPriceLaber.tag=400+i;
                
            }
            NSString * str = [NSString stringWithFormat:@"￥%@",listModel.goods_price];
            NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:str];
            [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,str.length)];
            
            oldPriceLaber.attributedText = attributeMarket;
            
            CGRect shopNameOldWidth = [oldPriceLaber.text boundingRectWithSize:CGSizeMake(MAXFLOAT, newPriceLaber.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: oldPriceLaber.font} context:nil];
            oldPriceLaber.frame= CGRectMake(kScreen_Width - shopNameOldWidth.size.width-25 -newPriceLaber.frame.size.width, top + 30, shopNameOldWidth.size.width , newPriceLaber.height);
            
            [self.contentView addSubview:oldPriceLaber];
            [self.saveAllLabel addObject:oldPriceLaber];
            
            if ([listModel.goods_disprice floatValue] == 0.00 || listModel.goods_disprice == nil || [listModel.goods_disprice isKindOfClass:[NSNull class]]) {
                
                oldPriceLaber.hidden = YES;
                
            }
            
            top=top+kScreen_Width/7+25;
//            NSString * money = [newPriceLaber.text substringFromIndex:1];
//            totalMoney = totalMoney + [money floatValue];
            
        }
//        NSString * totalMoneyStr = [NSString stringWithFormat:@"%.2f",totalMoney];
//        if (totalMoney == 0.00) {
//            totalMoneyStr = @"0";
//        }
//        self.totalMoneyLabel.attributedText = [NSString stringWithFirstStr:@"合计￥" withFont:self.totalMoneyLabel.font withColor:RGBCOLOR(123, 124, 125, 1) withSecondtStr:totalMoneyStr withFont:self.totalMoneyLabel.font withColor:[UIColor colorWithHexString:@"#fe8238"]];
//    }else{
//        
    }
    
}
+ (CGFloat)getHeight:(NSArray *)array{
    NSInteger aa=array.count;
    return 35+(kScreen_Width/7+20)*aa + 50 ;
}
- (IBAction)goToAccountAction:(UIButton *)sender {
//    NSString * money = [self.totalMoneyLabel.text substringFromIndex:3];
//    [self.delegate goToAccount:money andBtn:sender];
    
}
-(NSMutableArray *)saveAllImage{
    if (!_saveAllImage) {
        _saveAllImage=[NSMutableArray array];
    }
    return _saveAllImage;
    
}

-(NSMutableArray *)saveAllLabel{
    if (!_saveAllLabel) {
        _saveAllLabel=[NSMutableArray array];
    }
    return _saveAllLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
