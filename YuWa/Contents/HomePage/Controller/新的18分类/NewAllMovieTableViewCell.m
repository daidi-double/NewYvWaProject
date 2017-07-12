//
//  NewAllMovieTableViewCell.m
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewAllMovieTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"


@implementation NewAllMovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyBtn.layer.borderColor = CNaviColor.CGColor;
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.cornerRadius = 5;
    [self.buyBtn.layer setMasksToBounds:YES];
    
    self.showTypeLabel.layer.cornerRadius = 3;
    self.showTypeLabel.layer.masksToBounds = YES;
    
    
}

- (void)setModel:(HotMovieModel *)model{
    _model = model;
    [self setCellData];
}
-(void)setCellData{
    
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.movieNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.movieNameLabel.text = self.model.name;
    NSArray*scores=[self.model.score componentsSeparatedByString:@"."];
    
    if (scores.count>=2) {
        
        self.scoreLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@.",scores[0]] withFont:[UIFont systemFontOfSize:15] withColor:[UIColor colorWithHexString:@"#ff7800"] withSecondtStr:[NSString stringWithFormat:@"%@",scores[1]] withFont:[UIFont systemFontOfSize:13] withColor:[UIColor colorWithHexString:@"#ff7800"]];
    }else{
        self.scoreLabel.text = [NSString stringWithFormat:@"%@",self.model.score];
    }
    self.showTypeLabel.text = self.model.showtypes;
    self.filmCountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.filmCountLabel.text = [NSString stringWithFormat:@"今日%@家%@场",self.model.cinema_count,self.model.cinema_film_count];
    if (self.model.cinema_count == nil && self.model.cinema_film_count == nil){
        self.filmCountLabel.text = @"今日-/-家-/-场";
    }else if (self.model.cinema_film_count == nil) {
        self.filmCountLabel.text = [NSString stringWithFormat:@"今日%@家-/-场",self.model.cinema_count];
    }else if (self.model.cinema_count == nil){
        self.filmCountLabel.text = [NSString stringWithFormat:@"今日-/-家%@场",self.model.cinema_film_count];
    }
    self.introduceLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.introduceLabel.text = self.model.highlight;
    self.buyBtn.hidden= NO;
    self.showTypeLabel.hidden = NO;
    self.scoreLabel.hidden = NO;
    if (self.status == 1) {
        self.showTypeLabel.hidden = YES;
        self.scoreLabel.hidden = YES;
        NSString * publishDate = [JWTools getTime:self.model.publish_date];
        self.filmCountLabel.text= [NSString stringWithFormat:@"%@上映",publishDate];
        [self.buyBtn setTitle:@"预售" forState:UIControlStateNormal];
        if ([self.model.isCF isEqualToString:@"0"]) {
            self.buyBtn.hidden = YES;
        }
        
        
    }else{
        
        [self.buyBtn setTitle:@"购票" forState:UIControlStateNormal];
        
    }
}
- (IBAction)toBuyTicketAction:(UIButton *)sender {
    [self.deletage toBuyTicket:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
