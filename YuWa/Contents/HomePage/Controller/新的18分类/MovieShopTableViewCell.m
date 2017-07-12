//
//  MovieShopTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieShopTableViewCell.h"

@implementation MovieShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)navBtnAction:(UIButton *)sender {
}
- (void)setCinemaDetailModel:(CinemaDetailModel *)cinemaDetailModel{
    _cinemaDetailModel = cinemaDetailModel;
    [self setData];
    
}

- (void)setData{
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cinemaDetailModel.img_addr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLabel.text = self.cinemaDetailModel.cinema_name;
    self.shopAddressLabel.text = self.cinemaDetailModel.address;
    self.shopIhoneNumberLabel.text = self.cinemaDetailModel.tel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
