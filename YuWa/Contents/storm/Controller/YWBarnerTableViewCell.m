//
//  YWBarnerTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBarnerTableViewCell.h"

@implementation YWBarnerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.picImageView];
        
    }
    return self;
}
- (UIImageView *)picImageView{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*352/1334)];
        _picImageView.image = [UIImage imageNamed:@"baobaoBG1"];
    }
    return _picImageView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
