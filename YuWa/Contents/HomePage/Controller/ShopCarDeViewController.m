//
//  YWShopCarViewController.m
//  YuWa
//
//  Created by double on 17/4/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopCarDeViewController.h"
#import "ShopCarDetailTableViewCell.h"
#import "YWCarListModel.h"
#import "YWNewDiscountPayViewController.h"

#define CARDETAILCELL  @"ShopCarDetailTableViewCell"
@interface ShopCarDeViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCarDetailTableViewCellDeleate>

@property (weak, nonatomic) IBOutlet UITableView *shopCarTableView;
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong) UIView * carView;

@end

@implementation ShopCarDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self requestData];
    [self.shopCarTableView registerNib:[UINib nibWithNibName:CARDETAILCELL bundle:nil] forCellReuseIdentifier:CARDETAILCELL];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCarDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CARDETAILCELL];
    if (!cell) {
        cell = [[ShopCarDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CARDETAILCELL];
    }
    
    YWCarListModel * model = self.dataAry[indexPath.section];
    cell.selectionStyle = NO;
    cell.delegate =self;
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWCarListModel * model = self.dataAry[indexPath.section];
    return [ShopCarDetailTableViewCell getHeight:model.cart];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPCARLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":self.shop_id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"购物车列表 data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            if ([data[@"msg"] isKindOfClass:[NSNull class]]) {
                [self.view addSubview:self.carView];
                return ;
            }
            if (self.carView) {
                [self.carView removeFromSuperview];
            }
            NSArray * datas = data[@"msg"];
            for (NSDictionary * dict in datas) {
                
                YWCarListModel * model = [YWCarListModel yy_modelWithDictionary:dict];
                [self.dataAry addObject:model];
                
            }
            [self.shopCarTableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
//去结算
-(void)goToAccount:(NSString *)money andBtn:(UIButton *)sender{
    ShopCarDetailTableViewCell * cell = (ShopCarDetailTableViewCell*)[[sender superview]superview];
    NSIndexPath * path = [self.shopCarTableView indexPathForCell:cell];
    YWCarListModel * model = self.dataAry[path.section];
    YWNewDiscountPayViewController * newVC = [YWNewDiscountPayViewController payViewControllerCreatWithWritePayAndShopName:model.company_name andShopID:model.id andZhekou:[model.discount floatValue]];
    newVC.model = model;
    newVC.money = money;
//    newVC.status = 2;
//    newVC.shopID = model.id;

    [self.navigationController pushViewController:newVC animated:YES];
}

//清空购物车
-(void)cleaerShopCarList:(UIButton *)sender{
    ShopCarDetailTableViewCell * cell = (ShopCarDetailTableViewCell*)[[[sender superview]superview]superview];
    NSIndexPath * path = [self.shopCarTableView indexPathForCell:cell];
    [self.dataAry removeObjectAtIndex:path.section];
    [self clearShopCar:cell.shop_id];
}
- (void)clearShopCar:(NSString *)shop_id{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_CLEARSHOPCARLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"shop_id":shop_id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"清空购物车%@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"deleteNun" object:nil userInfo:@{@"isClear":@(1),@"number":@(2)}];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self.shopCarTableView reloadData];

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
- (UIView *)carView{
    if (!_carView) {
        _carView = [[UIView alloc]initWithFrame:CGRectMake(30, 30, kScreen_Width, kScreen_Height)];
        _carView.center = CGPointMake(kScreen_Width/2, kScreen_Height/2);
      UIImageView * carImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/2, kScreen_Width/3)];
        carImageView.centerY = _carView.centerY - 50;
        carImageView.centerX = _carView.centerX - 20;
        carImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
        carImageView.image = [UIImage imageNamed:@"购物车图片"];
        [_carView addSubview:carImageView];
        
        UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, carImageView.bottom +20, kScreen_Width/2, kScreen_Width/6)];
        textLabel.centerX = _carView.centerX;
        textLabel.text = @"你还没有相关的订单";
        textLabel.textAlignment = 1;
        textLabel.font = [UIFont systemFontOfSize:13];
        [_carView addSubview:textLabel];
    }
    return _carView;
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
