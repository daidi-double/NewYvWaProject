//
//  OrderDetailViewController.m
//  YuWa
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrdelShopCellView.h"
#import "OrderModel.h"
#import "NSString+JWAppendOtherStr.h"
#import "ShopNameView.h"
#import "OrderRefundViewController.h"
#import "ShopDetailViewController.h"
#import "MovieCinemaViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * orderTableView;
@property (nonatomic,strong)NSMutableArray * orderAry;
@property (nonatomic,strong)NSString * shop_id;
@property (nonatomic,strong)OrderModel * orModel;
//@property (nonatomic,strong)OrderModel * model;

@end

@implementation OrderDetailViewController
- (NSMutableArray *)orderAry{
    if (!_orderAry) {
        _orderAry = [NSMutableArray array];
    }
    return _orderAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"订单详情";
    [self setUpMJRefresh];
    self.view.backgroundColor = RGBCOLOR(241, 238, 245, 1);
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDatas];
}
- (void)makeUI{
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, kScreen_Height ) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderTableView];
    
    UIButton * refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refundBtn.frame = CGRectMake(16, kScreen_Height * 0.85f, kScreen_Width - 32, kScreen_Height * 0.1f);
    [refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    [refundBtn setBackgroundColor:CNaviColor];
    refundBtn.layer.cornerRadius = 5;
    refundBtn.layer.masksToBounds = YES;
    refundBtn.hidden = YES;
//    [refundBtn addTarget:self action:@selector(placeRefundAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refundBtn];
    
    
}
-(void)setUpMJRefresh{

    self.orderTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{

        [self getDatas];
        
    }];
    
   
}

