//
//  PCPayViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCPayViewController.h"
#import "AccountMoneyTableViewCell.h"
#import "PostCommitViewController.h"

#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

#import "Order.h"
#import "APAuthV2Info.h"
//#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+JWAppendOtherStr.h"

//applePay
#import "UPAPayPluginDelegate.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPAPayPlugin.h"
#import <PassKit/PassKit.h>
#import "UPPaymentControl.h"


#import "OrderDetailViewController.h"
#define CELL3  @"AccountMoneyTableViewCell"


@interface PCPayViewController ()<UITableViewDataSource,UITableViewDelegate,UPAPayPluginDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel*needPayLabel;  //需要支付的钱
@property(nonatomic,strong)UISwitch*Myswitch;
/* 电影支付 */
@property (nonatomic, strong)NSTimer * cinemaTimer;
@property (nonatomic,assign)NSInteger second;
@property (nonatomic,assign)NSInteger minute;
@property (nonatomic,strong)UILabel * timerLabel;

@property (nonatomic,assign)BOOL isPaySuccess;//判断是否支付成功
@property(nonatomic,assign)CGFloat accountMoney;  //账户余额   这个吊接口
@property(nonatomic,assign)BOOL isSelectedOn;  //选择了是否使用余额
@property(nonatomic,assign)CGFloat needPayMoney;  //需要付的钱
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation PCPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title=@"支付";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL3 bundle:nil] forCellReuseIdentifier:CELL3];
    [self getAccountMoney];//接口得到账户金额
    
    if (self.status == 1) {
        [self.navigationItem setHidesBackButton:YES];
        self.isPaySuccess = NO;
    self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, kScreen_Width/2, 100)];
    
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.second = 59;
    self.minute = 14;
    self.navigationItem.titleView = self.timerLabel;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backBtn;

    }
    
    
}
//返回，释放座位
- (void)backAction{
    if (self.isPaySuccess) {
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:2] animated:YES];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"返回将取消您的订单,是否继续" preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self releaseSeat];
            
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
    }

}

