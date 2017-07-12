//
//  YWPayViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayViewController.h"

#import "inputNumberCell.h"
#import "ZheTableViewCell.h"
#import "TwoLabelShowTableViewCell.h"
#import "AccountMoneyTableViewCell.h"      //账户余额
#import "JWTools.h"
#import "YWLoginViewController.h"

#import "PCPayViewController.h"    //充值界面
#import "CouponViewController.h"



#define CELL0  @"inputNumberCell"
#define CELL1  @"ZheTableViewCell"
#define CELL2  @"TwoLabelShowTableViewCell"
#define CELL3  @"AccountMoneyTableViewCell"

@interface YWPayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CouponViewControllerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel*shouldPayMoneyLabel; //实际要付钱的label
@property(nonatomic,strong)UIButton*payMoneyButton;   //确认付款的button
@property(nonatomic,strong)UILabel*couponLabel;   //使用抵用券按钮

@property(nonatomic,assign)CGFloat shouldPayMoney;   //应该支付的钱（减去了折扣的）
@property(nonatomic,assign)CGFloat CouponMoney;    //优惠券减少多少钱。
@property(nonatomic,assign)CGFloat noCouponPayMoney;  //没有减去折扣需要付的钱

@property(nonatomic,assign)BOOL is_coupon;   //是否用优惠券
@property(nonatomic,assign)int coupon_id;

@end

@implementation YWPayViewController

//手动支付
+(instancetype)payViewControllerCreatWithWritePayAndShopNameStr:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou{
    
   YWPayViewController *payVC = [[self alloc] init];
    payVC.shopName=shopName;
    payVC.shopID=shopID;
    payVC.shopZhekou=shopZhekou;

    payVC.whichPay=PayCategoryWritePay;
   
    
    
    return payVC;
}

//扫码支付
+(instancetype)payViewControllerCreatWithQRCodePayAndShopNameStr:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou andpayAllMoney:(CGFloat)payAllMoney andNOZheMoney:(CGFloat)NOZheMoney{
    
    YWPayViewController *payVC = [[self alloc] init];
    payVC.shopName=shopName;
    payVC.shopID=shopID;
    payVC.shopZhekou=shopZhekou;
    payVC.payAllMoney=payAllMoney;
    payVC.NOZheMoney=NOZheMoney;
    
    
    payVC.whichPay=PayCategoryQRCodePay;

    return payVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"优惠买单";

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"inputNumberCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZheTableViewCell" bundle:nil] forCellReuseIdentifier:CELL1];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelShowTableViewCell" bundle:nil] forCellReuseIdentifier:CELL2];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:CELL3];
    
    

    
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1.0];
    
    
    
}


#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
        
    }else if (section==1){
        return 2;
        
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section==0&&indexPath.row==0) {
        //消费总额
        cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        UILabel*titleLabel=[cell viewWithTag:1];
        titleLabel.text=@"消费总额";
        
        UITextField*textField=[cell viewWithTag:2];
        textField.delegate=self;
//        textField.keyboardType=UIKeyboardTypeNamePhonePad;
        textField.placeholder=@"请输入金额";
        //扫码
        if (self.whichPay==PayCategoryQRCodePay) {
            textField.userInteractionEnabled=NO;
            textField.text=[NSString stringWithFormat:@"%.2f",self.payAllMoney];
        }
        
        
        
        return cell;
        
    }else if (indexPath.section==0&&indexPath.row==1){
        //非打折金额
        cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        UITextField*textField=[cell viewWithTag:2];
        textField.keyboardType=UIKeyboardTypeNamePhonePad;
        
        UILabel*titleLabel=[cell viewWithTag:1];
        titleLabel.text=@"非打折金额";
        
//        UITextField*textField2=[cell viewWithTag:2];
        textField.delegate=self;
        textField.placeholder=@"（选填）";

        //扫码
        if (self.whichPay==PayCategoryQRCodePay) {
            textField.userInteractionEnabled=NO;
            textField.text=[NSString stringWithFormat:@"%.2f",self.NOZheMoney];
        }
        
        
    }else if (indexPath.section==0&&indexPath.row==2){
        //打几折
        cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        
        UILabel*zhekouLabel=[cell viewWithTag:2];
        NSString*strZhekou=[NSString stringWithFormat:@"%.2f",self.shopZhekou];
        NSString* zhe=[strZhekou substringFromIndex:2];
        CGFloat zhekou = [zhe floatValue]/10;
        NSString*zheStr=[NSString stringWithFormat:@" %.1f折",zhekou];
        if (self.shopZhekou>=1 || self.shopZhekou<= 0.00) {
            zheStr=@"不打折";
            
        }
        
        NSString*firstStr=@"雨娃支付立享";
        NSMutableAttributedString*aa=[[NSMutableAttributedString alloc]initWithString:firstStr attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSMutableAttributedString*bb=[[NSMutableAttributedString alloc]initWithString:zheStr attributes:@{NSForegroundColorAttributeName:CpriceColor}];
        [aa appendAttributedString:bb];
            zhekouLabel.attributedText=aa;
        
        
        return cell;

    }
    

    
    
    //section 1
    else if (indexPath.section==1&&indexPath.row==0){
        cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
        UILabel*label1=[cell viewWithTag:1];
        label1.text=@"抵用券";
        
        UILabel*label2=[cell viewWithTag:2];
        label2.text=@"使用抵用券";
        self.couponLabel=label2;
        
        return cell;
        
    }else if (indexPath.section==1&&indexPath.row==1){
        cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
        UILabel*label1=[cell viewWithTag:1];
        label1.text=@"实付金额";
        
        UILabel*label2=[cell viewWithTag:2];
        self.shouldPayMoneyLabel=label2;
        [self calshouldPayMoney];
        
    }
    

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==0) {
        //使用优惠券
        CouponViewController*vc=[[CouponViewController alloc]init];
        vc.delegate=self;
        vc.shopID=self.shopID;
        vc.totailPayMoney=self.noCouponPayMoney;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 44;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 50;
    }
    
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        backView.backgroundColor=[UIColor whiteColor];
        
        UILabel*showLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreen_Width/3*2, 20)];
        showLabel.font=[UIFont systemFontOfSize:14];
        showLabel.text=self.shopName;
        [backView addSubview:showLabel];
        
        return backView;
    }
    return nil;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        bottomView.backgroundColor=[UIColor clearColor];
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, kScreen_Width-20, 40)];
        [button setTitle:@"确认付款" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchPay) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=CNaviColor;
        button.layer.cornerRadius=6;
        button.layer.masksToBounds=YES;
        _payMoneyButton=button;
        [bottomView addSubview:button];
        
        
        return bottomView;
        
    }
    return nil;
}


