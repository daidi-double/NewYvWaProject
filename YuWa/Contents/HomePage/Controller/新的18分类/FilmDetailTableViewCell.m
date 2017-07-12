//
//  FilmDetailTableViewCell.m
//  YuWa
//
//  Created by double on 17/6/6.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "FilmDetailTableViewCell.h"

@implementation FilmDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.ctype != 0) {

        if (self.ctype == 1) {
            self.goodBtn.selected = YES;
            self.badBtn.selected = NO;
            [self.badBtn setUserInteractionEnabled:NO];
            [self.goodBtn setUserInteractionEnabled:YES];
        }else{
            self.goodBtn.selected = NO;
            self.badBtn.selected = YES;
            [self.badBtn setUserInteractionEnabled:YES];
            [self.goodBtn setUserInteractionEnabled:NO];
        }
    }else{
        [self.badBtn setUserInteractionEnabled:YES];
        [self.goodBtn setUserInteractionEnabled:YES];
    }

    
}
- (void)setFilmNo:(NSString *)filmNo{
    _filmNo = filmNo;
    self.likeLabel.text = [NSString stringWithFormat:@"%@%%喜欢",self.present_like];
    if (self.ctype != 0) {

        if (self.ctype == 1) {
            self.goodBtn.selected = YES;
            self.badBtn.selected = NO;
            [self.badBtn setUserInteractionEnabled:NO];
            [self.goodBtn setUserInteractionEnabled:YES];
        }else{
            self.goodBtn.selected = NO;
            self.badBtn.selected = YES;
            [self.badBtn setUserInteractionEnabled:YES];
            [self.goodBtn setUserInteractionEnabled:NO];
        }
    }else{
        [self.badBtn setUserInteractionEnabled:YES];
        [self.goodBtn setUserInteractionEnabled:YES];
    }
}
- (void)setCtype:(NSInteger)ctype{
    _ctype = ctype;

}
//吐槽
- (IBAction)badAction:(UIButton *)sender {
    self.type = 2;
    if (!sender.selected) {
        self.ctype = 1;
         [self.goodBtn setUserInteractionEnabled:NO];
    }else{
        self.ctype = 2;
         [self.goodBtn setUserInteractionEnabled:YES];
    }
    [self goodData:sender];
}
//赞一下
- (IBAction)goodAction:(UIButton *)sender {
    
    self.type = 1;
    if (!sender.selected) {
        self.ctype = 1;
         [self.badBtn setUserInteractionEnabled:NO];
    }else{
        self.ctype = 2;
        [self.badBtn setUserInteractionEnabled:YES];
    }
     [self goodData:sender];
}
-(void)goodData:(UIButton*)sender{
    NSString * uslStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_FILMDETAIL];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"film_code":self.filmNo,@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"ctype":@(self.ctype),@"type":@(self.type)};
    HttpManager*manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:uslStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragrams);
        MyLog(@"吐槽、点赞%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            sender.selected = !sender.selected;

        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