- (void)timeHeadle{
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        
    }
    
    self.timerLabel.text = [NSString stringWithFormat:@"支付订单 %ld:%ld",(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 ) {
        [self.timer invalidate];
        self.timer = nil;
        [self quitPayPage];
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark - 倒计时

- (void)quitPayPage{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您选择场次信息已过期或者支付超时，请重新选座购买" preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (void)popToPage{
    
    [self quitPayPage];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 3;
    }
    
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0&&indexPath.row==0) {
        //是否 开启余额支付
        cell=[tableView dequeueReusableCellWithIdentifier:CELL3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel*label1=[cell viewWithTag:1];
        label1.text=@"雨娃余额";
        
        UILabel*labelMoney=[cell viewWithTag:2];
        labelMoney.text=[NSString stringWithFormat:@"￥%@",[UserSession instance].money];
        
        UISwitch*sButton=[cell viewWithTag:3];
        [sButton setOn:NO];
//        sButton.userInteractionEnabled=NO;
        [sButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        self.Myswitch=sButton;
        return cell;
 
        
       
    }
    
    
    
    if (indexPath.section==1&&indexPath.row==0) {
        
      
        cell.textLabel.text=@"微信支付";
        
        //2、调整大小
        UIImage *image = [UIImage imageNamed:@"wechatPay"];
        CGSize imageSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsGetImageFromCurrentImageContext();
    }else if (indexPath.section==1&&indexPath.row==1){

        cell.textLabel.text=@"支付宝支付";
        
        //2、调整大小
        UIImage *image = [UIImage imageNamed:@"zhifubaoPay"];
        CGSize imageSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsGetImageFromCurrentImageContext();
        
    }else if (indexPath.section==1&&indexPath.row==2){
        
        cell.textLabel.text=@"银联在线支付";
        
        //2、调整大小
        UIImage *image = [UIImage imageNamed:@"yinlianpay"];
        CGSize imageSize = CGSizeMake(30, 25);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsGetImageFromCurrentImageContext();

        
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.section==1&&indexPath.row==0) {
        [self payWith:@"weixin"];
            
        
    }else if (indexPath.section==1&&indexPath.row==1){
        
        [self payWith:@"ali"];
        
//        //支付宝支付
//        [self doAlipayPay];
        
    }else if (indexPath.section==1&&indexPath.row==2){
        //apple pay
        MyLog(@"银联支付");
        [self payWith:@"unionpay"];

        //        [self makeApplePay];
        
    }
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 160)];
        topView.backgroundColor=RGBCOLOR(60, 140, 217, 1);
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        titleLabel.text=@"实际支付：￥";
        titleLabel.font=[UIFont systemFontOfSize:17];
        titleLabel.centerY = topView.centerY + 5;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment=NSTextAlignmentRight;
        titleLabel.attributedText = [NSString stringWithFirstStr:@"实际支付:" withFont:[UIFont systemFontOfSize:17.f] withColor:[UIColor whiteColor] withSecondtStr:@" ￥" withFont:[UIFont systemFontOfSize:43] withColor:[UIColor whiteColor]];
        [topView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(topView.mas_left).offset(15);
            make.top.mas_equalTo(@(50));
            make.right.mas_equalTo(topView.mas_centerX);
        }];
        //    titleLabel.centerY = topView.centerY + 5;
        UITextField*textField=[[UITextField alloc]initWithFrame:CGRectZero];
        textField.font=[UIFont systemFontOfSize:43];
        textField.userInteractionEnabled=NO;
        //    textField.placeholder=@"请输入金额";
        //    if (self.blanceMoney!=0) {
        
        textField.text=[NSString stringWithFormat:@"%.2f",self.blanceMoney];
        //    }
        textField.textColor=[UIColor whiteColor];
        [topView addSubview:textField];
        ////    textField.centerY = topView.centerY;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.left.mas_equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(self.view.right);
            
        }];
        return topView;
    }else if (section==1) {
        UIView*backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        backView.backgroundColor=[UIColor whiteColor];
        
        UILabel*leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 20)];
        leftLabel.font=[UIFont systemFontOfSize:14];
        leftLabel.text=@"请选择支付方式:";
        [backView addSubview:leftLabel];

        
        
        return backView;

    }
    
    return nil;
  }

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 40;
    }
    
    return 170;
}


#pragma mark  --touch
-(void)switchAction:(UISwitch*)sender{
   
    self.isSelectedOn=sender.on;
   
    if (self.isSelectedOn) {

        [self pushAlertView];

    }
}
#pragma mark ---alertViewDelegat
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
//    PostCommitViewController * commitVC = [[PostCommitViewController alloc]init];
//    commitVC.order_id = [NSString stringWithFormat:@"%.0f",self.order_id];
//    commitVC.shop_id = self.shop_ID;
//    [self.navigationController pushViewController:commitVC animated:YES];
}
-(void)pushAlertView{
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"余额支付" message:@"确实要用余额支付？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //接口
        if (self.blanceMoney <= self.accountMoney) {
            [self BlancePayDatas];
            
        }else{
             [self.Myswitch setOn:NO];
            [JRToast showWithText:@"账户余额不足"];
        }
        
    }];
    
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.Myswitch setOn:NO];
        
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- 银联支付
- (void)makeYinlianPay:(NSString *)tn{
    MyLog(@"orderString = %@",tn);
    if (tn != nil &&tn.length>0) {
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"payBackShemes" mode:@"00" viewController:self];
    }
    if ([[UPPaymentControl defaultControl]isPaymentAppInstalled]) {
   
    }else{
        [JRToast showWithText:@"请稍等..." duration:2.f];
//        [JRToast showWithText:@"您未安装银联支付APP"];
    }
    AppDelegate*delegate   =(AppDelegate*)  [UIApplication sharedApplication].delegate;
    WEAKSELF;
    delegate.unionpayBlock=^(NSDictionary*resultDic){
        if (weakSelf.status == 1) {
            [weakSelf judgeMoviePaySuccessOrNot];
        }else if(weakSelf.status == 2){
            //通兑票查询支付结果
            [weakSelf judgeMoviePaySuccessOrNot];
        }else{
            [weakSelf judgePaySuccessOrNot];
        }
    };

}


