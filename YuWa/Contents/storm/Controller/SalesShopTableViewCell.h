//
//  SalesShopTableViewCell.h
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *characteristicLabel;//特点列如：24小时供应
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;//类别（甜点）
@property (weak, nonatomic) IBOutlet UIImageView *isHaveUserImageView;//是否已有用户
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@end
