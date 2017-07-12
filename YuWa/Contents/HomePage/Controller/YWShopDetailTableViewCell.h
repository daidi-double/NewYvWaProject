//
//  YWShopDetailTableViewCell.h
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopdetailModel.h"
@interface YWShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopIconView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthPayNumberLabel;
@property (nonatomic,strong) ShopdetailModel * model;

@end