#pragma mark  --  applePay
-(void)makeApplePay{
#pragma mark 先需要调 接口  来获取tn的信息         这个 01测试模式      00是正式模式     这里需要后台对接  后台没对接
    NSString*tnMode=@"00";
     NSString* tn = @"798394209868293893400";
    
    if([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]])
    {
        
        [UPAPayPlugin startPay:tn mode:tnMode viewController:self delegate:self andAPMechantID:@"merchant.cn.duruikeji.YuWa"];
    }else{
        [JRToast showWithText:@"您的系统不支持"];
    }

    
    
    
}


#pragma mark -
#pragma mark 响应控件返回的支付结果
#pragma mark -
- (void)UPAPayPluginResult:(UPPayResult *)result
{
    if(result.paymentResultStatus == UPPaymentResultStatusSuccess) {
        NSString *otherInfo = result.otherInfo?result.otherInfo:@"";
        NSString *successInfo = [NSString stringWithFormat:@"支付成功\n%@",otherInfo];
     
        [JRToast showWithText:successInfo];
        
    }
    else if(result.paymentResultStatus == UPPaymentResultStatusCancel){
        
       
         [JRToast showWithText:@"支付取消"];
    }
    else if (result.paymentResultStatus == UPPaymentResultStatusFailure) {
        
        NSString *errorInfo = [NSString stringWithFormat:@"%@",result.errorDescription];
     
        [JRToast showWithText:errorInfo];
    }
    else if (result.paymentResultStatus == UPPaymentResultStatusUnknownCancel)  {
        
        //TODO UPPAymentResultStatusUnknowCancel表示发起支付以后用户取消，导致支付状态不确认，需要查询商户后台确认真实的支付结果
        NSString *errorInfo = [NSString stringWithFormat:@"支付过程中用户取消了，请查询后台确认订单"];
    
        [JRToast showWithText:errorInfo];
        
    }
}



#pragma mark --  支付宝支付
- (void)doAlipayPay:(NSString*)orderString
{
  
//    //重要说明
//    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
//    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
//    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *appID = @"2016030901196933";
//    NSString *privateKey = @"MIICXAIBAAKBgQDoZ//0A8Msvns4NUq8oq3ZNqbR6hfkcHGS5KGjuqiTlXjV4sdpubISPqs7cJQUrzbJUuQrEVfRw2Ips9Pytovc6vbTFKIuU8wdpsbaRHt8G2TiMF6TOq8+oj/X2z8+QIihvKlPtoFgH5l2jf9UCdrpPzBm0IuGhNfEJgZ/gHLJAwIDAQABAoGAYPo8uML1J2+YlTzPoeU0LAZ9F+zZ6W3uRoB23o5eF69wi7ekxH5DSw+xfg0dDYCLmPio0zvabGJeTM6IK6h2tX4Du6gVXyogzmBu8XL/ohogHMCvf3tD9vxwNKBAITdGcdh3GnPPEiOgyD0yDIIQx5+J+Ru409yrXeZkunAP/ckCQQD7GS0LktCN4n6rpxkXuOXN8j6wnLT9v3WAJOo8WbcyvxTpQsmjXLSHUYlA8MB13TEX34rl0JOmV/LshocE1NVFAkEA7PFpwEuczBT1YeDuz6TMhlMEjFiBrU3TXt3ki6Iyl/O4lxF1oytaysHUU1q0Tb39zDd5j9pEBp5/dP5d5PkVpwJAA2b77UQ3/zQqczj4ZhHjSz8VCl+VNDr75Jibc+XjTZS5O8/j24rOB2dbbL3WXcJ5f9FPmH2TApX+fKX1/mLD4QJAEcQgO8zvmtXPeGFXRraCp2e+JY/VWVtGiAx3QIkO5hneM2WZvnxXuHBELWPVtSaTyyY1tTWWeDCWOf2AqNSMbQJBAMOewDNHrAVeHQFTWh8mO+KupLl7zHapt1UeFYKol00nETr+GllRMEBGFboH40tq3sDI+SJjTPqZ+iJDGEp6KqI=";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([appID length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少appId或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order* order = [Order new];
//    
//    // NOTE: app_id设置
//    order.app_id = appID;
//    
//    // NOTE: 支付接口名称
//    order.method = @"alipay.trade.app.pay";
//    
//    // NOTE: 参数编码格式
//    order.charset = @"utf-8";
//    
//    // NOTE: 当前时间点
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    order.timestamp = [formatter stringFromDate:[NSDate date]];
//    
//    // NOTE: 支付版本
//    order.version = @"1.0";
//    
//    // NOTE: sign_type设置
//    order.sign_type = @"RSA";
//    
//    // NOTE: 商品数据
//    order.biz_content = [BizContent new];
//    order.biz_content.body = @"我是测试数据";
//    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.biz_content.timeout_express = @"30m"; //超时时间设置
//    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
//    
//    //将商品信息拼接成字符串
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
//    
//    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
////    id<DataSigner> signer = CreateRSADataSigner(privateKey);
////    NSString *signedString = [signer signString:orderInfo];
//    NSString * signedString=@"1234214214124124124";
//    
//    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
//
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];

        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"支付成功" preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.status == 1) {
                    [self judgeMoviePaySuccessOrNot];
                }else if(self.status == 2){
                    //通兑票查询支付结果
                    [self judgeMoviePaySuccessOrNot];
                }else{
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"deleteNun" object:nil userInfo:@{@"isClear":@(1)}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                //创建一个消息对象
                NSNotification * deleMoney = [NSNotification notificationWithName:@"deleteTotalMoney" object:nil userInfo:@{@"isClearMoney":@(1)}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:deleMoney];

                [self pushToPostComment:self.shop_ID];
                }
