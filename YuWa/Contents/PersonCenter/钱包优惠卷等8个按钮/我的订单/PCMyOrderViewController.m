//
//  PCMyOrderViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCMyOrderViewController.h"

#import "YJSegmentedControl.h"
#import "MyOrderTableViewCell.h"
#import "JWTools.h"
#import "OrderModel.h"

#import "PCPayViewController.h"
#import "PostCommitViewController.h"   //发送评论界面
#import "CommendViewController.h"
#import "OrderDetailViewController.h"

#define CELL0   @"MyOrderTableViewCell"

@interface PCMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)UIView * wawaView;
@property(nonatomic,strong)NSMutableArray*maAllDatasModel;
@property(nonatomic,assign)int payType;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,copy)NSString * orderID;
@property (nonatomic,assign)NSInteger status;//1电影，0其他订单
@end

@implementation PCMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的订单";

    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [self addTopView];
    [self creatWawaView];
    [self setUpMJRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];

    
}

-(void)addTopView{
    NSArray * ary = @[@"我的订单",@"电影订单"];
    UISegmentedControl * segemetVC = [[UISegmentedControl alloc]initWithItems:ary];
    segemetVC.selectedSegmentIndex = 0;
    [segemetVC addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segemetVC;
    
    
    
    NSArray*array=@[@"全部订单",@"待付款",@"待评价",@"退款/售后"];
    YJSegmentedControl*topView=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 44) titleDataSource:array backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:topView];
    
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    MyLog(@"Index %ld", Index);
    switch (Index) {
        case 0:
            self.status = 0;
            [self.tableView.mj_header beginRefreshing];
            break;

           
        default:
            self.status = 1;
            [self.tableView.mj_header beginRefreshing];
            break;
    }
}
-(void)setUpMJRefresh{
    self.maAllDatasModel=[NSMutableArray array];
    self.payType=1;
    self.pagen=10;
    self.pages=0;
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.maAllDatasModel=[NSMutableArray array];
        self.pages=0;
        [self getDatas];
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];
    
    
    
    
    
    
}
- (void)creatWawaView{
    
    _wawaView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, kScreen_Width, kScreen_Height/2)];
    _wawaView.hidden = YES;
    [self.view addSubview:_wawaView];
    UIImageView * wawaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2, 130, kScreen_Width/3, kScreen_Width/3)];
    wawaImageView.centerX = kScreen_Width/2;
    wawaImageView.image = [UIImage imageNamed:@"娃娃"];
    [_wawaView addSubview:wawaImageView];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, wawaImageView.bottom, kScreen_Width/2, 40)];
    textLabel.centerX = kScreen_Width/2;
    textLabel.textAlignment = 1;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = RGBCOLOR(123, 124, 124, 1);
    textLabel.text = @"暂无此订单消息哦~";
    [_wawaView addSubview:textLabel];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.maAllDatasModel.count <=0) {
        self.wawaView.hidden = NO;
    }else{
        self.wawaView.hidden = YES;
    }
    return self.maAllDatasModel.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel * model = self.maAllDatasModel[indexPath.row];
    OrderDetailViewController * orderVC =[[OrderDetailViewController alloc]init];
    orderVC.order_id = model.order_id;
    orderVC.status = self.status;
    [self.navigationController pushViewController:orderVC animated:YES];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
      cell.selectionStyle=NO;
