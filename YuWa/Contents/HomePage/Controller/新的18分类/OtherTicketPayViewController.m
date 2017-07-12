//
//  OtherTicketPayViewController.m
//  YuWa
//
//  Created by double on 17/5/17.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OtherTicketPayViewController.h"
#import "OtherTicketPayTableViewCell.h"
#import "PCPayViewController.h"
#import "CouponModel.h"
#import "UseCouponViewController.h"
#import "MarkTableViewCell.h"

#define MARKCELL  @"MarkTableViewCell"
#define TICKETPAYCELL  @"OtherTicketPayTableViewCell"
@interface OtherTicketPayViewController ()<UITableViewDelegate,UITableViewDataSource,OtherTicketPayTableViewCellDelegate,UseCouponViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settmentMoneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *payTableView;
//@property (nonatomic,strong) UITextField * iPhoneNumberTF;
@property (nonatomic,assign) NSInteger ticketNumber;
@property (nonatomic,assign) BOOL is_coupon;//是否使用优惠券
@property (nonatomic,assign)CGFloat coupon_money;//优惠券金额
@property (nonatomic,copy)NSString * orderID;//订单号
@property (nonatomic,copy)NSString * total_money;//返回的需要支付的金额
@property (nonatomic,copy)NSString * pay_money;//返回的实际支付金额
@property (nonatomic,copy)NSString * coupon_id;
@property (nonatomic,assign)CGFloat shouldPay_money;//需要支付的金额
@property (nonatomic,strong)UIView * footView;
@property (nonatomic,strong)UIView * footViewTwo;
@property (nonatomic,copy)NSString * iphone;

@end

@implementation OtherTicketPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"通兑券确认";
    self.ticketNumber = 1;//默认张数为1张
    self.is_coupon = 0;
    self.coupon_money = 0;
    self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",[self.model.price floatValue]/100];
}

- (void)makeUI{
    [self.payTableView registerNib:[UINib nibWithNibName:TICKETPAYCELL bundle:nil] forCellReuseIdentifier:TICKETPAYCELL];
    [self.payTableView registerNib:[UINib nibWithNibName:MARKCELL bundle:nil] forCellReuseIdentifier:MARKCELL];
    self.view.backgroundColor = RGBCOLOR(240, 240, 240, 1);

 }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 195.f;
    }else{
        return 42.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01f;
    }else{
        return 200.f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OtherTicketPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TICKETPAYCELL];
        cell.selectionStyle = NO;
        cell.delegate = self;
        self.payTableView.separatorStyle = NO;
        cell.model = self.model;

        return cell;
        
    }else{
        MarkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MARKCELL];
        cell.iphoneTextFild.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iphoneTextFild.text = [NSString stringWithFormat:@"%@",[UserSession instance].account];
        self.iphone = cell.iphoneTextFild.text;

        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 65.f;
    }
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        
        return self.footView;
    }else{
        return nil;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.footViewTwo;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        NSIndexPath * path = [self.payTableView indexPathForSelectedRow];
        MarkTableViewCell * cell = (MarkTableViewCell*)[self.payTableView cellForRowAtIndexPath:path];
        [cell.iphoneTextFild becomeFirstResponder];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
//去结算
- (IBAction)toPayAction:(UIButton *)sender {
    //先生成订单号
    if (self.ticketNumber <= 0) {
        [JRToast showWithText:@"请选择购买张数" duration:2];
        return;
    }
    [self getOrderID];
}
//使用优惠券
-(void)useCouponActionTouch:(UIButton *)sender{
    UseCouponViewController * useVC = [[UseCouponViewController alloc]init];
    useVC.shop_id = self.cinemaCode;
    useVC.delegate = self;
    useVC.couponType = 1;//标识是电影
    useVC.total_money = [NSString stringWithFormat:@"%@",self.total_money];
    
    [self.navigationController pushViewController:useVC animated:YES];
}

//使用了优惠券
- (void)DelegateGetCouponInfo:(CouponModel *)model{
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    OtherTicketPayTableViewCell * cell = (OtherTicketPayTableViewCell*)[_payTableView cellForRowAtIndexPath:path];
    self.is_coupon = YES;
    self.coupon_id = model.coupon_id ;
    cell.discountMoneyLabel.text = [NSString stringWithFormat:@"优惠:￥%@",model.discount_fee];
    [cell.couponBtn setTitle:[NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee] forState:UIControlStateNormal];
    
    NSString*aa=model.discount_fee;
    self.coupon_money=[aa floatValue];
    [self accountPayMoney];
    [self.payTableView reloadData];
    
    
    
}

//计算所需要支付的金额
-(void)accountPayMoney{
    self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",self.shouldPay_money - self.coupon_money];
    
}
-(void)reduceOrAddTicket:(NSInteger)status{

    switch (status) {
        case 1:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney +[self.model.price floatValue]/100];
            self.shouldPay_money = settmentMoney +[self.model.price floatValue]/100;
            
            self.ticketNumber = self.ticketNumber +1;
        }
            break;
            
        default:
        {
            CGFloat settmentMoney = [[self.settmentMoneyLabel.text substringFromIndex:4] floatValue];
            self.settmentMoneyLabel.text = [NSString stringWithFormat:@"待结算￥%.2f",settmentMoney - [self.model.price floatValue]/100];
            self.shouldPay_money = settmentMoney - [self.model.price floatValue]/100;
            self.ticketNumber = self.ticketNumber -1;
        }
            break;
    }
}

