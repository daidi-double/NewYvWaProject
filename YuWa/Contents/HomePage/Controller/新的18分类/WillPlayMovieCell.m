//
//  WillPlayMovieCell.m
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "WillPlayMovieCell.h"
#define selfHeigh self.bounds.size.height

@implementation WillPlayMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.movieImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.introduce];
//        [self.contentView addSubview:self.playTime];
//        [self.contentView addSubview:self.wantLook];
//        [self.contentView addSubview:self.sellBtn];
    }
    return self;
}
- (UIImageView*)movieImageView{
    if (!_movieImageView) {
        _movieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kScreen_Width/4, (selfHeigh-10)*2)];
        _movieImageView.image = [UIImage imageNamed:@"baobaoBG0"];
//        UIImageView * playView = [[UIImageView alloc]initWithFrame:CGRectMake(self.movieImageView.width-30, self.movieImageView.height-30, 25, 25)];
//        playView.image = [UIImage imageNamed:@"play1.png"];
//        [_movieImageView addSubview:playView];
    }
    return _movieImageView;
}
- (UILabel*)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(self.movieImageView.width+10, 15, kScreen_Width/3, selfHeigh*0.2f)];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:15];
        _title.text = @"生化危机";
    }
    return _title;
}
- (UILabel*)introduce{
    if (!_introduce) {
        _introduce = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 25+ selfHeigh*0.2f, kScreen_Width/2, selfHeigh*0.3f)];
        _introduce.textColor = [UIColor lightGrayColor];
        _introduce.font = [UIFont systemFontOfSize:14];
        _introduce.text = @"xxxxxxxxxx";
    }
    return _introduce;
}

- (UILabel*)playTime{
    if (!_playTime) {
        _playTime = [[UILabel alloc]initWithFrame:CGRectMake(self.title.origin.x, 30+selfHeigh*0.5f, kScreen_Width/2, selfHeigh*0.3f)];
        _playTime.textColor = [UIColor darkGrayColor];
        _playTime.font = [UIFont systemFontOfSize:14];
        _playTime.text = @"xxxxxxxxxxxxx";
    }
    return _playTime;
}
//- (UILabel*)wantLook{
//    if (!_wantLook) {
//        _wantLook = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width*0.68f, 15, kScreen_Width*0.3f, selfHeigh/3)];
//        _wantLook.textColor = [UIColor orangeColor];
//        _wantLook.font = [UIFont systemFontOfSize:14];
//        _wantLook.textAlignment = 2;
//        _wantLook.text = @"xxx人想看";
//    }
//    return _wantLook;
//}

//- (UIButton*)sellBtn{
//    if (!_sellBtn) {
//        _sellBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        _sellBtn.frame = CGRectMake(kScreen_Width*0.85f, selfHeigh, kScreen_Width*0.15f, selfHeigh/2);
//        [_sellBtn setTitle:@"预售" forState:UIControlStateNormal];
//        [_sellBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
//        
//        [_sellBtn addTarget:self action:@selector(touchToSell:) forControlEvents:UIControlEventTouchUpInside];
//        [_sellBtn.layer setBorderColor:(__bridge CGColorRef _Nullable)(CNaviColor)];
//    }
//    return _sellBtn;
//}
//- (void)touchToSell:(UIButton*)sender{
//    NSLog(@"还需要代理");
//    [self.delegate pushToSellPage];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
