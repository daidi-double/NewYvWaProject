//
//  PCDetailMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//



#import "PCDetailMoneyViewController.h"
#import "ChooseBtnView.h"
#import "PCMoneyDetailTableViewCell.h"    //cell
#import "YJSegmentedControl.h"
#import "JWTools.h"
#import "MoneyPackModel.h"
#import "customBtn.h"
#import "YWLoginViewController.h"
#import "PCDetailPageViewController.h"
#import "headerView.h"
#define CELL0  @"PCMoneyDetailTableViewCell"

@interface PCDetailMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate,ChooseBtnViewDelegate>
{
    
}
@property(nonatomic,strong)UITableView*tableView;
//已经排列好各月份数据
@property(nonatomic,strong)NSMutableArray*maAllDatasModel;   //保存所有的model 月份
@property(nonatomic,strong)NSMutableArray*sectionData;
//半个月总支出数据；   第一个数组是收入，最后一个是支出
@property(nonatomic,strong)NSMutableArray*zhichuData;
@property(nonatomic,assign)NSInteger payType;  //类别1为收支明细(全部)2为直接介绍分红，3为支出，4为简介介绍分红，5商务分红，6积分分红，7店铺收款，8退款，9提现，
//3 = 商务分红,
//99 = 退款,
//8 = 提现,
//4 = 直接积分分红,
//9 = 支出,
//5 = 间接积分分红,
//1 = 直接介绍分红,
//2 = 间接介绍分红
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)ChooseBtnView * btnView;
@property(nonatomic,strong)customBtn * titleView;
@property(nonatomic,strong)UIView * bgView;

@end

@implementation PCDetailMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"收支明细";
    [self makeTopView];
    [self.view addSubview: self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PCMoneyDetailTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self setUpMJRefresh];
    [self creatTitleView];
}

#pragma mark  -- UI

-(void)makeTopView{
    
    _titleView = [[customBtn alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/2, 44)];
    [_titleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleView.titleLbl.text = @"收支明细";
    _titleView.downImageView.image = [UIImage imageNamed:@"down"];
    [_titleView addTarget:self action:@selector(chooseMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleView;
    
}
- (void)chooseMethod:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _btnView.hidden = NO;
        _bgView.hidden = NO;
        
    }else{
        _btnView.hidden = YES;
        _bgView.hidden = YES;
    }
    WEAKSELF;
    _btnView.titleBlock = ^(NSInteger row,NSString * title){
        weakSelf.titleView.titleLbl.text = title;
        weakSelf.titleView.downImageView.image = [UIImage imageNamed:@"down"];
        sender.selected = !sender.selected;
        weakSelf.btnView.hidden = YES;
       weakSelf.bgView.hidden = YES;
        weakSelf.payType = row;
    };

}
- (void)creatTitleView{
    //下拉菜单
    _btnView = [[ChooseBtnView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width,35*6)];
    _btnView.hidden = YES;
    _btnView.delegate = self;
    [self.view addSubview:_btnView];
    //透明背景
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+6*35, kScreen_Width, kScreen_Height)];
    
    if ([[UserSession instance].isVIP integerValue] == 2) {
        _btnView.frame = CGRectMake(0, 64, kScreen_Width, 64+9*35);
        _bgView.y = 64+9*35;
    }
    _bgView.backgroundColor = [UIColor lightGrayColor];
    _bgView.hidden= YES;
    _bgView.alpha = 0.6;
    [self.view addSubview:_bgView];
}
- (void)goRefresh:(NSInteger)row{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUpMJRefresh];
        self.payType = row;
        if ([[UserSession instance].isVIP integerValue] == 1) {
            if (row == 3) {
                self.payType = 9;
            }else if (row == 4){
                self.payType = 99;
            }else if (row == 5){
                self.payType = 8;
            }
        }else{
        if (row == 6) {
            self.payType = 9;
        }else if (row == 7){
            self.payType = 99;
        }
        }
