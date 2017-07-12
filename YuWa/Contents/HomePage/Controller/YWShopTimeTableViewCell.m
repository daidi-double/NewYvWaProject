//
//  YWShopTimeTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopTimeTableViewCell.h"
#import "YWTimeModel.h"
@implementation YWShopTimeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _saveAllLabel=[NSMutableArray array];
        UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 32)];
        [self.contentView addSubview:BGView];
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 20, 20)];
        iconImageView.image = [UIImage imageNamed:@"营业时间"];
        [BGView addSubview:iconImageView];
        UILabel*shopLabel=[[UILabel alloc]initWithFrame:CGRectMake(46, 0, kScreen_Width-30, 30)];
        shopLabel.text=@"营业时间";
        shopLabel.textColor = RGBCOLOR(112, 112, 112, 1);
        shopLabel.font=[UIFont systemFontOfSize:14];
        [BGView addSubview:shopLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, shopLabel.bottom+2, kScreen_Width, 0.5)];
        line.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        [self.contentView addSubview:line];
        
    }
    
    return self;
}



-(void)setTimes:(NSArray *)times{
    _times=times;
    for (UIView*view in self.saveAllLabel) {
        [view removeFromSuperview];
    }
    self.saveAllLabel=[NSMutableArray array];
    
    
    
    CGFloat topPoint =32.5;
    for (int i=0; i<times.count; i++) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(46, topPoint, kScreen_Width-15, 30)];
        NSDictionary * dict = times[i];
        NSDictionary * timeDict = dict[@"time"];
        YWTimeModel * model = [YWTimeModel yy_modelWithJSON:timeDict];
    
        label.text=[NSString stringWithFormat:@"%@",model.name];
        label.font=FONT_CN_24;
        CGRect shopNameWidth = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: label.font} context:nil];
        label.frame= CGRectMake(46, topPoint, shopNameWidth.size.width , 30);
        label.textColor = RGBCOLOR(135, 136, 137, 1);
        [self.contentView addSubview:label];
        [self.saveAllLabel addObject:label];
        
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, label.frame.origin.y, kScreen_Width -20 - label.size.width, 30)];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.textColor = label.textColor;
        timeLabel.text = model.time;
        [self.contentView addSubview:timeLabel];
        [self.saveAllLabel addObject:timeLabel];
        
        UILabel * dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, topPoint+32, kScreen_Width-30, 30)];
        dayLabel.text = model.payDays;
        dayLabel.textColor = timeLabel.textColor;
        dayLabel.font = timeLabel.font;
        [self.contentView addSubview:dayLabel];
        [self.saveAllLabel addObject:dayLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, topPoint+62, kScreen_Width-30, 0.5)];
        line.backgroundColor = RGBCOLOR(243, 244, 245, 1);
        [self.contentView addSubview:line];
        [self.saveAllLabel addObject:line];
        topPoint = topPoint+63;
        if (i == times.count-1) {
            line.hidden = YES;
        }
    }
    
    
}


+(CGFloat)getHeight:(NSArray*)array{
    
    NSInteger aa=array.count;
    return 32.5+63*aa;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
