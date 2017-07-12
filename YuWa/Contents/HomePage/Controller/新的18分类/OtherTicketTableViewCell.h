//
//  OtherTicketTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherTicketModel.h"
@interface OtherTicketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *filmTypeLabel;//2D/3D
@property (weak, nonatomic) IBOutlet UILabel *sellerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;//备注
@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (nonatomic,strong) OtherTicketModel * model;

@end