//        MyLog(@"self.payType = %ld",self.payType);
        [self getDatas];
    });
}
-(void)setUpMJRefresh{
    
    self.maAllDatasModel=[NSMutableArray array];
    self.pagen=10;
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.maAllDatasModel=[NSMutableArray array];
        self.pages=0;
        [self getDatas];
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.maAllDatasModel.count==0) {
        return 0;
    }
    return self.sectionData.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headerView * headerView = [[[NSBundle mainBundle]loadNibNamed:@"headerView" owner:nil options:nil]lastObject ];
    headerView.backgroundColor = RGBCOLOR(246, 246, 245, 1);
    NSNumber * nub = self.sectionData[section];
    NSArray * income = self.zhichuData.firstObject;
    NSArray * pay = self.zhichuData.lastObject;
    NSNumber * incomeStr = income[section];
    NSString * str = incomeStr.description;
    headerView.income = str;
    
    NSNumber * payStr = pay[section];
    NSString * payStr2 = payStr.description;
    headerView.pay = payStr2;
    if (section == 0) {//判断下，当前第一区的月份是否与当前月份匹配，不匹配说明是上个月的，本月还没收支，所以赋值从第二个开始
        if (nub != [NSNumber numberWithInteger:[self getYearOrMonth:@"month"]]) {
            incomeStr = income[section +1];
            str = incomeStr.description;
            headerView.income = str;

            payStr = pay[section+1];
            payStr2 = payStr.description;
            headerView.pay = payStr2;
        }
    }else if (section == 5){//给予一个值，避免翻页到当前出现闪退

        headerView.income = @"0";
       
        headerView.pay = @"0";
    }

    if (nub == [NSNumber numberWithInteger:[self getYearOrMonth:@"month"]]) {
            headerView.month.text = [NSString stringWithFormat:@"本月"];
        
        return headerView;
    }
    headerView.month.text = [NSString stringWithFormat:@"%@月",nub];
   return headerView;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSNumber * nub = self.sectionData[section];
    if (nub == [NSNumber numberWithInteger:[self getYearOrMonth:@"month"]]) {
        return [NSString stringWithFormat:@"本月"];
    }
    return  [NSString stringWithFormat:@"%@月",nub];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    MyLog(@"section = %ld",(long)section);
    NSMutableArray * data;
    if (self.maAllDatasModel.count!=0) {
       data  = self.maAllDatasModel[section];
        return data.count;
    }
    return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCMoneyDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    MoneyPackModel*model;
    if (self.maAllDatasModel.count > 0) {
       NSMutableArray * data =  self.maAllDatasModel[indexPath.section];
        model= data[indexPath.row];
    }
    
    UILabel*titleLabel=[cell viewWithTag:11];
    NSDate * week = [NSDate dateWithTimeIntervalSince1970:[model.ctime doubleValue]];
    [self weekdayStringFromDate:week];
    NSString * time = [self distanceTimeWithBeforeTime:[model.ctime doubleValue]];
    NSArray * ary = [time componentsSeparatedByString:@" "];

    if ([ary[0] isEqualToString:@"今天"] ) {
        
        titleLabel.text = @"今天";
    }else if ([ary[0] isEqualToString:@"昨天"]) {
        titleLabel.text = @"昨天";
    }else{
        titleLabel.text = [self weekdayStringFromDate:week];
    }

    UILabel * timeLabel = [cell viewWithTag:12];

    timeLabel.text = model.time;
    
    UIImageView * picView = [cell viewWithTag:3];
    picView.image = [UIImage imageNamed:model.type];
    if ([model.type isEqualToString:@"直接介绍分红"] ||[model.type isEqualToString:@"间接介绍分红"]) {
         picView.image = [UIImage imageNamed:@"介绍分红"];
    }
    if ([model.type isEqualToString:@"直接介绍积分分红"] ||[model.type isEqualToString:@"间接介绍积分分红"]) {
        picView.image = [UIImage imageNamed:@"积分分红"];
    }
    if ([model.type containsString:@"提现"]) {
        picView.image = [UIImage imageNamed:@"提现"];
    }
    UILabel * methodLabel = [cell viewWithTag:4];
    methodLabel.text = model.type;
//    MyLog(@"method = %@",methodLabel.text);
    
//    UILabel * getMoneyLabel = [self.view viewWithTag:5];
//    getMoneyLabel.text = model.money;
    
    UILabel*dateTimeLabel=[cell viewWithTag:6];
    dateTimeLabel.text=model.dateTime;
    UILabel*moneyLabel=[cell viewWithTag:7];

    moneyLabel.text=[NSString stringWithFormat:@"%@",model.money];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    

    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [self weekdayStringFromDate:beDate];
//            MyLog(@"distanceStr 1 = %@",distanceStr);
            distanceStr = [df stringFromDate:beDate];
//            MyLog(@"distanceStr 2 = %@",distanceStr);
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"yyyy-MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

