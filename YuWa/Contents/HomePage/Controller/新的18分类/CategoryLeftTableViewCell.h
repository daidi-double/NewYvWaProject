//
//  CategoryLeftTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailGoodsModel.h"
@interface CategoryLeftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shop_imgView;
@property (weak, nonatomic) IBOutlet UILabel *shop_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthPayLabel;//月销售量
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic,strong) NSMutableArray * shopCarAry;
@property (nonatomic,copy)NSString * number;
@property (nonatomic,strong)NSArray * goodsAry;
@property (nonatomic,strong) ShopDetailGoodsModel * model;
@property (nonatomic,assign)void(^addShopBlock)(NSString * price);
@property (nonatomic,assign)void(^reduceShopBlock)(NSString * price);
@property (nonatomic,copy)NSString * goods_id;
@end
