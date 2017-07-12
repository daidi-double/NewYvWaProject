//
//  YWdetailHeaderView.m
//  YuWa
//
//  Created by L灰灰Y on 2017/4/19.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWdetailHeaderView.h"

@interface YWdetailHeaderView ()


@property (nonatomic, assign) CGRect  myFrame;
@end
@implementation YWdetailHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"detailHeaderView" owner:nil options:nil];
//        self=[nibs objectAtIndex:0];
//       
//        
//        self.myFrame = frame;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     self.bgImageView.contentMode = UIViewContentModeScaleToFill;
//    self.bgImageView.clipsToBounds = YES;
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bgImageView.frame];
//    toolbar.barStyle = UIBarStyleBlackTranslucent;
//    [self addSubview:toolbar];
//    [self insertSubview:self.bgImageView belowSubview:toolbar];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.backgroundColor = [UIColor orangeColor];
    effectView.frame = self.frame;
    effectView.alpha  = 0.97;
    [self insertSubview:effectView aboveSubview:self.bgImageView];
    self.frame = self.myFrame;
}
//-(void)setImageVIew:(UIImageView *)imageVIew{
//    _imageVIew = imageVIew;
//    _bgImageView = imageVIew;
//}

@end
