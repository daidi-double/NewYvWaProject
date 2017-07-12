//
//  YWShopCarView.m
//  YuWa
//
//  Created by double on 17/4/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShopCarView.h"
#import "YWShopCarTableViewCell.h"
#import "ShopDetailGoodsModel.h"


#define SHOPCARCELL @"YWShopCarTableViewCell"
@interface YWShopCarView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGRect  myFrame;
@property (nonatomic,strong) UIView *carView;
@end
@implementation YWShopCarView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.clearView];
        [self addSubview:self.shopTableView];
        [self.shopTableView registerNib:[UINib nibWithNibName:SHOPCARCELL bundle:nil] forCellReuseIdentifier:SHOPCARCELL];
        //监听总额点击出来之后调用的方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceShopAction1:) name:@"reduceShop1" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShopAction1:) name:@"addShop1" object:nil];
        if (self.shopInfoAry.count <= 0) {
            [self addSubview:self.carView];
        }else{
            if (self.carView) {
                [self.carView removeFromSuperview];
            }
        }
    }
    return self;
}
- (UIView *)carView{
    if (!_carView) {
        _carView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height)];
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

-(UIView*)clearView{
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 35)];
        _clearView.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        _strLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, _clearView.width * 0.4, 35)];
        _strLabel.text = @"已选商品";
        _strLabel.textColor = RGBCOLOR(112, 122, 112, 1);
        _strLabel.font = [UIFont systemFontOfSize:15];
        [_clearView addSubview:_strLabel];
        UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(_clearView.width - 40, 5,25, 25);
        [clearBtn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
        [clearBtn setTitleColor:RGBCOLOR(112, 122, 112, 1) forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearAllShopAction:) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:clearBtn];
    }
    return _clearView;
}
-(void)reduceShopAction1:(NSNotification * )user{
    NSDictionary * dic1 = user.userInfo;
    UIButton * bnt = dic1[@"button"];
    YWShopCarTableViewCell * cell = (YWShopCarTableViewCell *)[[bnt superview] superview];
    NSString * str = cell.numbelLabel.text ;
    if ([str integerValue] == 0)return;
    [self reduceShopToCar:cell.goods_id addcell:cell];
}
-(void)addShopAction1:(NSNotification * )user{
    NSDictionary * dic1 = user.userInfo;
    UIButton * bnt = dic1[@"button"];
    YWShopCarTableViewCell * cell = (YWShopCarTableViewCell *)[[bnt superview] superview];
    [self addShopToCar:cell.goods_id addcell:cell];
}
//点减号，把商品传到服务器
- (void)reduceShopToCar:(NSString *)goodsID addcell:(YWShopCarTableViewCell *)cell{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_REDUCESHOPCAR];
    NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID],@"goods_id":goodsID};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSString * str = cell.numbelLabel.text ;
            cell.numbelLabel.text = [NSString stringWithFormat:@"%ld",[str integerValue] -1];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
            // NSData转为NSString
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        MyLog(@"减去商品 %@",jsonStr);
        //发送通知刷新联动界面数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"relodDate" object:nil];
    }];
}
//点击加号，把商品传到服务器
- (void)addShopToCar:(NSString *)goodsID addcell:(YWShopCarTableViewCell *)cell{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPCAR];
    NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID],@"goods_id":goodsID};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSString * str = cell.numbelLabel.text ;
        cell.numbelLabel.text = [NSString stringWithFormat:@"%ld",[str integerValue] +1];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        MyLog(@"减去商品 %@",jsonStr);
        //发送通知刷新联动界面数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"relodDate" object:nil];
    }];
}

- (UITableView*)shopTableView{
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, self.width, self.height-35) style:UITableViewStyleGrouped];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        
    }
    return _shopTableView;
}
//- (void)drawRect:(CGRect)rect {
//    
//}
- (void)clearAllShopAction:(UIButton *)sender {
    [self.shopInfoAry removeAllObjects];
    [self.delegate clearShop];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopInfoAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.shopInfoAry.count > 0) {
        
        if (self.carView) {
            [self.carView removeFromSuperview];
        }
    }
    YWShopCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SHOPCARCELL];
    NSDictionary * dit = self.shopInfoAry[indexPath.row];
        ShopDetailGoodsModel * goodModel = [ShopDetailGoodsModel yy_modelWithDictionary:dit];
    cell.model = goodModel;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
+(CGFloat)getCellHeight:(NSArray *)array{
    CGFloat top = 35.f;
    CGFloat cellHeight = 44 * array.count;
    return top + cellHeight;
}
-(void)dealloc  {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