//- (void)placeRefundAction{
//    OrderRefundViewController * refundVC = [[OrderRefundViewController alloc]init];
//    [self.navigationController pushViewController:refundVC animated:YES];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.status==1) {
        if (![self.orModel.hall_name containsString:@"通兑票"]){
            if ([self.orModel.status integerValue] == 3 ||[self.orModel.status integerValue] ==4||[self.orModel.status integerValue] ==5) {
                return 11;
            }else{
                return 9;
            }
        
        }else {
            if (([self.orModel.status integerValue] == 3 ||[self.orModel.status integerValue] ==4||[self.orModel.status integerValue] ==5)&&[self.orModel.hall_name containsString:@"通兑票"]){
            return 9;
            
        }else{
            return 7;
        }
      }
    }
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    if (self.status ==0) {
        
        ShopDetailViewController * vc = [[ShopDetailViewController alloc]init];
        vc.shop_id = self.shop_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
         OrderModel * model = self.orderAry[0];
        MovieCinemaViewController * vc = [[MovieCinemaViewController alloc]init];
        vc.film_code = model.film_code;
        vc.cinema_code = model.cinema_code;
        if ([model.hall_name containsString:@"通兑票"]) {
            vc.status = 1;
        }else{
            vc.status = 0;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderAry.count > 0) {
        
    OrderModel * model = self.orderAry[0];
    if (indexPath.row == 0) {
        return 80.f;
    }else if(indexPath.row ==1){
        if (self.status == 1) {
            return 35.f;
        }
        return 35.f * model.buy_shopAry.count;
    }else{

        return 35.f;
    }
    }
    return 35;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.status == 1) {
        if (indexPath.row >= 2) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
    if (indexPath.row >= 4) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    }
    if (self.orderAry.count > 0) {
        
        OrderModel * orderModel = self.orderAry[0];
        if (self.status == 0) {
    if (indexPath.row == 0) {
        ShopNameView * nameView = [[ShopNameView alloc]initWithFrame:CGRectMake(0, 0, cell.width *0.8f, 80)];
        
        [nameView.imageView sd_setImageWithURL:[NSURL URLWithString:orderModel.shop_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        nameView.shopNameLabel.text = orderModel.shop_name;
        nameView.filmNameLabel.hidden = YES;
        [cell.contentView addSubview:nameView];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        OrdelShopCellView * shopCellView;
        if (shopCellView) {
            [shopCellView removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i< orderModel.buy_shopAry.count; i++) {
            shopCellView = [[OrdelShopCellView alloc]initWithFrame:CGRectMake(0, 44 *i, cell.width, 44)];
            [cell.contentView addSubview:shopCellView];
        }
    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.imageView.image = [UIImage imageNamed:@"减"];
        CGFloat itemH =  cell.height * 0.4f;
        CGFloat itemW = 0;
        if (cell.imageView.image.size.width) {
            itemW = cell.imageView.image.size.height / cell.imageView.image.size.width * itemH;
            
            if (itemH >= itemW) {
                itemH = cell.height * 0.4f;
                itemW = cell.imageView.image.size.width * itemH/cell.imageView.image.size.height;
            }
        }
        
        CGSize itemSize = CGSizeMake(itemW,cell.height*0.4f);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat zhekou = [orderModel.discount floatValue]*10;
        if (zhekou >=10 || zhekou<=0.00) {
           cell.textLabel.text = @"未打折";
        }else{
        cell.textLabel.text = [NSString stringWithFormat:@"闪付享受%.1f折 折扣",zhekou];
            CGFloat discountMoney = [orderModel.total_money floatValue] - [orderModel.pay_money floatValue];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-%.2f",discountMoney];
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            
        }
    
    }else if (indexPath.row == 3){

        if (orderModel.pay_money == NULL) {
//
            cell.detailTextLabel.text = [NSString stringWithFormat:@"实付款￥%@",orderModel.pay_money];
        }else{
            cell.detailTextLabel.attributedText = [NSString stringWithFirstStr:@"实付款" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor] withSecondtStr:[NSString stringWithFormat:@"￥%@",orderModel.pay_money] withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor orangeColor]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        if (orderModel.is_coupon == 0) {
            cell.textLabel.text = @"优惠券金额:￥0.00";
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"优惠券金额￥:%@",orderModel.coupon_money];
        }
        

    }else if (indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.order_id];
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"订单状态:%@",orderModel.status];
    }else if (indexPath.row == 6){
        cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools getTime:orderModel.create_time]];
        UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
        [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
        questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
        [questionBtn addTarget:self action:@selector(callKeFu) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:questionBtn];
    
    }
   
        }else{//电影
            if (indexPath.row == 0) {
                ShopNameView * nameView = [[ShopNameView alloc]initWithFrame:CGRectMake(0, 0, cell.width *0.8f, 80)];
                
                [nameView.imageView sd_setImageWithURL:[NSURL URLWithString:orderModel.shop_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                
                nameView.filmNameLabel.text = [NSString stringWithFormat:@"%@  %@张",orderModel.filmName,orderModel.num];
                if (orderModel.filmName== nil || [orderModel.filmName isKindOfClass:[NSNull class]]) {
                    nameView.filmNameLabel.text = [NSString stringWithFormat:@"    %@张",orderModel.num];
                }
                if ([orderModel.hall_name containsString:@"通兑票"]) {
                    nameView.imageView.image = [UIImage imageNamed:@"otherticket"];
                    nameView.filmNameLabel.text = [NSString stringWithFormat:@"%@  %@张",orderModel.hall_name,orderModel.num];
                    if (orderModel.hall_name== nil || [orderModel.hall_name isKindOfClass:[NSNull class]]) {
                        nameView.filmNameLabel.text = [NSString stringWithFormat:@"    %@张",orderModel.num];
                    }
                }
               
                nameView.shopNameLabel.centerY = 28;
                nameView.shopNameLabel.text = orderModel.cinemaName;
                [cell.contentView addSubview:nameView];

                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == 1){
                
                if (orderModel.pay_money == NULL) {
                    //
                    
                    cell.detailTextLabel.text = @"实付款￥0.00";
                }else{

                     cell.detailTextLabel.attributedText = [NSString stringWithFirstStr:@"实付款" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor] withSecondtStr:[NSString stringWithFormat:@"￥%@",orderModel.pay_money] withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor orangeColor]];
                }
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                if (orderModel.is_coupon == 0) {
                    cell.textLabel.text = @"优惠券金额:￥0.00";
                }else{
                    cell.textLabel.text = [NSString stringWithFormat:@"优惠券金额￥:%@",orderModel.coupon_money];
                }
                
            }else if (indexPath.row == 2){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [NSString stringWithFormat:@"影院: %@",orderModel.cinemaName];
            }else if (indexPath.row == 3){
              cell.textLabel.text = [NSString stringWithFormat:@"订单信息:%@    %@张",orderModel.filmName,orderModel.num];
                if (orderModel.filmName== nil || [orderModel.filmName isKindOfClass:[NSNull class]]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"订单信息:    %@张",orderModel.num];
                }
                if ([orderModel.hall_name containsString:@"通兑票"]) {
                   cell.textLabel.text = [NSString stringWithFormat:@"订单信息:%@    %@张",orderModel.hall_name,orderModel.num];
                    if (orderModel.hall_name== nil || [orderModel.hall_name isKindOfClass:[NSNull class]]) {
                       cell.textLabel.text = [NSString stringWithFormat:@"订单信息:    %@张",orderModel.num];
                    }
                }
            }else if (indexPath.row == 3){
                
                cell.textLabel.text = [NSString stringWithFormat:@"总价:￥%.2f",[orderModel.total_money floatValue]/100];
                
                
            }else if (indexPath.row == 4){
                cell.textLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.order_sn];
                
            }else if (indexPath.row == 5){
                NSString * orderStatus;
//                订单状态（1：未支付 2：已取消 3：已支付 4：出票成功 5：出票失败 6：已退票 7：已评价
                switch ([orderModel.status integerValue]) {
                    case 1:
                        orderStatus = @"未支付";
                        break;
                    case 2:
                        orderStatus = @"已取消";
                        break;

                    case 3:
                        orderStatus = @"已支付";
                        break;
                    case 4:
                        orderStatus = @"已评价";
                        break;
                        
                    case 5:
                        orderStatus = @"出票成功";
                        break;
                    case 6:
                        orderStatus = @"出票失败";
                        break;

                    default:
                        orderStatus = @"已退票";
                        
                        break;
                }
                cell.textLabel.text = [NSString stringWithFormat:@"订单状态:%@",orderStatus];
                
            }else if (indexPath.row == 6){
               
                if ([orderModel.status integerValue] == 3 ||[orderModel.status integerValue] ==4||[orderModel.status integerValue] ==5) {
                    
                    if ([orderModel.hall_name containsString:@"通兑票"]) {
                        
                        cell.textLabel.text = [NSString stringWithFormat:@"凭证号:%@",orderModel.voucher_code];
                        if (orderModel.voucher_code == nil ||[orderModel.voucher_code isEqualToString:@""]) {
                            cell.textLabel.text = @"凭证号:";
                        }
                    }else{
                        cell.textLabel.text = [NSString stringWithFormat:@"取票号:%@",orderModel.print_code];
                        if (orderModel.print_code == nil ||[orderModel.print_code isEqualToString:@""]) {
                            cell.textLabel.text = @"取票号:";
                        }
                    }
                }else if (![orderModel.hall_name containsString:@"通兑票"]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"座位号:%@",orderModel.seat];
                }else{
                    cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools getTime:orderModel.create_time]];
                    UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
                    [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
                    questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
                    [questionBtn addTarget:self action:@selector(callKeFu) forControlEvents:UIControlEventTouchDown];
                    [cell.contentView addSubview:questionBtn];
                }
            }else if (indexPath.row == 7){
                if ([orderModel.hall_name containsString:@"通兑票"]) {
                    if ([orderModel.status integerValue] == 3 ||[orderModel.status integerValue] ==4||[orderModel.status integerValue] ==5 ) {
                          cell.textLabel.text = [NSString stringWithFormat:@"有效期至:%@",[JWTools getTime:orderModel.period_validity]];
                    }
                }else{
                    if (([orderModel.status integerValue] == 3 ||[orderModel.status integerValue] ==4||[orderModel.status integerValue] ==5) && ![orderModel.hall_name containsString:@"通兑票"]) {
                        cell.textLabel.text = [NSString stringWithFormat:@"取票验证码:%@",orderModel.verify_code];
                        if (orderModel.verify_code == nil || [orderModel.verify_code isEqualToString:@""]) {
                            cell.textLabel.text = @"取票验证码:本影院不需要取票验证码";
                        }
                        
                    }else{
                        cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools getTime:orderModel.create_time]];
                        UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        
                        questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
                        [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
                        questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                        [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
                        [questionBtn addTarget:self action:@selector(callKeFu) forControlEvents:UIControlEventTouchDown];
                        [cell.contentView addSubview:questionBtn];
 
                    }
                }
            }else if (indexPath.row == 8){
                if ([orderModel.hall_name containsString:@"通兑票"]) {
                    if ([orderModel.status integerValue] == 3 ||[orderModel.status integerValue] ==4||[orderModel.status integerValue] ==5 )
                    
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools getTime:orderModel.create_time]];
                        UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        
                        questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
                        [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
                        questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                        [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
                        [questionBtn addTarget:self action:@selector(callKeFu) forControlEvents:UIControlEventTouchDown];
                        [cell.contentView addSubview:questionBtn];
                    }

                }else if (![orderModel.hall_name containsString:@"通兑票"]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"座位号:%@",orderModel.seat];
                }
            }else if (indexPath.row == 9){
                if (![orderModel.hall_name containsString:@"通兑票"]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"上映时间:%@",[JWTools dateStr:orderModel.period_validity]];
                }
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"下单时间:%@",[JWTools dateStr:orderModel.create_time]];
                UIButton * questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                 
                questionBtn.frame = CGRectMake(kScreen_Width * 0.65f, 5, kScreen_Width * 0.3f, 34);
                [questionBtn setTitle:@"对订单有疑问?" forState:UIControlStateNormal];
                questionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [questionBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
                [questionBtn addTarget:self action:@selector(callKeFu) forControlEvents:UIControlEventTouchDown];
                [cell.contentView addSubview:questionBtn];
                

            }
        }
        
    }
    return cell;
}
-(void)callKeFu{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * call = [UIAlertAction actionWithTitle:@"客服电话:4001505599" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:@"tel:4001505599"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }];
    [alertVC addAction:call];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark  --allDatas
-(void)getDatas{
    NSString*urlStr;
    if (self.status == 0) {
        
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYORDERDETAIL];
    }else{//电影
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_ORDERDETAIL];
    }

    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":self.order_id};
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MyLog(@"电影详情：%@",responseObject);
        NSNumber*number = responseObject[@"errorCode"] ;
        [self.orderAry removeAllObjects];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSDictionary*dict = responseObject[@"data"];
            OrderModel*model=[OrderModel yy_modelWithDictionary:dict];
            self.orModel = [OrderModel yy_modelWithDictionary:dict];
            self.shop_id = model.shop_id;
            [self.orderAry addObject:model];
            
            [self.orderTableView reloadData];
//            MyLog(@"orderAry = %@",_orderAry);
        }else{
            [JRToast showWithText:responseObject[@"errorMessage"]];
        }
        [self.orderTableView.mj_header endRefreshing];
        [self.orderTableView.mj_footer endRefreshing];
    
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
       
    }];

}
- (void)requestRefundData{
    NSString * urlStrr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REFUNDORDER];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"order_id":self.order_id,@"token":[UserSession instance].token};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStrr withParams:pragrams compliation:^(id data, NSError *error) {
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            
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
