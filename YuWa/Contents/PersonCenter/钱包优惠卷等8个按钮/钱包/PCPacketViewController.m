//
//  PCPacketViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCPacketViewController.h"

#import "PCDetailMoneyViewController.h"    //收入明细
#import "YWNewDiscountPayViewController.h"    //支付界面
#import "PCGetMoneyViewController.h"   //提现界面 （废）
#import "YWMessageNotificationViewController.h"//收入明细 -- 消费记录
#import "YWBankViewController.h"
#import "JWTools.h"

#import "WillAcountIncomeViewController.h"
#import "MyIncomeViewController.h"
#import "GetMyMoneyViewController.h"
#import "YWPayViewController.h"
#import "ShopDetailViewController.h"
#import "YWScanViewController.h"

#import "WLBarcodeViewController.h"
@interface PCPacketViewController ()<UIGestureRecognizerDelegate>

@end

@implementation PCPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"钱包";
    
    self.navigationController.navigationBar.barTintColor = CNaviColor;
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"收支明细" style:UIBarButtonItemStylePlain target:self action: @selector(touchRightItem) ];

    self.navigationItem.rightBarButtonItem=item;

    
    //当前有多少钱
    [self getNumMoney];
    //充值
    UIButton*payButton=[self.view viewWithTag:4];
    payButton.layer.cornerRadius=6;
    payButton.layer.masksToBounds=YES;
//    payButton.layer.borderWidth=0.5;
//    payButton.layer.borderColor=[UIColor grayColor].CGColor;

    
    //提现
    UIButton*getMoney=[self.view viewWithTag:5];
    getMoney.layer.cornerRadius=6;
    getMoney.layer.masksToBounds=YES;
//    getMoney.layer.borderWidth=0.5;
//    getMoney.layer.borderColor=[UIColor grayColor].CGColor;
    [getMoney addTarget:self action:@selector(touchGetMoney) forControlEvents:UIControlEventTouchUpInside];
    //付款
    UIImageView * payImageView = [self.view viewWithTag:7];
    payImageView.userInteractionEnabled = YES;
//    payImageView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer * payTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payMoney)];
    payTap.numberOfTapsRequired = 1;
    payTap.numberOfTouchesRequired = 1;

    payTap.delegate = self;
    [payImageView addGestureRecognizer:payTap];
    
    //零钱
    UIImageView * moneyImageView = [self.view viewWithTag:8];
    moneyImageView.userInteractionEnabled = YES;
//    moneyImageView.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer * mongyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyTouch)];
    mongyTap.numberOfTapsRequired = 1;
    mongyTap.numberOfTouchesRequired = 1;
    mongyTap.delegate = self;
    [moneyImageView addGestureRecognizer:mongyTap];

    
    //银行卡
    UIImageView * bankImageView = [self.view viewWithTag:9];
    bankImageView.userInteractionEnabled = YES;
//    bankImageView.backgroundColor = [UIColor blueColor];
    UITapGestureRecognizer * banckTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(banckCardTouch)];
    banckTap.numberOfTapsRequired = 1;
    banckTap.numberOfTouchesRequired = 1;
    banckTap.delegate = self;
    [bankImageView addGestureRecognizer:banckTap];
    
    
    
    //接口
    [self HttpGetMoney];
    
}
//待结算收益
- (IBAction)willAccountIncomeAction:(UIButton *)sender {
    
    WillAcountIncomeViewController * willVC = [[WillAcountIncomeViewController alloc]init];
    [self.navigationController pushViewController:willVC animated:YES];
}

//我的收益
- (IBAction)myIncomeAction:(UIButton *)sender {
    MyIncomeViewController * vc = [[MyIncomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//得到多少钱
-(void)getNumMoney{
    UILabel*label3=[self.view viewWithTag:3];
    CGFloat money = [[UserSession instance].money floatValue];
    label3.text = [NSString stringWithFormat:@"%.4f",money];
}
//付款
- (IBAction)payMoney:(UIButton *)sender {
    [self payMoney];
}
-(void)payMoney{
//        YWScanViewController * vc = [[YWScanViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    

    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            //扫描结果 成功


            if([str hasPrefix:@"yuwabao"]){
                NSArray*array=[str componentsSeparatedByString:@"/"];
                NSString*idd=array.lastObject;
                ShopDetailViewController * vc = [[ShopDetailViewController alloc]init];
                vc.shop_id = idd;
                [self.navigationController pushViewController:vc animated:YES];
          
            }else if (![str hasPrefix:@"yvwa.com/"]) {
                NSArray*array=[str componentsSeparatedByString:@"/"];
                NSString*idd=array.lastObject;
                
                //这里吊接口 通过这 idd
                [self getDatasWithIDD:idd];
                
                return ;

                
            }else {
            
                //不是我们的二维码
                NSString*strr=[NSString stringWithFormat:@"可能存在风险，是否打开此链接?\n %@",str];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接", nil];
                [alert show];
                
                
                //
                
                
            }
            
            
            
        }else{
            //扫描结果不成功
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:@"无法识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    

    
}

-(void)getDatasWithIDD:(NSString*)idd{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_QRCODE_ID];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"code":idd};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        //        MyLog(@"%@",data);
        
        NSString*company_name=data[@"data"][@"company_name"];   //这个 名字 需要改。
        NSString*shopID=data[@"data"][@"seller_uid"];
        CGFloat discount=[data[@"data"][@"discount"] floatValue];
        CGFloat total_money=[data[@"data"][@"total_money"] floatValue];
        CGFloat non_discount_money=[data[@"data"][@"non_discount_money"] floatValue];
        
        YWNewDiscountPayViewController*vc=[YWNewDiscountPayViewController payViewControllerCreatWithQRCodePayAndShopName:company_name andShopID:shopID andZhekou:discount andpayAllMoney:total_money andNOZheMoney:non_discount_money];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}


//银行卡
- (IBAction)bankCardAction:(UIButton *)sender {
    [self banckCardTouch];
}
- (void)banckCardTouch{
    
    YWBankViewController * addVC = [[YWBankViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
//零钱
- (IBAction)moneyAction:(UIButton *)sender {
    [self moneyTouch];
}
- (void)moneyTouch{
    MyLog(@"零钱");
}


#pragma mark  --touch
-(void)touchRightItem{
    PCDetailMoneyViewController*vc=[[PCDetailMoneyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


//提现
-(void)touchGetMoney{
    MyLog(@"提现");
//    PCGetMoneyViewController*vc=[[PCGetMoneyViewController alloc]init];
//    vc.money = [[UserSession instance].money floatValue];
//    [self.navigationController pushViewController:vc animated:YES];
    GetMyMoneyViewController * vc = [[GetMyMoneyViewController alloc]init];
    CGFloat money = [[UserSession instance].money floatValue];
    vc.money = [NSString stringWithFormat:@"%.4f",money];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark  --  money
-(void)HttpGetMoney{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETMONEY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            [UserSession instance].money=data[@"data"][@"money"];
            
            [self getNumMoney];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
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