//                [self clearShopCar:self.shop_ID];
//                PostCommitViewController * commitVC = [[PostCommitViewController alloc]init];
//                commitVC.order_id = [NSString stringWithFormat:@"%.0f",self.order_id];
//                commitVC.shop_id = self.shop_ID;
//                [self.navigationController pushViewController:commitVC animated:YES];
//            }];
//                [alertVC addAction:sure];
//                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }];
   
    AppDelegate*delegate   =(AppDelegate*)  [UIApplication sharedApplication].delegate;
    WEAKSELF;
    delegate.aliPayBlock=^(NSDictionary*resultDic){
        
        if (weakSelf.status != 0) {
            [weakSelf judgeMoviePaySuccessOrNot];
        }else{
            [weakSelf judgePaySuccessOrNot];
        }
    };
    
}


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


#pragma mark  --jiekou
//得到余额
-(void)getAccountMoney{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETMONEY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
        NSInteger number=[data[@"errorCode"] integerValue];
        if (number==0) {
            [UserSession instance].money=data[@"data"][@"money"];
            
            self.accountMoney=[[UserSession instance].money floatValue];
            self.isSelectedOn=YES;
        
            [self switchAction:self.Myswitch];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        [self.tableView reloadData];
        
        
    }];
    
    
}

//全部用余额支付的接口
-(void)BlancePayDatas{
    NSString*urlStr;
    NSDictionary*params;
    if (self.status == 1 || self.status == 2) {
        //电影的订单
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_BALANCEPAY];
        NSString * order_ids = [NSString stringWithFormat:@"%.0f",self.order_id];
        params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":order_ids};

    }else{
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BALANCE_PAY];
        NSString * order_ids = [NSString stringWithFormat:@"%.0f",self.order_id];
        params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":order_ids};
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {   
//        MyLog(@"%@",data);
        NSInteger number=[data[@"errorCode"] floatValue];
        if (number==0) {
//            [JRToast showWithText:data[@"data"]];
            [self.Myswitch setOn:NO];
            [self getAccountMoney];
            if (self.status ==0) {

            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"deleteNun" object:nil userInfo:@{@"isClear":@(1)}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            //创建一个消息对象，清空价格
            NSNotification * deleMoney = [NSNotification notificationWithName:@"deleteTotalMoney" object:nil userInfo:@{@"isClearMoney":@(1)}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:deleMoney];
            [self pushToPostComment:self.shop_ID];
                
            }else if(self.status == 1 || self.status == 2){
                //去查询订单支付结果
                [self judgeMoviePaySuccessOrNot];
            }
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            [self.Myswitch setOn:NO];
        }
        
    }];
    
    
}
//查询选座票订单状态
-(void)checkOrderStatus{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_ORDERSTATUS];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"orderCode":self.orderCode};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",params);
        MyLog(@"订单状态%@",data);
        if ([data[@"errorCode"] integerValue ] == 0) {
            [JRToast showWithText:data[@"data"] duration:2];
            self.isPaySuccess = YES;
            if (self.timer) {
                
                [self.timer invalidate];
                self.timer = nil;
            }
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
            });
        }else if([data[@"errorCode"] integerValue ] == 1){
            self.isPaySuccess = NO;
            [JRToast showWithText:@"购买失败" duration:2];
            if (self.timer) {
                
                [self.timer invalidate];
                self.timer = nil;
            }
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
                  });
        }else if([data[@"errorCode"] integerValue ] == 3){
            [JRToast showWithText:data[@"errorMessage"]];
            
        }else{
            static int a = 0;
            if (a>15) {
                return ;
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
           a ++;
            
        }
    }];
}
- (void)checkStatus{
    
    [self checkOrderStatus];
}
//确认通兑票订单
- (void)sureOrder{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_SUREOTHERTICKETORDER];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_code":self.orderCode};
    HttpManager * manage = [[HttpManager alloc]init];
 
    [manage postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",params);
        MyLog(@"确认通兑票订单%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"msg"] duration:2];
            OrderDetailViewController * vc = [[OrderDetailViewController alloc]init];
            vc.order_id = [NSString stringWithFormat:@"%.0f",self.order_id];
            vc.status = 1;
//            data = {
//                amount = 1,
//                code = 001,
//                orderTime = 2017-05-26 14:01:32,
//                msg = 操作成功,
//                orderNo = 1000284233
//            },
//            errorCode = 0
//        }
    }
    }];
    
}

