//
//  StoreDescriptionTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "StoreDescriptionTableViewCell.h"

@interface StoreDescriptionTableViewCell()
@property(nonatomic,strong)NSMutableArray*saveAllLabel;

@end

@implementation StoreDescriptionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _saveAllLabel=[NSMutableArray array];
        UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 32)];
        [self.contentView addSubview:BGView];
//
        UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 5, 20, 20)];
        iconImageView.image = [UIImage imageNamed:@"商家详情"];
        [BGView addSubview:iconImageView];
        UILabel*shopLabel=[[UILabel alloc]initWithFrame:CGRectMake(46, 0, kScreen_Width-30, 30)];
        shopLabel.text=@"商家详情";
        shopLabel.textColor = RGBCOLOR(112, 112, 112, 1);
        shopLabel.font=[UIFont systemFontOfSize:14];
        [BGView addSubview:shopLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, shopLabel.bottom+2, kScreen_Width, 0.5)];
        line.backgroundColor = RGBCOLOR(240, 245, 244, 1);
        [self.contentView addSubview:line];
     
    }
    
    return self;
}



-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    
    for (UIView*view in self.saveAllLabel) {
        [view removeFromSuperview];
    }
    self.saveAllLabel=[NSMutableArray array];
    
    
    
    CGFloat topPoint =32.5;
    for (int i=0; i<allDatas.count; i++) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(46, topPoint, kScreen_Width-15, 30)];
        label.text=allDatas[i];
        label.font=FONT_CN_24;
        label.textColor = RGBCOLOR(135, 136, 137, 1);
        [self.contentView addSubview:label];
        [self.saveAllLabel addObject:label];
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, topPoint+32, kScreen_Width, 1)];
        line.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        [self.contentView addSubview:line];
        [self.saveAllLabel addObject:line];
        topPoint = topPoint+33;
        if (i != allDatas.count-1) {
            line.hidden = YES;
        }
    }

    
}


+(CGFloat)getHeight:(NSArray*)array{
    
    NSInteger aa=array.count;
    return 32.5+33*aa;
  
}

@end
