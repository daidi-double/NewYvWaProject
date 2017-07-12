//
//  XZRowIndexView.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZRowIndexView.h"
#import "UIView+Frame.h"
#import "XZSeatsModel.h"
@implementation XZRowIndexView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.width * 0.5;
    self.layer.masksToBounds = YES;
}

-(void)setHeight:(CGFloat)height{
    [super setHeight:height];
    
    [self setNeedsDisplay];
}

-(void)setIndexsArray:(NSMutableArray *)indexsArray{
    
    _indexsArray = indexsArray;
    
    [self setNeedsDisplay];
}
//画索引条
- (void)drawRect:(CGRect)rect {
    
    NSDictionary *attributeName = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    CGFloat NuomberTitleH = (self.height - 2 * 10) / self.indexsArray.count;
    
    [self.indexsArray enumerateObjectsUsingBlock:^(XZSeatsModel *seatsModel, NSUInteger idx, BOOL *stop) {
        
        CGSize strsize =  [seatsModel.rowId sizeWithAttributes:attributeName];
        
        [seatsModel.rowId drawAtPoint:CGPointMake(self.width * 0.5 - strsize.width  * 0.5,10 + idx * NuomberTitleH + NuomberTitleH  * 0.5 - strsize.height  * 0.5) withAttributes:attributeName];
        
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
