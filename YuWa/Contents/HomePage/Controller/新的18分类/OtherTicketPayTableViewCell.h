//
//  OtherTicketPayTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherTicketModel.h"
@protocol OtherTicketPayTableViewCellDelegate <NSObject>

- (void)reduceOrAddTicket:(NSInteger)status ;//1是加，2是减
- (void)useCouponActionTouch:(UIButton*)sender;
@end
@interface OtherTicketPayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cinemaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//有效期
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *discountMoneyLabel;//优惠金额
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (nonatomic,strong)OtherTicketModel* model;
@property (nonatomic,assign)id<OtherTicketPayTableViewCellDelegate>delegate;
@end




