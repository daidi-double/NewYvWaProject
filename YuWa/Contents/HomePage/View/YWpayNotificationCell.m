//
//  YWpayNotificationCell.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWpayNotificationCell.h"
#import "JWTools.h"

@interface YWpayNotificationCell ()
@property (weak, nonatomic) IBOutlet UILabel *isPay;
@property (weak, nonatomic) IBOutlet UILabel *payCount;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end
@implementation YWpayNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(YWMessageNotificationModel *)model{
    _model = model;
    self.isPay.text = model.title;
    self.time.text = [JWTools dateWithOutYearStr:self.model.ctime];
    self.payCount.text = [NSString stringWithFormat:@"¥%@",model.content];
}
@end
