//
//  YWForRecommendViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWForRecommendViewController.h"
#import "YWMainShoppingTableViewCell.h"
#import "HPRecommendShopModel.h"

#import "YWShoppingDetailViewController.h"  //跳转到店铺

#define CELL0   @"YWMainShoppingTableViewCell"
@interface YWForRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*mADatasModel;
@end

@implementation YWForRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"为你推荐";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWMainShoppingTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
  
    [self setUpMJRefresh];
}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.mADatasModel=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.mADatasModel=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}


#pragma mark  -- UI

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mADatasModel.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMainShoppingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    NSInteger number=indexPath.section;
    HPRecommendShopModel*model=self.mADatasModel[number];

    //图片
    UIImageView*photo=[cell viewWithTag:1];
    [photo sd_setImageWithURL:[NSURL URLWithString:model.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //标题
    UILabel*titleLabel=[cell viewWithTag:2];
    titleLabel.text=model.company_name;
    
    //星星数量 -------------------------------------------------------
    CGFloat realZhengshu;
    CGFloat realXiaoshu;
    NSString*starNmuber=model.star;
    NSString*zhengshu=[starNmuber substringToIndex:1];
    realZhengshu=[zhengshu floatValue];
    NSString*xiaoshu=[starNmuber substringFromIndex:1];
    CGFloat CGxiaoshu=[xiaoshu floatValue];
    
    if (CGxiaoshu>0.5) {
        realXiaoshu=0;
        realZhengshu= realZhengshu+1;
    }else if (CGxiaoshu>0&&CGxiaoshu<=0.5){
        realXiaoshu=0.5;
    }else{
        realXiaoshu=0;
        
    }
    
    for (int i=30; i<35; i++) {
        UIImageView*imageView=[cell viewWithTag:i];
        if (imageView.tag-30<realZhengshu) {
            //亮
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
        }else if (imageView.tag-30==realZhengshu&&realXiaoshu!=0){
            //半亮
            imageView.image=[UIImage imageNamed:@"home_halfStar"];
            
        }else{
            //不亮
            imageView.image=[UIImage imageNamed:@"home_grayStar"];
        }
        
        
    }
    //---------------------------------------------------------------------------
    
    
    //人均
    UILabel*per_capitaLabel=[cell viewWithTag:3];
    per_capitaLabel.text=[NSString stringWithFormat:@"%@/人",model.per_capita];
    
 
    //分类
    UILabel*categoryLabel=[cell viewWithTag:4];
    NSArray*array=model.tag_name;
    NSString*arrayStr=[array componentsJoinedByString:@" "];
    categoryLabel.text=[NSString stringWithFormat:@"%@ %@",model.catname,arrayStr];   //model.catname
    
    //店铺所在的商圈
    UILabel*shopLocLabel=[cell viewWithTag:6];
    shopLocLabel.text=model.company_near;

    
    
    //这下面的文字
    UILabel*zheLabel=[cell viewWithTag:7];
    NSString*zheNum=[model.discount substringFromIndex:2];
    zheLabel.text=[NSString stringWithFormat:@"%@折，闪付立享",zheNum];
    
    CGFloat num=[model.discount floatValue];
    if (num>=1) {
        zheLabel.text=@"不打折";
    }

    
    
    
    //特图片
    UIImageView*imageTe=[cell viewWithTag:8];
    imageTe.hidden=YES;
    //特旁边的文字
    UILabel*teLabel=[cell viewWithTag:9];
    teLabel.hidden=YES;
    
    //显示的特别活动   nsarray 里面string越多 显示越多的内容
    
    cell.holidayArray=model.holiday;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger number=indexPath.section;
    HPRecommendShopModel*model=self.mADatasModel[number];
    YWShoppingDetailViewController*vc=[[YWShoppingDetailViewController alloc]init];
    vc.shop_id=model.id;
    [self.navigationController pushViewController:vc animated:YES];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPRecommendShopModel*model=self.mADatasModel[indexPath.section];
    return [YWMainShoppingTableViewCell getCellHeight:model.holiday];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark  --Datas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_MORELOADING];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSInteger number=[data[@"errorCode"] integerValue];
        if (number==0) {
            for (NSDictionary*dict in data[@"data"]) {
                HPRecommendShopModel*model=[HPRecommendShopModel yy_modelWithDictionary:dict];
                [self.mADatasModel addObject:model];
            }

            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