//判断电影支付成功  还是 失败
-(void)judgeMoviePaySuccessOrNot{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_JUADGEPAYRESURT];
    NSString * order_ids = [NSString stringWithFormat:@"%f",self.order_id];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":order_ids};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",params);
        MyLog(@"判断支付结果%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            if ([data[@"data"][@"is_paid"] integerValue] == 1) {
                self.isPaySuccess = YES;
//                [JRToast showWithText:@"支付成功" duration:1];
                [self getAccountMoney];
                if (self.status == 1) {
                    
                    [self checkStatus];
                }else if (self.status == 2){
                    
                    [self sureOrder];
            }
            }else{
                self.isPaySuccess = NO;
                [JRToast showWithText:@"支付失败" duration:1];
            }
        }
    }];
}
-(void)payWith:(NSString*)aa{
    
    NSString*urlStr;
    if (self.status ==1 || self.status == 2) {
      urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_PAY_FILMNOBALANCEPAY]; 
    }else{
      urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_THIRD_PAY];
    }
    NSString * isSelectOnStr = [NSString stringWithFormat:@"%d",self.isSelectedOn];
    NSString * orderIDStr = [NSString stringWithFormat:@"%.0f",self.order_id];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":orderIDStr,@"is_balance":isSelectOnStr,@"pay_method":aa};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSInteger number=[data[@"errorCode"] integerValue];
        if (number==0) {
            //微信支付还是支付宝支付
            if ([aa isEqualToString:@"ali"]) {
                //支付宝
                NSString*orderString=data[@"data"][@"pay_sign"];
                [self doAlipayPay:orderString];
                
            }else if([aa isEqualToString:@"weixin"]){
                //微信

                [self TowechatPay:data[@"data"]];
                
            }else if([aa isEqualToString:@"unionpay"]){
                NSString*orderString=data[@"data"][@"tn"];
                [self makeYinlianPay:orderString];
            }
        
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}


