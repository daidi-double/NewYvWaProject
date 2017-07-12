//
//  PlayTimeShowTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PlayTimeShowTableViewCell.h"

@implementation PlayTimeShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FilmShowTimeModel *)model{
    _model = model;
    [self setData];
}

- (void)setData{
    self.showTimeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.languageLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.hallNumber.textColor = [UIColor colorWithHexString:@"#999999"];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(8, 0, kScreen_Width-16, 0.5)];
    line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    [self.contentView addSubview:line];
    self.showTimeLabel.text = self.model.showTime;
    self.languageLabel.text = self.model.language;
    self.seller_priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.settle_price];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@散场",self.model.endTime];
    self.hallNumber.text = [NSString stringWithFormat:@"%@",self.model.hall_name];
    if (self.model.hall_name.length == 1) {
     self.hallNumber.text = [NSString stringWithFormat:@"%@号厅",self.model.hall_name];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
