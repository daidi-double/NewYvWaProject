//
//  MoviePayTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MoviePayTableViewCell.h"

@implementation MoviePayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDataAry:(NSMutableArray *)dataAry{
    [_dataAry removeAllObjects];
    _dataAry= dataAry;
    [self setData];
}

- (void)setData{
    
    self.movieNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.cinemaNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.playTimeLabel.textColor = [UIColor colorWithHexString:@"#4b95dd"];
    self.seatNumberLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.movieNameLabel.text = self.dataAry[3];
    //价格放映类型（1：2D 2：3D 3：MAX2D 4：MAX3D 6：DMAX）
    NSString * showType;
    switch ([self.dataAry[7] integerValue]) {
        case 1:
            showType = @"2D";
            break;
        case 2:
            showType = @"3D";
            break;
        case 3:
            showType = @"MAX2D";
            break;
        case 4:
            showType = @"MAX3D";
            break;
        default:
            showType = @"DMAX";
            break;
    }
    self.playTimeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.dataAry[4],self.dataAry[6],showType];//05月25日00：00 中文 2D
    self.cinemaNameLabel.text = self.dataAry[5];
    NSMutableArray * seatAry = [NSMutableArray array];
    for (NSDictionary * dict in self.dataAry[8]) {
        NSString * seat = dict[@"seatNumber"];
        [seatAry addObject:seat];
    }
    switch (seatAry.count) {
        case 1:
            self.seatNumberLabel.text = [NSString stringWithFormat:@"%@-%@",self.dataAry[0],seatAry[0]];
            
            break;
        case 2:
            self.seatNumberLabel.text = [NSString stringWithFormat:@"%@-%@ %@",self.dataAry[0],seatAry[0],seatAry[1]];
            
            break;
        case 3:
            self.seatNumberLabel.text = [NSString stringWithFormat:@"%@-%@ %@ %@",self.dataAry[0],seatAry[0],seatAry[1],seatAry[2]];
            
            break;
            
        default:
           self.seatNumberLabel.text = [NSString stringWithFormat:@"%@-%@ %@ %@ %@",self.dataAry[0],seatAry[0],seatAry[1],seatAry[2],seatAry[3]];

            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
