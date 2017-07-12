//
//  XZSeatsView.m
//  YuWa
//
//  Created by double on 17/2/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "XZSeatsView.h"
#import "XZSeatsModel.h"
#import "XZSeatModel.h"
@interface XZSeatsView ()

@property (nonatomic,copy) void (^actionBlock)(XZSeatButton *seatBtn,NSMutableDictionary *allAvailableSeats);

@property (nonatomic,strong) NSMutableDictionary *allAvailableSeats;//所有可选的座位

@end
@implementation XZSeatsView
-(NSMutableDictionary *)allAvailableSeats{
    if (!_allAvailableSeats) {
        _allAvailableSeats = [NSMutableDictionary dictionary];
    }
    return _allAvailableSeats;
}
-(instancetype)initWithSeatsArray:(NSMutableArray *)seatsArray maxNomarWidth:(CGFloat)maxW maxCount:(NSInteger)maxCount seatBtnActionBlock:(void (^)(XZSeatButton *, NSMutableDictionary *))actionBlock{
    
    if (self = [super init]) {
        
        self.actionBlock = actionBlock;
        NSInteger cloCount = 0;
        for (XZSeatsModel *seatsModel in seatsArray) {
            if (seatsModel.columns.count>cloCount ) {
                cloCount = seatsModel.columns.count;
            }
        }
        
        if (cloCount % 2) cloCount += 1;//偶数列数加1 防止中线压住座位
        
        CGFloat seatViewW = maxW - 2 * XZseastsRowMargin ;
        
        CGFloat seatBtnW = seatViewW / (cloCount+2);
        
        if (seatBtnW > XZseastMinW_H) {
            seatBtnW = XZseastMinW_H;
            seatViewW = cloCount * (XZseastMinW_H+2);
        }
        //初始化就回调算出按钮和自身的宽高
        CGFloat seatBtnH = seatBtnW;
        self.seatBtnWidth = seatBtnW;
        self.seatBtnHeight = seatBtnH;
        self.seatViewWidth = seatViewW;
        self.seatViewHeight = [seatsArray count] * (seatBtnH +1);
        //初始化座位
        [self initSeatBtns:seatsArray];
    }
    return self;
}

-(void)initSeatBtns:(NSMutableArray *)seatsArray{
    //给可以用的座位绑定索引用来判断是否座位落单
    static NSInteger seatIndex = 0;
    [seatsArray enumerateObjectsUsingBlock:^(XZSeatsModel *seatsModel, NSUInteger idx, BOOL *stop) {

        for (int i = 0; i < seatsModel.columns.count; i++) {
            
            seatIndex++;
            XZSeatModel *seatModel = seatsModel.columns[i];
            XZSeatButton *seatBtn = [XZSeatButton buttonWithType:UIButtonTypeCustom];
            seatBtn.seatmodel = seatModel;
            seatBtn.seatsmodel = seatsModel;
            seatBtn.code = seatsModel.code;
            //表示可以购票
            if ([seatModel.st isEqualToString:@"1"]) {
                if ([seatModel.type integerValue]== 2) {
                   [seatBtn setImage:[UIImage imageNamed:@"loveseat"] forState:UIControlStateNormal];
                }else{
                   [seatBtn setImage:[UIImage imageNamed:@"kexuan"] forState:UIControlStateNormal];//这里更改座位图标
                }
                [seatBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                seatBtn.seatIndex = seatIndex;
                [self.allAvailableSeats setObject:seatBtn forKey:[@(seatIndex) stringValue]];
            }else if ([seatModel.st isEqualToString:@"E"]){
                continue;
            }else{
                [seatBtn setImage:[UIImage imageNamed:@"yishou"] forState:UIControlStateNormal];
                seatBtn.userInteractionEnabled = NO;
            }
            [seatBtn addTarget:self action:@selector(seatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:seatBtn];
            
        }
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[XZSeatButton class]]) {
            XZSeatButton *seatBtn = (XZSeatButton *)view;
            NSInteger Col = [seatBtn.seatsmodel.columns indexOfObject:seatBtn.seatmodel];//座位列
            NSInteger Row = [seatBtn.seatsmodel.rowNum integerValue] - 1;//座位行
            seatBtn.frame = CGRectMake(Col * (self.seatBtnHeight+2),Row * (self.seatBtnHeight+1), self.seatBtnWidth, self.seatBtnHeight);
        }
    }
    
}
-(void)seatBtnAction:(XZSeatButton *)seatbtn{

    seatbtn.selected = !seatbtn.selected;
    if (seatbtn.selected) {
        seatbtn.seatmodel.st = @"LK";//设置为选中
       

    }else{
        seatbtn.seatmodel.st = @"N";//设置为可选

        
    }
    if (self.actionBlock) self.actionBlock(seatbtn,self.allAvailableSeats);
}
-(NSInteger) getSeatBtnHeight{
    return self.seatBtnWidth;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
