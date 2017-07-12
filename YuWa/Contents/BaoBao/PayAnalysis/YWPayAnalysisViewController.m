//
//  YWPayAnalysisViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/11/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayAnalysisViewController.h"
#import "JHChartHeader.h"

@interface YWPayAnalysisViewController ()

@end

@implementation YWPayAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费分析";
    [self requestData];
}

- (void)showFirstQuardrantWithXLineDataArr:(NSArray *)xLineDataArr withValueArr:(NSArray *)valueArr{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, (kScreen_Height - 72.f)/2) andLineChartType:JHChartLineValueNotForEveryX];
    NSInteger allValue = 0;
    for (int i = 0; i < [valueArr[0] count]; i++) {
        allValue += [valueArr[0][i] integerValue];
    }
    allValue = (allValue/([valueArr[0] count]>0?[valueArr[0] count]:1))*2/5;
    NSInteger number = allValue;
    for (int i = 0; i < 100; i++) {
        if (number/10 <= 0) {
            allValue = number;
            for (int j = 0; j<i; j++) {
                allValue = allValue * 10;
            }
            break;
        }else{
            number = number/10;
        }
    }
    lineChart.yLineNumber = allValue>0?allValue:5;
    
    lineChart.xLineDataArr = xLineDataArr;
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    lineChart.valueArr = valueArr;
    lineChart.valueLineColorArr = @[[UIColor purpleColor], [UIColor brownColor]];//Line Chart colors
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];//Colors for every line chart
    lineChart.xAndYLineColor = [UIColor blackColor];//color for XY axis
    lineChart.xAndYNumberColor = [UIColor blueColor];// XY axis scale color
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];//Dotted line color of the coordinate point
    lineChart.contentFill = YES;//Set whether to fill the content, the default is False
    lineChart.pathCurve = YES;//Set whether the curve path
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0.500 green:0.000 blue:0.500 alpha:0.468],[UIColor colorWithRed:0.500 green:0.214 blue:0.098 alpha:0.468]];//Set fill color array
    [self.view addSubview:lineChart];
    [lineChart showAnimation];
}

- (void)showColumnViewWithXShowInfoText:(NSArray *)xShowInfoText withValueArr:(NSArray *)valueArr{
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0.f, (kScreen_Height - 64.f)/2 + 72.f, kScreen_Width, (kScreen_Height - 80.f)/2)];
    column.valueArr = valueArr;
    column.originSize = CGPointMake(30, 30);//The first column of the distance from the starting point
    column.drawFromOriginX = 10;//Column width
    column.columnWidth = 40;//X, Y axis font color
    column.drawTextColorForX_Y = [UIColor greenColor];//X, Y axis line color
    column.colorForXYLine = [UIColor greenColor];
    column.columnBGcolorsArr = @[CNaviColor,[UIColor greenColor],[UIColor orangeColor]];//Module prompt
    column.xShowInfoText = xShowInfoText;
    [column showAnimation];
    [self.view addSubview:column];
}

#pragma mark - Http
- (void)requestData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_BAOBAO_SevenConsume withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSMutableArray * timeArr = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * moneyArr = [NSMutableArray arrayWithCapacity:0];
        NSArray * dataArr = responsObj[@"data"];
        for (NSDictionary * dataDic in dataArr) {
            [timeArr insertObject:[JWTools dateWithDate:dataDic[@"ctime"]] atIndex:0];
            [moneyArr insertObject:dataDic[@"money"] atIndex:0];
        }
        if (dataArr.count>0) {
            [self showFirstQuardrantWithXLineDataArr:timeArr withValueArr:@[moneyArr]];
        }else{
            if (![[[UIApplication sharedApplication].delegate.window.subviews lastObject] isKindOfClass:[MBProgressHUD class]]){
                [self showHUDWithStr:@"您暂无消费记录哟" withSuccess:NO];
            }
        }
        
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
    
    [[HttpObject manager]postNoHudWithType:YuWaType_BAOBAO_ConsumeType withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        
        NSMutableArray * typeArr = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * moneyArr = [NSMutableArray arrayWithCapacity:0];
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (NSDictionary * dataDic in dataArr) {
                NSString * type = dataDic[@"type"];
                if (!type||[type isEqualToString:@""])type = @"其他";
                NSArray * typeArrTemp = [NSArray arrayWithArray:typeArr];
                BOOL isSame = NO;
                for (int i = 0; i < typeArrTemp.count; i++) {
                    if ([type isEqualToString:typeArrTemp[i]]) {
                        CGFloat money = [moneyArr[i] floatValue] + [dataDic[@"money"] floatValue];
                        [moneyArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f",money]];
                        isSame = YES;
                    }
                }
                if (!isSame) {
                    [typeArr addObject:[dataDic[@"type"] isEqualToString:@""]?@"其他":dataDic[@"type"]];
                    [moneyArr addObject:dataDic[@"money"]];
                }
            }
            NSMutableArray * moneyData = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<moneyArr.count; i++) {
                [moneyData addObject:@[moneyArr[i]]];
            }
            
            [self showColumnViewWithXShowInfoText:typeArr withValueArr:moneyData];
        }else{
            if (![[[UIApplication sharedApplication].delegate.window.subviews lastObject] isKindOfClass:[MBProgressHUD class]]){
                [self showHUDWithStr:@"您暂无消费记录哟" withSuccess:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
