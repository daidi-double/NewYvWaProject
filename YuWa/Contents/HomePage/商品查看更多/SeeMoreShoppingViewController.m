//
//  SeeMoreShoppingViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SeeMoreShoppingViewController.h"
#import "ShowShoppingTableViewCell.h"
#import "ShowShoppingModel.h"         //

#import "YWLoginViewController.h"
#import "HUDFailureShowView.h"
#import "JWTools.h"


#define CELL0   @"ShowShoppingTableViewCell"

@interface SeeMoreShoppingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property(nonatomic,assign)int conmentHight;
@end

@implementation SeeMoreShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"更多商品";
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpMJRefresh];
    
}


-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];

    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];

    }];
    
        [self.tableView.mj_header beginRefreshing];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maMallDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    if (self.maMallDatas.count<1) {
        return cell;
    }
    
//    ShowShoppingModel*model=self.maMallDatas[indexPath.row];
    
//    UIImageView*imageView=[cell viewWithTag:1];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
//    
//    UILabel*titleLabel=[cell viewWithTag:2];
//    titleLabel.text=model.goods_name;
    
    UILabel*detailLabel=[cell viewWithTag:3];
    CGRect rect = [detailLabel.text boundingRectWithSize:CGSizeMake(detailLabel.frame.size.width, 999)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                 context:nil];
    self.conmentHight = rect.size.height;
//    detailLabel.text=model.goods_info;
//    
//    UILabel*moneyLabel=[cell viewWithTag:4];
//    moneyLabel.text=[NSString stringWithFormat:@"￥%@",model.goods_price];
    
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95+self.conmentHight-13;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_MOREGOODS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"shop_id":self.shop_id,@"pagen":pagen,@"pages":pages};
    
    UIView*loadingView=[JWTools addLoadingViewWithframe:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
    [self.view addSubview:loadingView];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            
            
            
            for (NSDictionary*dict in data[@"data"]) {
                
                
                 ShowShoppingModel*model=[ShowShoppingModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }
             [self.tableView reloadData];
            
            if (self.maMallDatas.count<1) {
       [JRToast showWithText:@"没有更多商品了！" duration:3.5f];
            }
            
        }else if ([errorCode isEqualToString:@"9"]) {
            [JRToast showWithText:@"身份已过期，请重新登入"];
            
            YWLoginViewController * loginVC = [[YWLoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [loadingView removeFromSuperview];
        });
       
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



@end
