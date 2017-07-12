//
//  DetailStorePreferentialTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "DetailStorePreferentialTableViewCell.h"
#import "DetailStorePreferentialModel.h"

@interface DetailStorePreferentialTableViewCell()

@property(nonatomic,strong)UILabel*defaultZheLabel;

@property(nonatomic,strong)NSMutableArray*mAMallDatas;   //所有的model

@property(nonatomic,strong)NSMutableArray*saveAllLabel;
@property(nonatomic,strong)NSMutableArray*saveAllView;

@end

@implementation DetailStorePreferentialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
        
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 15, 15)];
//        imageView.backgroundColor=[UIColor greenColor];
        imageView.image=[UIImage imageNamed:@"home_hui"];
        [self.contentView addSubview:imageView];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(38, 12, 150, 18)];
        titleLabel.text=@"优惠买单";
        titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleLabel];
        
//        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(38, 35, kScreen_Width-38, 1)];
//        lineView.backgroundColor=RGBCOLOR(228, 228, 228, 1);
//        [self.contentView addSubview:lineView];
        
        UILabel*subLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-100-10, 14, 100, 15)];
        subLabel.textAlignment=NSTextAlignmentRight;
        subLabel.font=FONT_CN_24;
        subLabel.textColor=RGBCOLOR(167, 167, 167, 1);
//        subLabel.text=@"已买151";
        [self.contentView addSubview:subLabel];
        self.defaultZheLabel=subLabel;
        

        
  //        NSString*str=array[0];
//        subLabel.text=[NSString stringWithFormat:@"已买%@",str];
        //        [array removeObjectAtIndex:0];
        
        
        
        
        

    }
    
    return self;
}




+(CGFloat)getCellHeightWitharray:(NSMutableArray*)array{
//    [array removeObjectAtIndex:0];
    
    return 45+array.count*35;
}

#pragma mark  -- set

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;

    
    self.mAMallDatas=nil;
    for (NSDictionary*dict in allDatas) {
       DetailStorePreferentialModel*model =[DetailStorePreferentialModel yy_modelWithDictionary:dict];
        [self.mAMallDatas addObject:model];
    }

    
    
    
    
    //先移除
    for (UIView*view in self.saveAllLabel) {
        [view removeFromSuperview];
    }
    for (UIView*view in self.saveAllView) {
        [view removeFromSuperview];
    }
    self.saveAllLabel=nil;
    self.saveAllView=nil;
    
    
    //高为 36 +9    =45
    for (int i=0; i<self.mAMallDatas.count; i++) {
        DetailStorePreferentialModel*model=self.mAMallDatas[i];
        
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(38, 45+i*35, kScreen_Width-76, 18)];
        label.font=FONT_CN_24;
        label.text=[NSString stringWithFormat:@"%@%@",model.title,model.rebate];
        [self.contentView addSubview:label];
        
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 70+i*35, kScreen_Width-10, 1)];
        lineView.backgroundColor=RGBCOLOR(225, 225, 225, 1);
        [self.contentView addSubview:lineView];
        
        if (i==allDatas.count-1) {
            lineView.hidden=YES;
        }
        
    }

    
}

-(void)setDefultZhe:(NSString *)defultZhe{
    _defultZhe=defultZhe;
    NSString*number=[defultZhe substringFromIndex:2];
    
    if ([number integerValue] % 10 == 0) {
        number = [NSString stringWithFormat:@"%ld",[number integerValue]/10];
    }else{
        number = [NSString stringWithFormat:@"%.1f",[number floatValue]/10];
    }

    self.defaultZheLabel.text=[NSString stringWithFormat:@"%@折,闪付立享",number];
    
    
    CGFloat num=[defultZhe floatValue];
    if (num>=1 || num <= 0.00) {
        self.defaultZheLabel.text=@"不打折";
    }
    
}

-(NSMutableArray *)mAMallDatas{
    if (!_mAMallDatas) {
        _mAMallDatas=[NSMutableArray array];
    }
    return _mAMallDatas;
}


-(NSMutableArray *)saveAllView{
    if (!_saveAllView) {
        _saveAllView=[NSMutableArray array];
    }
    
    return _saveAllView;
}

-(NSMutableArray *)saveAllLabel{
    if (!_saveAllLabel) {
        _saveAllLabel=[NSMutableArray array];
    }
 
    return _saveAllLabel;
}


@end