- (NSString *)timeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];

    if(distanceTime <24*60*60*365){
        [df setDateFormat:@"HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
//根据日期求星期几
- (NSString *)weekdayStringFromDate:(NSDate*)date{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PCDetailPageViewController * vc = [[PCDetailPageViewController alloc]init];
    NSMutableArray * modelArr =  self.maAllDatasModel[indexPath.section];
    MoneyPackModel* model = modelArr[indexPath.row];
    vc.orderId = model.id;
//    MyLog(@"vc.orderId = %@",vc.orderId);
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  --Datas
-(void)getDatas{
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETPAYDETAIL];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(self.payType),@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",params);
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSMutableArray *arr ;
            arr = data[@"data"];
            if (arr.count) {
//                MyLog(@"count = %lu",(unsigned long)arr.count);
                [self.maAllDatasModel removeAllObjects];
                //记录总数据
                NSMutableArray * allData = [NSMutableArray array];
                NSMutableArray * all = [NSMutableArray array];
                for (NSDictionary*dict in data[@"data"]) {
                    NSString * time = dict[@"dateTime"];
                    NSString * year1 =  [time substringWithRange:NSMakeRange(0, 4)];
//                    MyLog(@"!!!!~~~~year~%@",year1);
                    NSString *Month =  [time substringWithRange:NSMakeRange(5, 2)];
                    [Month intValue];
                    [NSNumber numberWithInteger:[Month integerValue]];
                    //先判断是否是这一年的
                    if ([year1 integerValue] == [self getYearOrMonth:@"year"]) {
                        //先判断all数据里面是否包含这个月份的数据
                        if ( ![all containsObject:[NSNumber numberWithInteger:[Month integerValue]]]) {
                            //表示数组里面没有这个数值
                            [allData addObject:[NSMutableArray array]];
                            [all addObject:[NSNumber numberWithInteger:[Month integerValue]]];
                            //字典转模型
                            MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                            [allData.lastObject addObject:model];
                        }else{
                            //表示里面有这个数
                            //                        判断出这个数，在数组里面属于第几位
                            NSUInteger  count1 =  [all indexOfObject:[NSNumber numberWithInteger:[Month integerValue]]];
                            MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                            NSMutableArray * addModelArr = allData[count1];
                            [addModelArr addObject:model];
                        }
                    }else{
                        //                    说明不是今年的数据
                        if ([year1 integerValue] == ([self getYearOrMonth:@"year"]-1)) {
                            //说明是上一年的数据  获取2017-04格式字符串
                            NSString * yearAndMonth =  [time substringWithRange:NSMakeRange(0, 7)];
                            //                        除去-
                            yearAndMonth = [yearAndMonth stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            //先判断all数据里面是否包含这个月份的数据
                            if ( ![all containsObject:[NSNumber numberWithInteger:[yearAndMonth integerValue]]]) {
                                //表示数组里面没有这个数值
                                [allData addObject:[NSMutableArray array]];
                                [all addObject:[NSNumber numberWithInteger:[yearAndMonth integerValue]]];
                                //字典转模型
                                MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                                [allData.lastObject addObject:model];
                            }else{
                                //表示里面有这个数
                                //                        判断出这个数，在数组里面属于第几位
                                NSUInteger  count1 =  [all indexOfObject:[NSNumber numberWithInteger:[yearAndMonth integerValue]]];
                                MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                                NSMutableArray * addModelArr =   allData[count1];
                                [addModelArr addObject:model];
                            }
                        }
                    }
                    //                MyLog(@"!!!!!!!!!!%@，，%@",dict[@"dataTime"],time );
                    //                MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                    //                NSMutableArray * modelARR =
                    //                [self.maAllDatasModel addObject:model];
                    
                }
                NSDictionary * dic = data[@"total_money"];
                //收入
                [self.zhichuData addObject:dic[@"income"]];
                //支出
                 [self.zhichuData addObject:dic[@"pay"]];
                self.maAllDatasModel   = allData;
                self.sectionData = all;
            }
            [self.tableView reloadData];
            
            
        }else if ([errorCode isEqualToString:@"9"]){
            
            [JRToast showWithText:@"身份已过期,请重新登入" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController *vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}
//获取当年的年份 或者月份
-(NSInteger)getYearOrMonth:(NSString *)yearOrMonth{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    if ([yearOrMonth isEqualToString:@"year"]) {
//        NSLog(@"Year: %ld", [calendar component:NSCalendarUnitYear fromDate:date]);
        return  [calendar component:NSCalendarUnitYear fromDate:date];
    }
    if ([yearOrMonth isEqualToString:@"month"]) {
//        NSLog(@"Year: %ld", [calendar component:NSCalendarUnitYear fromDate:date]);
        return  [calendar component:NSCalendarUnitMonth fromDate:date];
    }
    return 0;
}
//
//#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    NSInteger aa=selection+1;
    self.payType=(short)aa;
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSMutableArray *)sectionData{
    if (!_sectionData) {
        _sectionData   =  [NSMutableArray array];
    }
    return _sectionData;
}
-(NSMutableArray *)zhichuData{
    if (_zhichuData == nil) {
        _zhichuData = [NSMutableArray arrayWithCapacity:6];
    }
    return _zhichuData;
}
@end