//    cell.textLabel.text=@"666";
    OrderModel*model=self.maAllDatasModel[indexPath.row];
    
    UIImageView*imageView=[cell viewWithTag:1];
    UILabel*titleLabel=[cell viewWithTag:2];
    UILabel*whereLabel=[cell viewWithTag:3];
    UILabel*timeLabel=[cell viewWithTag:4];
    UILabel*moneyLabel=[cell viewWithTag:5];
    UILabel*assessLabel=[cell viewWithTag:6];
    
    if (self.status == 0) {

    [imageView sd_setImageWithURL:[NSURL URLWithString:model.shop_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    titleLabel.text=model.shop_name;
    
    
    whereLabel.text=model.shop_address;
    whereLabel.numberOfLines = 0;

        
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.shop_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        titleLabel.text=model.cinema_name;
        
        
        whereLabel.text=model.address;
        whereLabel.numberOfLines = 0;

        
 
    }
    timeLabel.text=[NSString stringWithFormat:@"%@",[JWTools getTime:model.create_time]];
    self.orderID = model.order_id;

    moneyLabel.text=[NSString stringWithFormat:@"总价：%@",model.pay_money];
    if (self.status == 1) {
        moneyLabel.text = [NSString stringWithFormat:@"总价：%.2f",[model.pay_money floatValue]];
    }
    assessLabel.text=model.status;
    
    
    UIButton*selectedButton=cell.TouchButton;
    selectedButton.hidden=NO;
    if ([model.status isEqualToString:@"待付款"]) {
        selectedButton.tag=indexPath.row;
        [selectedButton setTitle:@"付款" forState:UIControlStateNormal];
        [selectedButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [selectedButton addTarget:self action:@selector(touchPayMoney:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([model.status isEqualToString:@"待评价"]){
        selectedButton.tag=indexPath.row;
        [selectedButton setTitle:@"评价" forState:UIControlStateNormal];
        [selectedButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [selectedButton addTarget:self action:@selector(touchCommit:) forControlEvents:UIControlEventTouchUpInside];
        if (self.status == 1) {
            
            if (model.film_code == nil) {
                selectedButton.hidden = YES;
            }
        }
        
    }else if ([model.status isEqualToString:@"已完成"]){
        selectedButton.hidden=YES;
    }
    
//    [selectedButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status ==1) {
        return 135;
    }
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
       OrderModel*model=self.maAllDatasModel[indexPath.row];
    if ([model.status isEqualToString:@"待付款"]) {
        
        return YES;
    }
    return NO;
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction*delete=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先调接口  如果失败就刷新tableView
        [self removeDatasWithModel:self.maAllDatasModel[indexPath.row]];
        //先移除model
        [self.maAllDatasModel removeObjectAtIndex:indexPath.row];
        //在删除row
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
        
        
//        [self removeDataWithModel:self.maMallDatas[indexPath.row]];
        
//        [self.maMallDatas removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        
    }];
    
    return @[delete];
}

#pragma mark  -- touchButton
-(void)touchPayMoney:(UIButton*)sender{
    MyLog(@"付钱");
    OrderModel*model=self.maAllDatasModel[sender.tag];
    PCPayViewController*vc=[[PCPayViewController alloc]init];
    if (self.status == 1) {
       vc.blanceMoney=[model.pay_money floatValue]/100;
    }else{
       vc.blanceMoney=[model.pay_money floatValue];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)touchCommit:(UIButton*)sender{
    MyLog(@"评论");
    OrderModel*model=self.maAllDatasModel[sender.tag];
    if (self.status== 0) {
        PostCommitViewController*vc=[[PostCommitViewController alloc]init];
        vc.stauts = 1;
        vc.shop_id=model.shop_id;
        vc.order_id=model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        CommendViewController * vc = [[CommendViewController alloc]init];
        vc.status = 1;
        vc.film_code = model.film_code;
        vc.order_id = model.order_id;
        if (model.film_code != nil) {
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --allDatas
-(void)getDatas{
    NSString*urlStr;
    if (self.status == 1) {//电影
         urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_ORDERLIST];
    }else{
         urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYORDER];
    }
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(self.payType),@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                OrderModel*model=[OrderModel yy_modelWithDictionary:dict];
                [self.maAllDatasModel addObject:model];
                
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
    
}

//接口 删除订单
-(void)removeDatasWithModel:(OrderModel*)model{
    NSString*order_id=model.order_id;
    NSString*urlStr;
    if (self.status == 1) {
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_DELETEMOVIEORDER];
 
    }else{
        urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_DELETEORDER];
  
    }
    NSDictionary*params=@{@"order_id":order_id,@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
        
        
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            [self.tableView.mj_header beginRefreshing];
        }

        
        
    }];
    
    
}


#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    NSInteger aa=selection+1;
    self.payType=(short)aa;
    [self.tableView.mj_header beginRefreshing];
    
    
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kScreen_Width, kScreen_Height-64-44) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
