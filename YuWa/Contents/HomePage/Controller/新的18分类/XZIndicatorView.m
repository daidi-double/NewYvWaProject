//
//  XZIndicatorView.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZIndicatorView.h"
#import "UIView+Frame.h"
@interface XZIndicatorView ()

/**viewRatio*/
@property (nonatomic, assign) CGFloat viewRatio;

/**miniMe*/
@property (nonatomic, weak) UIView *miniMe;

/**miniImageView*/
@property (nonatomic, weak) UIImageView *miniImageView;

/**logoImageView*/
@property (nonatomic, weak) UIImageView *logoImageView;

/**miniMe*/
@property (nonatomic, weak) UIView *miniIndicator;

/**mapView*/
@property (nonatomic, weak) UIView *mapView;

/**myScrollview*/
@property (nonatomic, weak) UIScrollView *myScrollview;
@end

@implementation XZIndicatorView
-(instancetype)initWithView:(UIView *)mapView withRatio:(CGFloat)ratio withScrollView:(UIScrollView *)myScrollview{
    if (self = [super init]) {
        self.viewRatio = ratio;
        self.mapView = mapView;
        self.myScrollview = myScrollview;
        self.userInteractionEnabled = NO;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UIView *miniMe = [[UIView alloc]init];
    self.miniMe = miniMe;
    [self addSubview:miniMe];
    miniMe.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screenBg"]];//这里更换影厅图标
    
    self.logoImageView = logoImageView;
    [miniMe addSubview:logoImageView];
    
    UIImageView *miniImageView = [[UIImageView alloc]initWithImage:[self captureScreen:self.mapView]];
    miniImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:miniImageView];
    self.miniImageView = miniImageView;
    
    UIView *miniIndicator = [[UIView alloc]init];
    miniIndicator.layer.borderWidth = 1;
    miniIndicator.layer.borderColor = [UIColor redColor].CGColor;
    self.miniIndicator = miniIndicator;
    [self addSubview:miniIndicator];
}

- (void)updateMiniIndicator{
    
    [self setNeedsLayout];
    
}
-(void)updateMiniImageView{
    
    self.miniImageView.image = [self captureScreen:_mapView];
}

-(void)indicatorHidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(UIImage*)captureScreen:(UIView*) viewToCapture{
    
    CGRect rect = [viewToCapture bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0f);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.miniMe.frame = CGRectMake(-3, - 3 * 3, self.width + 2 * 3,self.height + 4 * 3);
    
    self.logoImageView.frame = CGRectMake(2 * 3, 3, self.width - 4 * 3, 3);
    
    self.miniImageView.frame = CGRectMake(0, 0,self.width, self.height );
    //设置线框的高宽
    //下面代码还有很多需要优化的地方,座位少的时候还是有点定位不准
    self.miniIndicator.x = (self.myScrollview.contentOffset.x * self.width)  / self.myScrollview.contentSize.width;
    self.miniIndicator.y = (self.myScrollview.contentOffset.y * self.height) / self.myScrollview.contentSize.height;
    
    if (self.miniIndicator.height == self.height && self.miniIndicator.width == self.width) {
        self.miniIndicator.x = 0;
        self.miniIndicator.y = 0;
    }
    if (self.mapView.width < self.myScrollview.width) {
        self.miniIndicator.x = 0;
        self.miniIndicator.width = self.width;
    }else{
        
        self.miniIndicator.width = (self.width * (self.myScrollview.width - self.myScrollview.contentInset.right)/ self.mapView.width);
        if (self.myScrollview.contentOffset.x < 0) {
            self.miniIndicator.width =  self.miniIndicator.width - ABS(self.myScrollview.contentOffset.x * self.width) / self.myScrollview.contentSize.width;
            self.miniIndicator.x = 0;
            
        }
        if (self.myScrollview.contentOffset.x > self.myScrollview.contentSize.width - kScreen_Width + self.myScrollview.contentInset.right) {
            self.miniIndicator.width =  self.miniIndicator.width - (self.myScrollview.contentOffset.x - (self.myScrollview.contentSize.width - kScreen_Width + self.myScrollview.contentInset.right))* self.width / self.myScrollview.contentSize.width;
        }
        
    }
    
    if (self.mapView.height <= self.myScrollview.height - XZseastsColMargin) {
        self.miniIndicator.y = 0;
        self.miniIndicator.height = self.height;
    }else{
        self.miniIndicator.height = self.height * (self.myScrollview.height - XZseastsColMargin) / self.mapView.height;
        if (self.myScrollview.contentOffset.y < 0) {
            self.miniIndicator.y = 0;
            self.miniIndicator.height =  self.miniIndicator.height - ABS(self.myScrollview.contentOffset.y * self.height) / self.myScrollview.contentSize.height;
        }
        if (self.myScrollview.contentOffset.y > self.mapView.height - self.myScrollview.height + XZseastsColMargin) {
            self.miniIndicator.height =  self.miniIndicator.height -(self.myScrollview.contentOffset.y - (self.mapView.height - self.myScrollview.height + XZseastsColMargin)) * self.height / self.myScrollview.contentSize.height;
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
