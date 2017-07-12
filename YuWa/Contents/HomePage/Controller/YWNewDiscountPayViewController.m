//
//  YWNewDiscountPayViewController.m
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNewDiscountPayViewController.h"
#import "ShopCarDetailTableViewCell.h"//购物车商品cell
#import "YWPayMoneyTableViewCell.h"//打折的cell
#import "NSString+JWAppendOtherStr.h"
#import "YWOtherPayMoneyTableViewCell.h"//总的消费金额cell
#import "CouponViewController.h"
#import "TwoLabelShowTableViewCell.h"
#import "PCPayViewController.h"
#import "ShopdetailModel.h"
#import "YWLoginViewController.h"
#import "YWShopInfoListModel.h"
#import "YWNoShopTableViewCell.h"//无商品的时候买单
#import "YWNewShopInfoTableViewCell.h"//直接买单cell
#import "UseCouponViewController.h"//选择优惠券

#define newShopInfoCell @"YWNewShopInfoTableViewCell"
#define noShopCell     @"YWNoShopTableViewCell"
#define otherPayCell   @"YWOtherPayMoneyTableViewCell"
#define payMoneyCell  @"YWPayMoneyTableViewCell"
#define carCell @"ShopCarDetailTableViewCell"
#define CELL2  @"TwoLabelShowTableViewCell"
@interface YWNewDiscountPayViewController ()<UITableViewDelegate,UITableViewDataSource,YWOtherPayMoneyTableViewCellDelegate,UseCouponViewControllerDelegate,YWPayMoneyTableViewCellDelegate,UITextFieldDelegate,YWNoShopTableViewCellDelegate>
//去结算按钮
@property (weak, nonatomic) IBOutlet UIButton *goPay;
@property (weak, nonatomic) IBOutlet UILabel *settomMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *accountBGView;
@property (weak, nonatomic) IBOutlet UITableView *payTableView;
@property (nonatomic,strong)ShopdetailModel * mainModel;
@property (nonatomic,strong)UIButton * couponBtn;//使用优惠券
@property (nonatomic,copy)NSString * noDiscountMoney;//不打折金额
@property (nonatomic,copy)NSString * otherTotalMoney;//其他消费总额
@property(nonatomic,assign)CGFloat shouldPayMoney;   //应该支付的钱（减去了折扣的）
@property(nonatomic,assign)CGFloat CouponMoney;    //优惠券减少多少钱。
//@property(nonatomic,assign)CGFloat noCouponPayMoney;  //没有减去折扣需要付的钱
@property(nonatomic,assign)BOOL is_coupon;   //是否用优惠券
@property(nonatomic,assign)int coupon_id;
@property (nonatomic,strong)NSMutableArray * goods_ids;//商品id，上传用
@property (nonatomic,strong)NSMutableArray * goods_prices;//同上
@property (nonatomic,strong)NSMutableArray * goods_nums;//同上
@property (nonatomic,copy)NSString * noUserCouponMoney;//未使用优惠券的时候需要支付的金额；
@property (nonatomic,copy)NSString * useDiscountCoupon;
@property (nonatomic,assign)BOOL isClearMoney;//清空金额
@end

