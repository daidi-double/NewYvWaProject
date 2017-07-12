//
//  PhotoScalView.m
//  YuWa
//
//  Created by double on 17/6/7.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PhotoScalView.h"

@implementation PhotoScalView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
-(void)setTotalNum:(NSString *)totalNum{
    _totalNum = totalNum;
}
-(void)setCurrentNum:(NSInteger)currentNum{
    _currentNum = currentNum;
}
- (void)setImageAry:(NSArray *)imageAry{
    _imageAry = imageAry;
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self setData];
}

- (void)setData{
    [self addSubview:self.BGView];
    NSURL * url = [NSURL URLWithString:_imageUrl];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.strLabel.text = [NSString stringWithFormat:@"%ld/%@",self.currentNum,self.totalNum];

   
}
//-(void)layoutIfNeeded{
//    __block CGFloat itemW = kScreen_Width;
//    __block CGFloat itemH = 0;
//    
//    
//    NSURL * url = [NSURL URLWithString:_imageUrl];
//
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
//    UIImage * image;
//    if (existBool) {
//        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//    }else{
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        image = [UIImage imageWithData:data];
//    }
//    
//    //根据image的比例来设置高度
//    if (image.size.width) {
//        itemH = image.size.height / image.size.width * itemW;
//        
//        if (itemH >= itemW) {
//            itemW = kScreen_Width;
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    }
//
//}

- (void)cancelBGView:(UITapGestureRecognizer*)tap{
    self.hidden = YES;
}

- (void)Swipe:(UISwipeGestureRecognizer*)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSURL * url = [NSURL URLWithString:self.imageAry[self.currentNum]];
//        [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.imageView.image= self.dataAry[self.currentNum];
        self.strLabel.text = [NSString stringWithFormat:@"%ld/%@",self.currentNum +1,self.totalNum];
        self.currentNum++;
        if (self.currentNum==self.imageAry.count) {
            self.currentNum = self.imageAry.count-1;
        }
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.currentNum--;
        if (self.currentNum<=0) {
            self.currentNum = 0;
        }
//        NSURL * url = [NSURL URLWithString:self.imageAry[self.currentNum]];
//        [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.imageView.image= self.dataAry[self.currentNum];
        self.strLabel.text = [NSString stringWithFormat:@"%ld/%@",self.currentNum+1,self.totalNum];
        
    }
}

- (UIView*)BGView{
    if (!_BGView) {
        _BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _BGView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer * cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBGView:)];
        cancelTap.numberOfTapsRequired = 1;
        cancelTap.numberOfTouchesRequired = 1;
        cancelTap.delegate = self;
        [_BGView addGestureRecognizer:cancelTap];
        
        UISwipeGestureRecognizer * left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipe:)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [_BGView addGestureRecognizer:left];
        
        UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipe:)];
        right.direction = UISwipeGestureRecognizerDirectionRight;
        [_BGView addGestureRecognizer:right];
    }
    return _BGView;
}
-(UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
        _imageView.centerY = kScreen_Height/2-64;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBGView:)];
        cancelTap.numberOfTapsRequired = 1;
        cancelTap.numberOfTouchesRequired = 1;
        cancelTap.delegate = self;
        [_imageView addGestureRecognizer:cancelTap];

        [self.BGView addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)strLabel{
    if (!_strLabel) {
        _strLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom, 50, 50)];
        _strLabel.textColor = [UIColor whiteColor];
        _strLabel.centerX = kScreen_Width/2;
        _strLabel.textAlignment = 1;
        _strLabel.font = [UIFont systemFontOfSize:14];
        [self.BGView addSubview:_strLabel];
    }
    return _strLabel;
}
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
@end
