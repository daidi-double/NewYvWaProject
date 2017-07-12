//
//  PayViewController.m
//  YuWa
//
//  Created by double on 17/2/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PayViewController.h"
#import "MoviePayTableViewCell.h"
#import "TotalMoneyTableViewCell.h"
#import "MarkTableViewCell.h"
#import "UseCouponViewController.h"
#import "PCPayViewController.h"
#import "NSString+JWAppendOtherStr.h"

#define MARKCELL00  @"MarkTableViewCell"
#define TOTALCELL @"TotalMoneyTableViewCell"
#define PAYCELL  @"MoviePayTableViewCell"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,UseCouponViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSIndexPath * markPath;
}
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong) UITableView * payInforTableView;
@property (nonatomic,strong) UILabel * settomLabel;
@property (nonatomic,assign) CGFloat payMoney;//需要支付的金额
@property (nonatomic,assign)BOOL is_useCoupon;
@property (nonatomic,copy)NSString * coupon_id;

@property (nonatomic,assign) CGFloat couponMoney;//优惠券金额
@property (nonatomic,strong) UILabel * useCouponLabel;
@property (nonatomic,assign) BOOL is_cancel;//取消代理
@property (nonatomic,strong) NSString* order_id;
@property (nonatomic,assign) BOOL is_lockseat;//是否已经锁定座位
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString * iphone;
@property (nonatomic,strong)UIView * headerView;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    MyLog(@"----%@",self.dataAry);
    [self makeUI];
    
    [self showMessage:@"选座票购买后无法退换，请仔细核对购票信息"];
    self.title =@"支付订单";
    [self timeHeadle];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)timeHeadle{
    
    self.title = @"支付订单";

}

- (void)makeUI{
    
    _payInforTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-50) style:UITableViewStyleGrouped];
    _payInforTableView.delegate = self;
    _payInforTableView.dataSource = self;
    
    [_payInforTableView registerNib:[UINib nibWithNibName:PAYCELL bundle:nil] forCellReuseIdentifier:PAYCELL];
    [_payInforTableView registerNib:[UINib nibWithNibName:TOTALCELL bundle:nil] forCellReuseIdentifier:TOTALCELL];
    [_payInforTableView registerNib:[UINib nibWithNibName:MARKCELL00 bundle:nil] forCellReuseIdentifier:MARKCELL00];
    
    [self.view addSubview:_payInforTableView];
    
    
    UIView * accountBGView = [[UIView alloc]initWithFrame:CGRectMake(0, _payInforTableView.bottom, kScreen_Width, 50)];
    accountBGView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:accountBGView];
    
    _settomLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,10, kScreen_Width * 0.4f, 30)];
    _settomLabel.textColor = CNaviColor;
    _settomLabel.text = self.dataAry[2];
    _settomLabel.font = [UIFont systemFontOfSize:15];
    
    [accountBGView addSubview:_settomLabel];
    
     NSString * pay = [self.dataAry[2] substringFromIndex:4];
    self.payMoney = [pay floatValue];
    
    UIButton * accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.frame = CGRectMake(accountBGView.width * 0.65f, 0, accountBGView.width * 0.35f, 50);
    accountBtn.backgroundColor = CNaviColor;
    accountBtn.titleLabel.textColor = [UIColor whiteColor];
    [accountBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(toAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [accountBGView addSubview:accountBtn];
    
    
}

//去结算，支付
- (void)toAccountAction{
    [self getOrder];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 150;
        }else if (indexPath.row == 2){
            return 88.f;
        }
        return 44.f;
    }
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 0) {
            MoviePayTableViewCell * payCell = [tableView dequeueReusableCellWithIdentifier:PAYCELL];
             payCell.selectionStyle = UITableViewCellSelectionStyleNone;
            payCell.dataAry = self.dataAry;
            return payCell;
        }else if (indexPath.row == 1){
            cell.textLabel.textColor = RGBCOLOR(142, 143, 144, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"优惠券抵用";
            
            [cell.contentView addSubview:self.useCouponLabel];
            markPath = indexPath;
        }else if (indexPath.row == 2){
            TotalMoneyTableViewCell * totalCell = [tableView dequeueReusableCellWithIdentifier:TOTALCELL];
            totalCell.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.payMoney];
            NSMutableArray * seatAry = self.dataAry[8];
            totalCell.price_numLabel.text = [NSString stringWithFormat:@"￥%@x%zi张(已含服务费)",self.dataAry[10],seatAry.count];
            totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return totalCell;
        }
    }else if (indexPath.section == 1){
        self.payInforTableView.separatorStyle = NO;
        MarkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MARKCELL00];
        cell.iphoneTextFild.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.iphoneTextFild.text = [NSString stringWithFormat:@"%@",[UserSession instance].account];
        self.iphone = cell.iphoneTextFild.text;
        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {

    if (indexPath.row == 1) {
        UseCouponViewController * useVC = [[UseCouponViewController alloc]init];
        useVC.shop_id = self.dataAry[9];
        useVC.delegate = self;
        useVC.couponType = 1;//标识是电影
        useVC.total_money = [NSString stringWithFormat:@"%.2f",self.payMoney];

        [self.navigationController pushViewController:useVC animated:YES];

    }
        
    }else if (indexPath.section == 1&&indexPath.row == 0){
        NSIndexPath * path = [self.payInforTableView indexPathForSelectedRow];
        MarkTableViewCell * cell = (MarkTableViewCell*)[self.payInforTableView cellForRowAtIndexPath:path];
        [cell.iphoneTextFild becomeFirstResponder];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 65.f;
    }
    return  0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