//判断支付成功  还是 失败
-(void)judgePaySuccessOrNot{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PAY_RESULT];
    NSString * order_ids = [NSString stringWithFormat:@"%f",self.order_id];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":order_ids};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSInteger number=[data[@"errorCode"] integerValue];
        if (number==0) {
            NSInteger reslut = [data[@"data"][@"is_paid"] integerValue];
            if (reslut == 1) {
            [UserSession instance].money=data[@"data"][@"money"];

//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:@"成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alert show];
                [self pushToPostComment:self.shop_ID];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"deleteNun" object:nil userInfo:@{@"isClear":@(1)}];
                //发送消息isClearMoney
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                //创建一个消息对象
                NSNotification * deleMoney = [NSNotification notificationWithName:@"deleteTotalMoney" object:nil userInfo:@{@"isClearMoney":@(1)}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:deleMoney];

            }else{
                [JRToast showWithText:@"支付失败"];
            }
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
//
        }
        
        
    }];
    
    
}
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//        
//    PostCommitViewController * vc = [[PostCommitViewController alloc]init];
//    vc.stauts = 1;
//    MyLog(@"%@%f",self.orderID,self.order_id);
//    vc.order_id = [NSString stringWithFormat:@"%zi",self.order_id];
//    vc.shop_id = self.shop_ID;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
#pragma mark  -- 微信支付
-(void)TowechatPay:(NSDictionary*)dict{
    
    
    //吊用接口  得到6个参数的数据 让后台传给你
    
    PayReq* req  = [[PayReq alloc] init];
    req.partnerId           = dict[@"partnerid"];
    req.prepayId            = dict[@"prepayid"];
    req.nonceStr            = dict[@"noncestr"];
    req.timeStamp           = [dict[@"timestamp"] intValue];
    req.package             = dict[@"package"];
    req.sign                = dict[@"sign"];
   
    [WXApi sendReq:req];
    
};



#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        PayResp * resopnse = (PayResp*)resp;
        switch (resopnse.errCode) {
            case WXSuccess:
            {
//                EMError *error = [[EMClient sharedClient].contactManager addContact:model.hxID message:@"我想加您为好友"];
                strMsg = @"支付结果：成功！";
                if (self.status == 1) {
                    [self judgeMoviePaySuccessOrNot];
                }else if(self.status == 2){
                    //通兑票查询支付结果
                    [self judgeMoviePaySuccessOrNot];
                }else{
                //发送消息  //清空详情页面勾选物品，数据
//                ShopDetailViewController
                NSNotification * notice = [NSNotification notificationWithName:@"deleteNun" object:nil userInfo:@{@"isClear":@(1)}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                //创建一个消息对象
                NSNotification * deleMoney = [NSNotification notificationWithName:@"deleteTotalMoney" object:nil userInfo:@{@"isClearMoney":@(1)}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:deleMoney];

//                PostCommitViewController * commitVC = [[PostCommitViewController alloc]init];
//                commitVC.order_id = [NSString stringWithFormat:@"%.0f",self.order_id];
//                commitVC.shop_id = self.shop_ID;
//                [self.navigationController pushViewController:commitVC animated:YES];
             
                [self pushToPostComment:self.shop_ID];
                //清空购物车商品，有shopid的时候在解注释调用
                [self clearShopCar:self.shop_ID];
                }
        }
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
        }

        
    }
    
}
- (void)pushToPostComment:(NSString * )shop_id{
    WEAKSELF;
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"支付结果" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PostCommitViewController * vc = [[PostCommitViewController alloc]init];
        vc.shop_id = shop_id ;
        vc.order_id = [NSString stringWithFormat:@"%f",weakSelf.order_id] ;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)clearShopCar:(NSString *)shop_id{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_CLEARSHOPCARLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":shop_id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"清空购物车%@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
        }
    }];
}
//释放座位
- (void)releaseSeat{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CANCEL_RESEASESEAT];
    
    NSDictionary * dict = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"orderCode":self.orderCode,@"type":@"0"};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dict compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dict);
        MyLog(@"释放座位%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

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
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static PCPayViewController*payMVC;
    dispatch_once(&onceToken, ^{
        payMVC=[[PCPayViewController alloc]init];
    });
    return payMVC;
}
-(void)dealloc{
    [self.timer invalidate];
    [self.cinemaTimer invalidate];
    self.cinemaTimer = nil;
    self.timer = nil;
}
@end