- (void)getOrderID{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_GETORDERID];
    NSString * number = [NSString stringWithFormat:@"%zi",self.ticketNumber];
    NSString * isCoupon = [NSString stringWithFormat:@"%d",self.is_coupon];
    NSString * coupon_moneyStr = [NSString stringWithFormat:@"%.2f",self.coupon_money];
    //有效期转时间戳
   NSString * day = [JWTools dateTimeStrDate:[self.model.validDays integerValue]];
    
    
    NSDictionary * pragrams = @{@"mobile":self.iphone,@"ticketNo":self.model.ticketNo,@"ticketName":self.model.ticketName,@"devicePos":self.model.devicePos,@"validateMemo":self.model.validateMemo,@"price":self.model.price,@"count":number,@"cinema_code":self.cinemaCode,@"is_coupon":isCoupon,@"coupon_money":coupon_moneyStr,@"show_type":self.model.showType,@"period_validity":day,@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"percentage":self.model.percentage,@"per_price":self.model.per_price};
   
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if (self.is_coupon) {
        [dic setValue:self.coupon_id forKey:@"coupon_id"];
        
    }
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"通兑票订单%@",data);
        if ([data[@"errorCode"] integerValue]== 0) {
            self.orderID = data[@"data"][@"id"];
            self.pay_money = data[@"data"][@"pay_money"];
            self.total_money= data[@"data"][@"total_money"];
            PCPayViewController * pcVC = [PCPayViewController sharedManager];
            pcVC.blanceMoney = [self.total_money floatValue];
            pcVC.status = 2;
            pcVC.order_id = [self.orderID floatValue];
            pcVC.shop_ID = self.cinemaCode;
            pcVC.orderCode = data[@"data"][@"order_code"];
            [self.navigationController pushViewController:pcVC animated:YES];
        }
        
     }];
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 65)];
        UILabel * markLaber = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, 28)];
        markLaber.centerX = kScreen_Width/2;
        markLaber.textColor = [UIColor colorWithHexString:@"#333333"];
        markLaber.textAlignment = 1;
        markLaber.font = [UIFont systemFontOfSize:13];
        markLaber.text = @"取票码将发送至如下手机号，请注意查收";
        [_footView addSubview:markLaber];


    }
    return _footView;
}
- (UIView*)footViewTwo{
    if (!_footViewTwo) {
        _footViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
        UILabel * markLaber = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, kScreen_Width, 20)];
        markLaber.textColor = [UIColor colorWithHexString:@"#333333"];
        markLaber.textAlignment = 0;
        markLaber.font = [UIFont systemFontOfSize:13];
        markLaber.text = @"○注意事项";
        [_footViewTwo addSubview:markLaber];
        
        UILabel*firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, markLaber.bottom, kScreen_Width-48, 25)];
        firstLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        firstLabel.textAlignment = 0;
        firstLabel.font = [UIFont systemFontOfSize:13];
        firstLabel.numberOfLines = 0;
        firstLabel.text = @"1、情人节、圣诞节、平安夜、VIP厅、明星见面会以及首映不可用";
        CGRect height = [firstLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: firstLabel.font} context:nil];
        firstLabel.frame= CGRectMake(24, markLaber.bottom+10, kScreen_Width-48 , height.size.height);
        [_footViewTwo addSubview:firstLabel];
        
        UILabel*secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, firstLabel.bottom, kScreen_Width-48, 25)];
        secondLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        secondLabel.textAlignment = 0;
        secondLabel.numberOfLines = 0;
        secondLabel.font = [UIFont systemFontOfSize:13];
        secondLabel.text = @"2、支付成功，凭手机接收的验证码短信，在影院前台选座出票";
        CGRect height2 = [secondLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: secondLabel.font} context:nil];
        secondLabel.frame= CGRectMake(24, firstLabel.bottom+5, kScreen_Width-48 , height2.size.height);
        [_footViewTwo addSubview:secondLabel];
        
        UILabel*thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, secondLabel.bottom, kScreen_Width-48, 25)];
        thirdLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        thirdLabel.textAlignment = 0;
        thirdLabel.numberOfLines = 0;
        thirdLabel.font = [UIFont systemFontOfSize:13];
        thirdLabel.text = @"3、温馨提示:如遇特殊影片需补差价，具体金额按影城公告到前台补差，给您造成不便，敬请见谅";
        CGRect height3 = [thirdLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-48, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: thirdLabel.font} context:nil];
        thirdLabel.frame= CGRectMake(24, secondLabel.bottom+5, kScreen_Width-48 , height3.size.height);
        [_footViewTwo addSubview:thirdLabel];
        
        
    }
    return _footViewTwo;
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

@end
