//
//  NewHotMovieCollectCell.m
//  YuWa
//
//  Created by double on 17/5/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewHotMovieCollectCell.h"

@implementation NewHotMovieCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(HotMovieModel *)model{
    _model = model;
    [self setdata];
}
-(void)setdata{
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.movieNameLabel.text = self.model.name;
    self.movieScoreLabel.text = self.model.score;
    
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber1=self.model.score;
    CGFloat totalScroe = [starNmuber1 floatValue]/2;
    NSString *starNmuber = [NSString stringWithFormat:@"%.2f",totalScroe];
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>=0.75) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<0.25){
        realXiaoshu=0;
    }else{
        realXiaoshu=0.5;
        
    }
    
    for (int i=40; i<45; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        if (imageView.tag-40<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-40==realZhengshu&&realXiaoshu<0.75 && realXiaoshu >=0.25){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }
    
    //---------------------------------------------------------------------------
    

}
@end
