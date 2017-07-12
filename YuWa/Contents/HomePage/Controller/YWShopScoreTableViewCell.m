//
//  YWShopScoreTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopScoreTableViewCell.h"

@implementation YWShopScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTotalScore:(NSString *)totalScore{
    _totalScore = totalScore;
    [self setscore];
}

-(void)setscore{
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber=self.totalScore;
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=50; i<55; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        if (imageView.tag-50<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-50==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }
    self.shopScoreLabel.text = self.totalScore;
    self.totalScoreLabel.text = self.totalScore;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
