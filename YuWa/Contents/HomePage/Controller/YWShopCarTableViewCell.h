//
//  YWShopCarTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailGoodsModel.h"
@interface YWShopCarTableViewCell : UITableViewCell
@property (nonatomic,strong)ShopDetailGoodsModel * model;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbelLabel;
@property(nonatomic,strong)NSString*goods_id;
@end