@implementation YWNewDiscountPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠买单";
    [self registerXib];
    if ([self.money isEqualToString:@"0.00"]) {
        if (self.whichPay != PayCategoryQRCodePayMethod) {
            self.goPay.selected = NO;
            [self.goPay setUserInteractionEnabled:NO];
            [self.goPay setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            self.goPay.selected = YES;
            [self.goPay setUserInteractionEnabled:YES];
            [self.goPay setBackgroundColor:CNaviColor];
        }
    }
    if (self.shopZhekou <= 0.00 || self.shopZhekou >=1) {
        self.shopZhekou = 1;
    }
    if ([self.shopDiscount floatValue]<=0.00 || [self.shopDiscount floatValue] >=1) {
        self.shopDiscount = @"1";
    }
    self.shouldPayMoney = [self.money floatValue];
    self.is_coupon = NO;
//    MyLog(@"status = %ld",self.status);
    if (self.whichPay == PayCategoryQRCodePayMethod) {
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",(self.payAllMoney - self.NOZheMoney )*self.shopZhekou  + self.NOZheMoney ];
        MyLog(@"金额 %@",[NSString stringWithFormat:@"%f",([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])* self.shopZhekou  - self.CouponMoney+[self.noDiscountMoney floatValue]]);
        self.shouldPayMoney = [[NSString stringWithFormat:@"待支付￥%.2f",(self.payAllMoney - self.NOZheMoney )*self.shopZhekou  + self.NOZheMoney ] floatValue];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleMoney:) name:@"deleteTotalMoney" object:nil];
       if ([self.money isKindOfClass:[NSNull class]]||self.money ==nil) {
        self.settomMoneyLabel.text = @"待支付￥0.00";
           if (self.whichPay != PayCategoryQRCodePayMethod) {
               
               [self.goPay setUserInteractionEnabled:NO];
               [self.goPay setBackgroundColor:[UIColor lightGrayColor]];
           }else{
               [self.goPay setUserInteractionEnabled:YES];
               [self.goPay setBackgroundColor:CNaviColor];
           }
    }

}
- (void)deleMoney:(NSNotification*)sender{
    if ((self.isClearMoney =1?sender.userInfo[@"isClearMoney"]:NO)) {
        //清空总价
        
        self.money = @"0.00";
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥0.00"];
        if (self.whichPay != PayCategoryQRCodePayMethod) {
            
            [self.goPay setUserInteractionEnabled:NO];
            [self.goPay setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            [self.goPay setUserInteractionEnabled:YES];
            [self.goPay setBackgroundColor:CNaviColor];
        }
        
    }
}
//手动支付
+(instancetype)payViewControllerCreatWithWritePayAndShopName:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou{
    
    YWNewDiscountPayViewController *payVC = [[self alloc] init];
    payVC.shopName=shopName;
    payVC.shopID=shopID;
    payVC.shopDiscount= [NSString stringWithFormat:@"%.2f",shopZhekou];
    
    payVC.whichPay=PayCategoryWritePayMethod;
    return payVC;
}

//扫码支付
+(instancetype)payViewControllerCreatWithQRCodePayAndShopName:(NSString*)shopName andShopID:(NSString*)shopID andZhekou:(CGFloat)shopZhekou andpayAllMoney:(CGFloat)payAllMoney andNOZheMoney:(CGFloat)NOZheMoney{
    
    YWNewDiscountPayViewController *payVC = [[self alloc] init];
    payVC.shopName=shopName;
    payVC.shopID=shopID;
    payVC.shopZhekou=shopZhekou;
    payVC.payAllMoney=payAllMoney;//总金额，未打折前
    payVC.NOZheMoney=NOZheMoney;
    payVC.status = 3;
    payVC.otherTotalMoney = [NSString stringWithFormat:@"%.2f",payAllMoney];
    payVC.whichPay=PayCategoryQRCodePayMethod;
    return payVC;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
    if (self.status == 2) {
        
        [self requestShopListData];
    }
}
//去结算
- (IBAction)toAccountAction:(UIButton *)sender {
    
        [self touchPay];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
        return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else if (section == 2){
        return 4;
    }
        return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 1 || self.status == 3) {
        if (indexPath.section == 0) {
            return 250.f;
        }
        return 44.f;
    }else{
    if (indexPath.section == 0) {
        if (self.status != 2) {
                //从购物车点击过来的
           
            return [ShopCarDetailTableViewCell getHeight:self.model.cart]-40;
        }else{

            return [YWNewShopInfoTableViewCell getHeight:self.model.cart]*self.dataAry.count+20;
        }
    }
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0.01f;
    }
        return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.status == 1 || self.status == 3) {
            YWNoShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:noShopCell];
            if (!cell) {
                cell = [[YWNoShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noShopCell];
            }
            cell.selectionStyle = NO;
            cell.shopIconImageView.layer.masksToBounds = YES;
            cell.shopIconImageView.layer.cornerRadius = 5;
            [cell.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.mainModel.company_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.shopNameLabel.text = self.shopName;
            cell.delegate = self;
            return cell;
        }else{
            if (self.status == 2) {
                YWNewShopInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:newShopInfoCell];
                cell.selectionStyle = NO;
                cell.model = self.infoModel;
                cell.shopName = self.shopName;
                cell.cart = self.dataAry;
                cell.dataAry = self.dataAry;
                cell.shopIconImageView.layer.masksToBounds = YES;
                cell.shopIconImageView.layer.cornerRadius = 5;
                [cell.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.mainModel.company_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                return cell;
            }else{
                ShopCarDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:carCell];
                cell.selectionStyle = NO;
                cell.model = self.model;
                self.shopID = self.model.id;
                [self.goods_prices removeAllObjects];
                [self.goods_nums removeAllObjects];
                [self.goods_ids removeAllObjects];
                for (NSDictionary * dict in self.model.cart) {
                    YWShopInfoListModel * model = [YWShopInfoListModel yy_modelWithDictionary:dict];
                    if (model.goods_disprice == nil ||[model.goods_disprice isKindOfClass:[NSNull class]]) {
                        [self.goods_prices addObject:model.goods_price];
                    }else{
                        
                        [self.goods_prices addObject:model.goods_disprice];
                    }
                    [self.goods_nums addObject:model.goods_num];
                    [self.goods_ids addObject:model.goods_id];
                }
                cell.totalMoneyLabel.hidden = YES;
                cell.line.hidden = YES;
                cell.accountBtn.hidden = YES;
                cell.clearBtn.hidden = YES;
                return cell;
            }
        }
    }else if (indexPath.section ==1){
        WEAKSELF;
        YWPayMoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:payMoneyCell];
        cell.selectionStyle = NO;
        cell.delegate = self;
        if (indexPath.row !=2) {
            cell.youhuiImageView.hidden =YES;
            cell.discountLabel.hidden = YES;
            cell.chooseBtn.hidden = YES;
            
            cell.titleNameLabel.hidden = NO;
            cell.moneyTF.hidden = NO;
        }else{
            cell.youhuiImageView.hidden =NO;
            cell.discountLabel.hidden = NO;
            cell.chooseBtn.hidden = NO;
            
            cell.titleNameLabel.hidden = YES;
            cell.moneyTF.hidden = YES;
        }
        if (indexPath.row == 0) {
            cell.titleNameLabel.text = @"其他消费总额:";
            cell.moneyTF.placeholder = @"请输入金额";
            cell.moneyTF.userInteractionEnabled=YES;
            cell.moneyChangeBlock = ^(NSString * money){
                weakSelf.otherTotalMoney = money;
                weakSelf.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",([weakSelf.otherTotalMoney floatValue] - [weakSelf.noDiscountMoney floatValue])*[weakSelf.model.discount floatValue] + [weakSelf.money floatValue]- _CouponMoney];
            };
            if (self.status == 3) {
            //扫码
            if (self.whichPay==PayCategoryQRCodePayMethod) {
                if (self.otherTotalMoney != nil) {
                  cell.moneyTF.text=[NSString stringWithFormat:@"%@",self.otherTotalMoney];
                    cell.moneyTF.userInteractionEnabled=NO;
                    self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",(weakSelf.payAllMoney - weakSelf.NOZheMoney)*self.shopZhekou +weakSelf.NOZheMoney - _CouponMoney];
                    if (self.is_coupon == YES) {
                        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",(_payAllMoney - _NOZheMoney)*self.shopZhekou +_NOZheMoney - _CouponMoney];
                    }
                }
               
            }
            }
        }else if (indexPath.row == 1){
            cell.moneyTF.userInteractionEnabled=YES;
            cell.titleNameLabel.text = @"其中非打折金额:";
            cell.moneyTF.placeholder = @"(选填)";
            cell.moneyChangeBlock = ^(NSString * money){
                weakSelf.noDiscountMoney = money;
                weakSelf.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",([weakSelf.otherTotalMoney floatValue] - [weakSelf.noDiscountMoney floatValue])*[weakSelf.model.discount floatValue] + [weakSelf.money floatValue]];
            };
            //扫码
            if (self.status == 3) {
                
                if (self.whichPay==PayCategoryQRCodePayMethod) {
                    cell.moneyTF.userInteractionEnabled=NO;
                    cell.moneyTF.text=[NSString stringWithFormat:@"%.2f",self.NOZheMoney];
                }
            }
        }else{
            
            if (self.status == 1 ||self.status == 2 ||self.status == 3) {
                NSString*zheNum;
                if (self.whichPay == PayCategoryQRCodePayMethod) {
                    
                    zheNum = [NSString stringWithFormat:@"%f",_shopZhekou*100];
                }else{
                    if ([self.shopDiscount isEqualToString:@"1"]) {
                        zheNum = @"10";
                    }else{
                 zheNum=[self.shopDiscount substringFromIndex:2];
                    }
                }
            
                if ([zheNum integerValue] % 10 == 0) {
                    zheNum = [NSString stringWithFormat:@"%ld折",[zheNum integerValue]/10];
                }else{
                    zheNum = [NSString stringWithFormat:@"%.1f折",[zheNum floatValue]/10];
                }
                
                cell.discountLabel.attributedText = [NSString stringWithFirstStr:@"雨娃支付立享" withFont:cell.discountLabel.font withColor:RGBCOLOR(94, 94, 94, 1) withSecondtStr:[NSString stringWithFormat:@"%@",zheNum] withFont:[UIFont systemFontOfSize:15] withColor:RGBCOLOR(252, 227, 135, 1)];
                CGFloat num=[self.shopDiscount floatValue];
                if (self.status == 3) {
                    num = self.shopZhekou;
                }

                if (num>=1 || num == 0.00) {
                    cell.discountLabel.text = @"不打折";
                }
            }else{
            NSString*zheNum=[self.model.discount substringFromIndex:2];
            
            if ([zheNum integerValue] % 10 == 0) {
                zheNum = [NSString stringWithFormat:@"%ld折",[zheNum integerValue]/10];
            }else{
                zheNum = [NSString stringWithFormat:@"%.1f折",[zheNum floatValue]/10];
            }
            cell.discountLabel.attributedText = [NSString stringWithFirstStr:@"雨娃支付立享" withFont:cell.discountLabel.font withColor:RGBCOLOR(94, 94, 94, 1) withSecondtStr:[NSString stringWithFormat:@"%@",zheNum] withFont:[UIFont systemFontOfSize:15] withColor:RGBCOLOR(252, 227, 135, 1)];
            CGFloat num=[self.model.discount floatValue];
            if (num>=1 || num == 0.00) {
                cell.discountLabel.text = @"不打折";
            }
            }
        }
        return cell;
    }else{
        YWOtherPayMoneyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:otherPayCell];
        cell.selectionStyle = NO;
        cell.delegate = self;
        if (indexPath.row != 3) {
            cell.chooseBtn.hidden = YES;
            cell.chooseImageView.hidden = YES;
        }else{
            cell.moneyLabel.hidden = YES;
            cell.chooseBtn.hidden = NO;
            cell.chooseImageView.hidden = NO;
        }
        if (indexPath.row ==0) {
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.money];
            if (self.money == nil) {
                cell.moneyLabel.text = @"￥0.00";
            }
        }else if (indexPath.row == 1){
            cell.titleNameLabel.text = @"其他消费折后总额";
            CGFloat otherMoney;
            if (self.status == 1 || self.status == 2 || self.status == 3) {
               otherMoney = ([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])*[self.shopDiscount floatValue]+[self.noDiscountMoney floatValue];
            }else{
            otherMoney = ([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])*[self.model.discount floatValue] + [self.noDiscountMoney floatValue];
            }
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",otherMoney];
            if (self.whichPay == PayCategoryQRCodePayMethod) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.payAllMoney-self.NOZheMoney) * self.shopZhekou +self.NOZheMoney];
            }
        }else if (indexPath.row == 2){
            cell.titleNameLabel.text = @"实付金额";
            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",self.shouldPayMoney];
            cell.titleNameLabel.textColor = RGBCOLOR(123, 123, 123, 1);
            cell.moneyLabel.textColor = RGBCOLOR(123, 123, 123, 1);
            if (self.whichPay == PayCategoryQRCodePayMethod) {
                    if (self.is_coupon == YES) {
                            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.payAllMoney -self.NOZheMoney) * self.shopZhekou +self.NOZheMoney - self.CouponMoney];//xiu
                    }else{
                            cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",(self.payAllMoney -self.NOZheMoney) * self.shopZhekou +self.NOZheMoney- _CouponMoney];
                    }
                   
                }

        }else if (indexPath.section == 2 && indexPath.row == 3){
            cell=[tableView dequeueReusableCellWithIdentifier:otherPayCell];
            cell.selectionStyle=NO;
            cell.delegate = self;
            cell.moneyLabel.hidden = YES;
            cell.chooseBtn.hidden = NO;
            cell.chooseImageView.hidden = NO;
            UILabel*label1=[cell viewWithTag:1];
            label1.text=@"抵用券";
            
            UIButton*btn=[cell viewWithTag:111];
            if (self.useDiscountCoupon == nil) {
                
                [btn setTitle:@"使用优惠券" forState:UIControlStateNormal];
            }else{
                [btn setTitle:self.useDiscountCoupon forState:UIControlStateNormal];
            }
            self.couponBtn = btn;
            
            return cell;

        }
        return cell;
    }
}
//使用优惠券
- (void)useYouhuiquanAction{

    UseCouponViewController * useVC = [[UseCouponViewController alloc]init];
    useVC.shop_id = self.shopID;
    useVC.delegate = self;
    if (self.status == 3) {
        
        useVC.total_money = [NSString stringWithFormat:@"%.2f",self.payAllMoney];
    }else{
        useVC.total_money = [NSString stringWithFormat:@"%.2f",[self.money floatValue] + ([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue]) * [self.shopDiscount floatValue]];
    }
    [self.navigationController pushViewController:useVC animated:YES];
}
//代理
- (void)changMoney:(NSString *)money{

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *indexPathT=[NSIndexPath indexPathForRow:2 inSection:2];
    if (self.status == 1 ||self.status == 3) {
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])*[self.shopDiscount floatValue]- _CouponMoney +[self.noDiscountMoney floatValue]];//修;
    }else{
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])*[self.shopDiscount floatValue] + [self.noDiscountMoney floatValue] + [self.money floatValue]- _CouponMoney ];//修
    }
     NSString * payAllmoney = [self.settomMoneyLabel.text substringFromIndex:4];
    self.shouldPayMoney = [payAllmoney floatValue];
    self.noUserCouponMoney = payAllmoney;
    [self calshouldPayMoney];
    if (([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue])*[self.shopDiscount floatValue]- _CouponMoney != 0.00 ) {
        self.goPay.userInteractionEnabled = YES;
        [self.goPay setBackgroundColor:CNaviColor];
        
    }else{
        if (self.whichPay != PayCategoryQRCodePayMethod) {
            
            [self.goPay setUserInteractionEnabled:NO];
            [self.goPay setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            [self.goPay setUserInteractionEnabled:YES];
            [self.goPay setBackgroundColor:CNaviColor];
        }
    }
    //刷新对应行的数据
    [self.payTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPathT,nil] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)toBuyShop{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
     [self.view endEditing:YES];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    YWPayMoneyTableViewCell*cell=[self.payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField*textZero=[cell viewWithTag:2];
    
    YWPayMoneyTableViewCell*cell2=[self.payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField*textOne=[cell2 viewWithTag:2];
    
    if ([textField isEqual:textZero]) {
        
        NSString*str=textZero.text;
//        CGFloat aa=[str floatValue];
        self.otherTotalMoney=str;
    }else{
        NSString*str=textOne.text;
//        CGFloat aa=[str floatValue];
        self.noDiscountMoney=str;
    }
     [self.view endEditing:YES];
    //计算所要支付的钱
        [self calshouldPayMoney];
}
#pragma 计算所要支付的钱
-(void)calshouldPayMoney{
    //总的需要支付的钱，没打折之前
    NSString * payAllmoney = [self.settomMoneyLabel.text substringFromIndex:4];
    MyLog(@"总的金额 %@",payAllmoney);
//打折后需要支付的钱
    
    //不能小于
    if ([self.otherTotalMoney floatValue]<[self.noDiscountMoney floatValue]) {
        
        [JRToast showWithText:@"不打折金额不能大于消费总额"];

        return;
    }
    
    CGFloat payMoney=[payAllmoney floatValue];
    self.shouldPayMoney=payMoney;
//    //需要支付的钱
//     YWOtherPayMoneyTableViewCell*cell=[self.payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
//    cell.moneyLabel.text = payAllmoney;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing: YES];
}

#pragma mark  --touch
-(void)touchPay{
    //确认付款的时候 先生成订单
    [self jiekouADDOrder];

}

#pragma mark  --datas
-(void)jiekouADDOrder{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
    if ([self.otherTotalMoney floatValue]<[self.noDiscountMoney floatValue]) {
        [JRToast showWithText:@"不打折金额不能大于消费总金额"];
        return;
    }
//    if ([self.otherTotalMoney floatValue]==0.00) {
//        [JRToast showWithText:@"请输入消费总额"];
//        return;
//    }
    if ([self.otherTotalMoney floatValue]==0.00) {
        self.otherTotalMoney = @"0";
        
    }
    if (self.noDiscountMoney == nil) {
        self.noDiscountMoney = @"0";
    }
    NSString * goods_price = [self.goods_prices componentsJoinedByString:@","];
    NSString * goods_nums = [self.goods_nums componentsJoinedByString:@","];
    NSString * goods_ids = [self.goods_ids componentsJoinedByString:@","];
    NSString * isCoupon;
    if (self.is_coupon == YES) {
        isCoupon = @"1";
    }else{
        isCoupon = @"0";
    }

    if (self.goods_ids.count == 0) {
        goods_ids = @"";
        goods_nums = @"";
        goods_price = @"";
    }
    
    NSString * discount;
    CGFloat payTotalMoney;//需要支付的总金额，未打折的
    NSString * noDisMoney;//不参与打折金额和单品总额
    if (self.status == 3) {//扫码支付的情况下的折扣和需要支付的金额
        discount = [NSString stringWithFormat:@"%.2f",self.shopZhekou];
        noDisMoney = [NSString stringWithFormat:@"%.2f",self.NOZheMoney ];
        payTotalMoney = self.payAllMoney;
    }else if (self.status != 3 && ([self.otherTotalMoney isEqualToString:@"0"]||self.otherTotalMoney == nil)) {//只有单品的情况
        discount = @"1";
        payTotalMoney = [self.money floatValue];
        noDisMoney = @"0";
        
    }else{//其他状态下，有单品也有其他消费总额，把单品价格添加到不打折金额中
        discount = self.shopDiscount;
        payTotalMoney  = [self.money floatValue] + [self.otherTotalMoney floatValue];
        noDisMoney = [NSString stringWithFormat:@"%f",[self.money floatValue] + [self.noDiscountMoney floatValue]];
    }
    //有单品的情况下传path = 1，没有单品则传2；
    NSString * path;
    if (self.goods_ids.count == 0) {
        path = @"2";
    }else{
        path = @"1";
    }
    if (self.status == 3) {
        path = @"2";
    }
    NSString * newShouldPayMoney = [NSString stringWithFormat:@"%.2f",payTotalMoney];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MAKEORDER];
    NSDictionary*dict=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"seller_uid":self.shopID,@"total_money":newShouldPayMoney,@"non_discount_money":noDisMoney,@"discount":discount,@"is_coupon":isCoupon,@"goods_id":goods_ids,@"goods_num":goods_nums,@"goods_price":goods_price,@"path":path};
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
            PCPayViewController*vc=[PCPayViewController sharedManager];
            vc.blanceMoney=shouldPay;
            vc.order_id=order_id;
            vc.shop_ID = self.shopID;
            MyLog(@"%f",order_id);
//            //发送消息  //清空详情页面勾选物品，数据
//            //                ShopDetailViewController
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteNun" object:nil];
//            //清空总价
////
//            self.money = @"0.00";
//            self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥0.00"];
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
-(void)DelegateGetCouponInfo:(CouponModel *)model{
    self.is_coupon=YES;
    self.coupon_id=[model.coupon_id intValue];
    YWOtherPayMoneyTableViewCell*cell=[self.payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:2]];
    cell.titleNameLabel.text = @"抵用券";
    
    [self.couponBtn setTitle:[NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee] forState:UIControlStateNormal];
    self.useDiscountCoupon = [NSString stringWithFormat:@"满%@抵%@",model.min_fee,model.discount_fee];
    NSString*aa=model.discount_fee;
    CGFloat payMoneys = (self.payAllMoney - self.NOZheMoney )*self.shopZhekou + self.NOZheMoney;
    self.CouponMoney=[aa floatValue];

     YWOtherPayMoneyTableViewCell*cell2=[self.payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    if (self.status == 3) {
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",payMoneys  - self.CouponMoney];
        cell2.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",payMoneys  - self.CouponMoney];
        
    }else{
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%.2f",[self.money floatValue] + ([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue]) * [self.shopDiscount floatValue] - self.CouponMoney + [self.noDiscountMoney floatValue]];
        cell2.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.money floatValue] + ([self.otherTotalMoney floatValue] - [self.noDiscountMoney floatValue]) * [self.shopDiscount floatValue] - self.CouponMoney + [self.noDiscountMoney floatValue]];
    }
    if (self.whichPay == PayCategoryQRCodePayMethod) {
        self.settomMoneyLabel.text = [NSString stringWithFormat:@"%.2f",(self.payAllMoney -self.NOZheMoney) * self.shopZhekou +self.NOZheMoney - self.CouponMoney];
    }


    [self calshouldPayMoney];
    [self.payTableView reloadData];
    
    
    
}
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
//请求购物车列表
- (void)requestShopListData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPCARLISTTWO];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":self.shopID};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"指定购物车列表 data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            if ([data[@"data"][@"cart"] isKindOfClass:[NSNull class]]) {
                self.status = 1;
                [self.payTableView reloadData];
                return ;
            }

            [self.dataAry removeAllObjects];
            [self.goods_ids removeAllObjects];
            [self.goods_nums removeAllObjects];
            [self.goods_prices removeAllObjects];
            NSArray * datas = data[@"data"][@"cart"];
            for (NSDictionary * dict in datas) {
                
                self.infoModel = [YWShopInfoListModel yy_modelWithDictionary:dict];
                
                if (self.infoModel.goods_disprice == nil ||[self.infoModel.goods_disprice isKindOfClass:[NSNull class]]) {
         
                    [self.goods_prices addObject:self.infoModel.goods_price];
                    
                }else{
                    
                    [self.goods_prices addObject:self.infoModel.goods_disprice];
                }
                [self.goods_nums addObject:self.infoModel.goods_num];
                [self.goods_ids addObject:self.infoModel.goods_id];
                

                
                [self.dataAry addObject:self.infoModel];
                
            }
            [self.payTableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPDETAIL];
    NSDictionary*dict=@{@"shop_id":self.shopID,@"device_id":[JWTools getUUID]};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode =[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.mainModel=[ShopdetailModel yy_modelWithDictionary:data[@"data"]];
            [self.payTableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
    }];
}

