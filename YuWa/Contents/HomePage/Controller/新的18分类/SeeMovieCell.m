//
//  SeeMovieCell.m
//  YuWa
//
//  Created by double on 17/2/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SeeMovieCell.h"

@implementation SeeMovieCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.picImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detali];
        [self.contentView addSubview:self.sell_price];
        [self.contentView addSubview:self.price];
    }
    return self;
}

-(UIImageView*)picImageView{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreen_Width/4, 50)];
        _picImageView.image = [UIImage imageNamed:@"a1002"];
    }
    return _picImageView;
}

- (UILabel*)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(self.picImageView.width +15, 10, kScreen_Width * 0.3, 60 * 0.2f)];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:14];
        _title.text = @"单人套餐";
    }
    return _title;
}

- (UILabel*)detali{
    if (!_detali) {
        _detali = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 15 + self.title.height, kScreen_Width - 20 -self.picImageView.width, 60 * 0.15f)];
        _detali.textColor = [UIColor lightGrayColor];
        _detali.font = [UIFont systemFontOfSize:10];
        _detali.text = @"爆米花MMMMMMMMMMMMMMM";
    }
    return  _detali;
}
- (UILabel * )sell_price {
    if (!_sell_price) {
        _sell_price = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 60*0.7, 0, 0)];
        _sell_price.textColor = CNaviColor;
        _sell_price.font = [UIFont systemFontOfSize:15];
        _sell_price.text = @"￥30";
        CGSize size = [self sizeWithSt:_sell_price.text font:_sell_price.font];
        
        _sell_price.frame = CGRectMake(self.title.origin.x, 60*0.7, size.width, 60 * 0.2);
    
    }
    return _sell_price;
}

-(UILabel*)price{
    if (!_price) {
        _price = [[UILabel alloc]initWithFrame:CGRectMake(12 + self.picImageView.width + self.sell_price.width +10, self.sell_price.origin.y + 5, kScreen_Width /3, 60 *0.2-5)];
        _price.textColor = [UIColor lightGrayColor];
        _price.font = [UIFont systemFontOfSize:12];
        _price.text = @"影院价:￥45";
    }
    return _price;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (CGSize)sizeWithSt:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(kScreen_Width * 0.6f, kScreen_Height * 0.05f)options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font}context:nil];
    
    return rect.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
