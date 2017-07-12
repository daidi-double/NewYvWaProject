//
//  XZSeatButton.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZSeatButton.h"
#import "UIView+Frame.h"
@implementation XZSeatButton
-(void)setHighlighted:(BOOL)highlighted{}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnScale = XZSeatBtnScale;
    CGFloat btnX = (self.width - self.width * btnScale) * 0.5;
    CGFloat btnY = (self.height - self.height * btnScale) * 0.5;
    CGFloat btnW = self.width * btnScale;
    CGFloat btnH = self.height * btnScale;
    self.imageView.frame = CGRectMake(btnX, btnY, btnW, btnH);
}
-(BOOL)isSeatAvailable{
    return [self.seatmodel.st isEqualToString:@"N"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
