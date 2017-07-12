//
//  HotMovieScrollView.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HotMovieScrollView.h"
#import "CarouselViewCell.h"
#import "BannerModel.h"

@interface HotMovieScrollView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation HotMovieScrollView

- (instancetype)initWithFrame:(CGRect)frame andDataAry:(NSMutableArray *)dataAry{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.dataArr = dataAry;
        [self setScrollectViewImage];

        
    }
    return self;
}

- (void)setScrollectViewImage{
    for (int i = 0; i<self.dataArr.count; i++) {
    
        UIImageView * pictureImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width*i, 0, kScreen_Width, self.bounds.size.height)];
        pictureImage.tag = 100+i;

        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToDetail:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.delegate = self;
        
        [pictureImage addGestureRecognizer:tapGes];
        pictureImage.userInteractionEnabled = YES;
        BannerModel * model = self.dataArr[i];
        [pictureImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self addSubview:pictureImage];
    }
}
- (void)touchToDetail:(UITapGestureRecognizer*)tap{
    BannerModel * model = self.dataArr[tap.view.tag-100];
    [self.HotDelegate pushToDetailPage:model];
}
- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
