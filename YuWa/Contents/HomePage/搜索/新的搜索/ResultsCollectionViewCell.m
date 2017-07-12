//
//  ResultsCollectionViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ResultsCollectionViewCell.h"
#import "ResultsModel.h"

@implementation ResultsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.numberOfLines = 1;
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        _firstLabel.font = [UIFont systemFontOfSize:12.0f];
        _firstLabel.textColor = RGBCOLOR(191, 191, 191, 1);
        _firstLabel.layer.borderWidth = 1.0f;
        _firstLabel.layer.borderColor = RGBCOLOR(191, 191, 191, 1).CGColor;
        _firstLabel.layer.cornerRadius = 5.0f;
        _firstLabel.clipsToBounds = YES;
        [self.contentView addSubview:_firstLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size=[_firstLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-60, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    self.firstLabel.frame=CGRectMake(0, 0, size.width+16, size.height+8);
    CGRect contentViewFrame=self.contentView.frame;
    contentViewFrame.size=self.firstLabel.size;
    self.contentView.frame=contentViewFrame;
    
    CGRect selfFrame=self.frame;
    selfFrame.size=self.firstLabel.size;
    self.frame=selfFrame;
}


-(void)cellModel:(ResultsModel *)model{
    self.firstLabel.text=model.title;
    
}

@end
