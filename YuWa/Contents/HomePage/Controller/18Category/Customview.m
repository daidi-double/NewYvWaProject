//
//  Customview.m
//  YuWa
//
//  Created by double on 17/3/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "Customview.h"
@interface Customview ()

@end
@implementation Customview

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CNaviColor;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    self.shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    self.shopNameLabel.font = [UIFont systemFontOfSize:14];
    self.shopNameLabel.textColor = [UIColor blackColor];
    self.shopNameLabel.text = @"Hello";
    CGRect shopNameWidth = [_shopNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _shopNameLabel.font} context:nil];
    _shopNameLabel.frame= CGRectMake(5, 5, shopNameWidth.size.width +10 , 20);
    [self addSubview:_shopNameLabel];
}

//接收传递进的参数
-(void)setShopName:(NSString *)shopName
{
    _shopNameLabel.text = [shopName copy];
    CGRect shopNameWidth = [_shopNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _shopNameLabel.font} context:nil];
    _shopNameLabel.frame= CGRectMake(5, 5, shopNameWidth.size.width +10 , 20);
}

//绘制弹出气泡的背景
-(void)drawRect:(CGRect)rect{
    
    //设置阴影
    self.layer.shadowColor = [CNaviColor CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    
    //绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [CNaviColor CGColor]);
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-5;
    
    //绘制路径
    CGContextMoveToPoint(context, midx+5, maxy);
    CGContextAddLineToPoint(context,midx, maxy+5);
    CGContextAddLineToPoint(context,midx-5, maxy);
    
    //绘制圆弧
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}
@end