#pragma mark  --touch
-(void)touchPay{
    //确认付款的时候 先生成订单
    [self jiekouADDOrder];
   
}



#pragma mark  --datas
-(void)jiekouADDOrder{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];

    
    
    if (self.payAllMoney<self.NOZheMoney) {
        [JRToast showWithText:@"不打折金额不能大于消费总金额"];
        return;
    }

    
    
    if (self.payAllMoney==0) {
        [JRToast showWithText:@"请输入消费总额"];
        return;
    }
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MAKEORDER];
    NSDictionary*dict=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"seller_uid":self.shopID,@"total_money":@(self.payAllMoney),@"non_discount_money":@(self.NOZheMoney),@"discount":@(self.shopZhekou),@"is_coupon":@(self.is_coupon)};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if (self.is_coupon==YES) {
        [params setObject:@(self.coupon_id) forKey:@"coupon_id"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            CGFloat shouldPay=[data[@"data"][@"data"][@"pay_money"] floatValue];
            CGFloat  order_id=[data[@"data"][@"data"][@"order_id"] floatValue];
            PCPayViewController*vc=[[PCPayViewController alloc]init];
            vc.blanceMoney=shouldPay;
            vc.order_id=order_id;
            vc.shop_ID = self.shopID;
            MyLog(@"%f",order_id);
            [self.navigationController pushViewController:vc animated:YES];

            
            
        }else if ([errorCode isEqualToString:@"9"]){
            
            [JRToast showWithText:@"身份已过期,请重新登入" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController *vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        
    }];
    
    
}

#pragma mark  --delegate
//使用了优惠券
-(void)DelegateGetCouponInfoOld:(CouponModel *)model{
    self.is_coupon=YES;
    self.coupon_id=[model.coupon_id intValue];
    
    self.couponLabel.text=[NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee];
    
    NSString*aa=model.discount_fee;
    self.CouponMoney=[aa floatValue];
    [self calshouldPayMoney];
   
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return NO;
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField*textZero=[cell viewWithTag:2];
    
    UITableViewCell*cell2=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField*textOne=[cell2 viewWithTag:2];
    
    
    if ([textField isEqual:textZero]) {
      
        NSString*str=textZero.text;
        CGFloat aa=[str floatValue];
        self.payAllMoney=aa;
        
    }else{
        NSString*str=textOne.text;
        CGFloat aa=[str floatValue];
        self.NOZheMoney=aa;
        
    }
    
    //计算所要支付的钱
    [self calshouldPayMoney];
    
}

// 实付金额= （总消费额-非打折额）*折扣-抵用券
//然后支付按钮 当账户余额 大于等于实付金额  那么显示 立即支付，  否则就显示  需要充值xx.00

#pragma 计算所要支付的钱
-(void)calshouldPayMoney{
    
    self.noCouponPayMoney=(self.payAllMoney-self.NOZheMoney)*self.shopZhekou+self.NOZheMoney;
    
    //不能小于
    if (self.payAllMoney<self.NOZheMoney) {
        
        [JRToast showWithText:@"不打折金额不能大于消费总额"];
//        UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        UITextField*textField=[cell viewWithTag:2];
//        textField.text=@"0";
//
//        
//        self.NOZheMoney=0;
    
        return;
    }
    
    
    
    CGFloat payMoney=(self.payAllMoney-self.NOZheMoney)*self.shopZhekou+self.NOZheMoney-self.CouponMoney;
    self.shouldPayMoney=payMoney;
    
    //需要支付的钱
    self.shouldPayMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",self.shouldPayMoney];
    
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

@end