-(void)registerXib{
    [self.payTableView registerNib:[UINib nibWithNibName:carCell bundle:nil] forCellReuseIdentifier:carCell];
    [self.payTableView registerNib:[UINib nibWithNibName:payMoneyCell bundle:nil] forCellReuseIdentifier:payMoneyCell];
    [self.payTableView registerNib:[UINib nibWithNibName:otherPayCell bundle:nil] forCellReuseIdentifier:otherPayCell];
    [self.payTableView registerNib:[UINib nibWithNibName:noShopCell bundle:nil] forCellReuseIdentifier:noShopCell];
    [self.payTableView registerNib:[UINib nibWithNibName:newShopInfoCell bundle:nil] forCellReuseIdentifier:newShopInfoCell];
    self.payTableView.separatorStyle = UITableViewCellAccessoryNone;
    self.settomMoneyLabel.text = [NSString stringWithFormat:@"待支付￥%@",self.money];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteTotalMoney" object:nil];
    [_goods_ids removeAllObjects];
    _goods_ids = nil;
    
    [_goods_nums removeAllObjects];
    _goods_nums = nil;
    
    [_goods_prices removeAllObjects];
    _goods_prices = nil;
    
    [_dataAry removeAllObjects];
    _dataAry = nil;
}
-(NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (NSMutableArray*)goods_ids{
    if (!_goods_ids) {
        _goods_ids = [NSMutableArray array];
    }
    return _goods_ids;
}
- (NSMutableArray *)goods_nums{
    if (!_goods_nums) {
        _goods_nums = [NSMutableArray array];
    }
    return _goods_nums;
}
- (NSMutableArray *)goods_prices{
    if (!_goods_prices) {
        _goods_prices = [NSMutableArray array];
    }
    return _goods_prices;
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
