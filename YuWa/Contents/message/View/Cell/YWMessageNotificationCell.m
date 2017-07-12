//
//  YWMessageNotificationCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageNotificationCell.h"

#import "JWTools.h"
@implementation YWMessageNotificationCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(YWMessageNotificationModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.timeLbael.text = [JWTools dateWithStr:self.model.ctime];
    if ([self.model.status isEqualToString:@"3"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@已拒绝您的预定",self.model.shop_name];
 
    }else{
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@已接受您的预定",self.model.shop_name];
    }
    self.iconImageView.image = [UIImage imageNamed:[self.model.status isEqualToString:@"3"]?@"jujue":@"jieshou"];
}

@end
