//
//  PayBusinessViewController.m
//  YuWa
//
//  Created by double on 17/3/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PayBusinessViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayBusinessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * markBtn;
    
}
@property (nonatomic,strong)UITableView * payInfoTableView;
@property(nonatomic,assign)NSInteger ischoose; //0 微信 1 支付宝 2 银联支付
@end

@implementation PayBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单支付";
    [self setpayinfomationUI];
    _ischoose = 3;
}

- (void)setpayinfomationUI{
    _payInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _payInfoTableView.delegate = self;
    _payInfoTableView.dataSource = self;
    _payInfoTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_payInfoTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.f;
    }else if (indexPath.section == 1){
        
        if ((indexPath.row == 0)) {
           
        return 0.001f;
    }else if(indexPath.row == 1){
        return 0.001f;
    }else{
        return 44.f;
    }
        
    }
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"payCell"];
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = RGBCOLOR(250, 253, 245, 1);
        cell.imageView.image = [UIImage imageNamed:@"商务会员头像.png"];
        cell.textLabel.font = [UIFont systemFontOfSize:17 weight:1];
        cell.textLabel.textColor = CNaviColor;
        cell.textLabel.text = @"￥8000";

        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = @"开通商务会员";
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
//            UILabel * promptLbl = [[UILabel alloc]initWithFrame:CGRectMake(10,0, kScreen_Width - 20, 30)];
//            promptLbl.font = [UIFont systemFontOfSize:14];
//            promptLbl.textColor = [UIColor darkGrayColor];
//            promptLbl.text = @"永久成为商务会员:需要支付8000手续费";
//            
//            [cell.contentView addSubview:promptLbl];
  
        }else if (indexPath.row == 1){
//            UIView * payBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.width, 132.f)];
//            //    payBGView.backgroundColor = [UIColor redColor];
//            [cell.contentView addSubview:payBGView];
//            NSArray * imageName = @[@"wechatPay",@"zhifubaoPay",@"yinlianpay"];
//            NSArray * name = @[@"微信支付",@"支付宝支付",@"银联支付"];
//            
//            for (int i = 0; i < 3; i++) {
//                UIImageView * payImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (30 +20)*i, 30, 30)];
//                payImageView.image = [UIImage imageNamed:imageName[i]];
//                [payBGView addSubview:payImageView];
//                
//                UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(25 +payImageView.width, 5 +(20 +30)*i, kScreen_Width/4, 25)];
//                titleLbl.text = [NSString stringWithFormat:@"%@",name[i]];
//                titleLbl.font = [UIFont systemFontOfSize:14];
//                titleLbl.textColor = [UIColor blackColor];
//                [payBGView addSubview:titleLbl];
//                
//                UIButton * dagouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                dagouBtn.frame = CGRectMake(kScreen_Width - 50, (20 +30)*i, 30, 30);
//                [dagouBtn setImage:[UIImage imageNamed:@"dagougray"] forState:UIControlStateNormal];
//                [dagouBtn setImage:[UIImage imageNamed:@"dagou"] forState:UIControlStateSelected];
//                dagouBtn.tag = 10 + i;
//                [dagouBtn addTarget:self action:@selector(choosePay:) forControlEvents:UIControlEventTouchUpInside];
//                [payBGView addSubview:dagouBtn];
//                
//            }
        }else{
        UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payBtn.frame = CGRectMake(10, 5, kScreen_Width- 20, cell.height- 10);
        payBtn.backgroundColor = CNaviColor;
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.cornerRadius = 5;
        [payBtn setTitle:@"确认支付￥8000" forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:payBtn];
    
        }
    }
    return cell;
}
- (void)payMoney{
    if (_ischoose == 3) {
        [JRToast showWithText:@"请选择支付方式"];
        return;

    }
        if (_ischoose == 0) {
           //微信支付
           
    
        }else if(_ischoose == 1){
           //支付宝支付
            [self payWith:@"ali"];

        }else{
            
            //银联支付
        }
}
-(void)payWith:(NSString*)aa{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_THIRD_PAY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":@(self.order_id),@"pay_method":aa};
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
                
            }else{
                //微信
                
                
            }
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
}

#pragma mark --  支付宝支付
- (void)doAlipayPay:(NSString*)orderString
{
    

    NSString *appScheme = @"alisdkdemo";

    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:@"支付成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
        
        
    }];
    //    }
    
    
    
    AppDelegate*delegate   =(AppDelegate*)  [UIApplication sharedApplication].delegate;
    delegate.aliPayBlock=^(NSDictionary*resultDic){
        
        //        [self judgePaySuccessOrNot];
        
        [UserSession instance].money=0;
        
        NSLog(@"reslut = %@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:@"支付成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            UIViewController*vc=[self.navigationController.viewControllers objectAtIndex:1];
            [self.navigationController popToViewController:vc animated:YES];
            
        }
        
        
        
    };
    
}


- (void)choosePay:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
            sender.selected = YES;
            _ischoose = 0;
            MyLog(@"微信支付");
            break;
        case 11:
            sender.selected = YES;
            _ischoose = 1;
            MyLog(@"支付宝支付");

            break;
        default:
            sender.selected = YES;
            _ischoose = 2;
            MyLog(@"银联支付");
    }
    markBtn.selected = NO;
    markBtn = sender;

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
