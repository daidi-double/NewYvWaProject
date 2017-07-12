//
//  PlayMovieCell.m
//  YuWa
//
//  Created by double on 17/2/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PlayMovieCell.h"

@implementation PlayMovieCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.movieImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.playTime];
    }
    return self;
}
- (UIImageView*)movieImageView{
    if (!_movieImageView) {
        
    _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, self.width/3, self.height * 0.9f)];
    _movieImageView.image = [UIImage imageNamed:@"a1000"];
    }
    return _movieImageView;
    
}
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(15 + self.movieImageView.width, 10, kScreen_Width - self.movieImageView.width -20,self.height/4 )];
        _title.text = @"预告片";
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}
- (UILabel*)playTime{
    if (!_playTime) {
        _playTime = [[UILabel alloc]initWithFrame:CGRectMake(self.title.x, 15 + self.height/4, self.title.width, self.height/5)];
        _playTime.textColor = [UIColor lightGrayColor];
        _playTime.text = @"时长";
        _playTime.font = [UIFont systemFontOfSize:10];
    }
    return _playTime;
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