//计算所需要支付的金额
-(void)accountPayMoney{
    self.settomLabel.text = [NSString stringWithFormat:@"待结算%.2f",self.payMoney - self.couponMoney];
    
}

//使用了优惠券
- (void)DelegateGetCouponInfo:(CouponModel *)model{
    UITableViewCell * cell = [_payInforTableView cellForRowAtIndexPath:markPath];
    self.is_useCoupon = YES;
    self.coupon_id = model.coupon_id ;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee];

    NSString*aa=model.discount_fee;
    self.couponMoney=[aa floatValue];
    
    
    
    [self accountPayMoney];
    [self.payInforTableView reloadData];
    

 
}
//去付款前，生成订单
-(void)getOrder{

    NSMutableArray * seatCodeAry = [NSMutableArray array];
    NSMutableArray * seatAry = [NSMutableArray array];
    for (NSDictionary * seatCode in self.dataAry[8]) {
        [seatCodeAry addObject:seatCode[@"seatCode"]];
        [seatAry addObject:seatCode[@"seatNumber"]];
    }
    NSString * seatCodes = [seatCodeAry componentsJoinedByString:@","];//座位编码
    NSString * seats = [seatAry componentsJoinedByString:@","];//座位
    //抵用券金额
    NSString * couponMoneyStr = [NSString stringWithFormat:@"%.2f",self.couponMoney];
    //是否使用优惠券
    NSString * isUseCouponStr = [NSString stringWithFormat:@"%d",self.is_useCoupon];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_GETMOVIEORDER];
    NSDictionary*dict=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"cinema_code":self.cinemaCode,@"is_coupon":isUseCouponStr,@"channelShowCode":self.dataAry[1],@"seatCodes":seatCodes,@"mobile":self.iphone,@"coupon_money":couponMoneyStr,@"seat":seats};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if (self.is_useCoupon==YES) {
        [params setObject:@(self.is_useCoupon) forKey:@"coupon_id"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",params);
        MyLog(@"锁定座位%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            
            self.index = 1;

            NSDictionary * dict = data[@"data"];
            self.order_id = dict[@"id"];
            self.is_lockseat = 1;
            PCPayViewController * pcVC = [PCPayViewController sharedManager];
            pcVC.blanceMoney = self.payMoney;
            pcVC.shop_ID = self.cinemaCode;
            pcVC.status = 1;
            pcVC.orderCode = dict[@"order_code"];
            pcVC.order_id = [self.order_id floatValue];
            [self.navigationController pushViewController:pcVC animated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}


- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (UILabel*)useCouponLabel{
    if (!_useCouponLabel) {
        _useCouponLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width * 0.6, 10, kScreen_Width * 0.45f, 30)];
        _useCouponLabel.textColor = RGBCOLOR(143, 144, 145, 1);
        _useCouponLabel.font = [UIFont systemFontOfSize:14];
        _useCouponLabel.text = @"使用优惠券";
    }
    return _useCouponLabel;
}
- (instancetype)initWithDataArray:(NSMutableArray *)ary{
    self = [super init];
    if (self) {
        [self.dataAry addObjectsFromArray:ary];
    }
    return self;
}
- (UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 48)];
        _headerView.backgroundColor = [UIColor clearColor];
        UILabel * strLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, 28)];
        strLabel.textAlignment = 1;
        strLabel.font = [UIFont systemFontOfSize:13];
        strLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        strLabel.text = @"取票码将发送到如下手机，请注意查收";
        [_headerView addSubview:strLabel];
    }
    return _headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
