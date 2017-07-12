//
//  ShopPlanFirstTableViewCell.h
//  YuWa
//
//  Created by double on 17/6/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopPlanFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characteristicLabel;//特点列如：24小时供应
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;//类别（甜点）
@property (weak, nonatomic) IBOutlet UIImageView *isHaveUserImageView;//是否已有用户
@property (weak, nonatomic) IBOutlet UIImageView *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *shopIntroduceLabel;//商家介绍
@property (weak, nonatomic) IBOutlet UILabel *introLabel;//商家介绍内容
@property (weak, nonatomic) IBOutlet UIView *shopNameBGView;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;//当前价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *lookPeopleNumberLabel;//围观人数
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;//起拍价
@property (weak, nonatomic) IBOutlet UILabel *cautionMoneyLabel;//保证金
@property (weak, nonatomic) IBOutlet UILabel *geiPriceNumberLabel;//出价次数
@property (weak, nonatomic) IBOutlet UIView *sellerIntroBGView;
@property (weak, nonatomic) IBOutlet UIView *infoBGView;



@end
