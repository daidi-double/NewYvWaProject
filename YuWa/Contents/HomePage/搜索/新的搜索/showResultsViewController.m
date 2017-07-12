//
//  showResultsViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/10/31.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "showResultsViewController.h"
#import "YWMainShoppingTableViewCell.h"

#import "HPRecommendShopModel.h"

#import "ShopDetailViewController.h"

#import "HUDLoadingShowView.h"

#define CELL0    @"YWMainShoppingTableViewCell"

@interface showResultsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation showResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"搜索结果";
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    if (self.ModelArray.count<1) {
        HUDLoadingShowView*view=[[NSBundle mainBundle]loadNibNamed:@"HUDLoadingShowView" owner:nil options:nil].firstObject;
        view.showLabel.text=@"抱歉没有数据。。";
        view.center = CGPointMake(kScreen_Width/2, kScreen_Height/3);
        [self.view addSubview:view];
        
        
        return;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];

}

#pragma mark  -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.ModelArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMainShoppingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    HPRecommendShopModel*model=self.ModelArray[indexPath.section];
    
    
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
    if (model.catname == nil && arrayStr == nil) {
        categoryLabel.hidden = YES;
    }else if (model.catname == nil){
        model.catname = @"";
    }else if (arrayStr == nil ){
        arrayStr = @"";
    }
    categoryLabel.text=[NSString stringWithFormat:@"%@ %@",model.catname,arrayStr];   //model.catname
    //店铺所在的商圈
    UILabel*shopLocLabel=[cell viewWithTag:6];
    shopLocLabel.text=model.company_near;

    
    
    //这下面的文字
    UILabel*zheLabel=[cell viewWithTag:7];
    NSString*zheNum=[model.discount substringFromIndex:2];
    
    if ([zheNum integerValue] % 10 == 0) {
        zheNum = [NSString stringWithFormat:@"%ld",[zheNum integerValue]/10];
    }else{
        zheNum = [NSString stringWithFormat:@"%.1f",[zheNum floatValue]/10];
    }
    zheLabel.text=[NSString stringWithFormat:@"%@折，闪付立享",zheNum];

    CGFloat num=[model.discount floatValue];
    if (num>=1 || num<= 0.00) {
        zheLabel.text=@"不打折";
    }

    cell.zhekou = model.discount;
    //特图片
    UIImageView*imageTe=[cell viewWithTag:8];
    imageTe.hidden=YES;
    //特旁边的文字
    UILabel*teLabel=[cell viewWithTag:9];
    teLabel.hidden=YES;
    
    //显示的特别活动
      cell.holidayArray=model.holiday;
  
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HPRecommendShopModel*model=self.ModelArray[indexPath.section];

    
    ShopDetailViewController*vc=[[ShopDetailViewController alloc]init];
    vc.shop_id=model.id;
    [self.navigationController pushViewController:vc animated:YES];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //最后一排 来判断得到的高度
    //          return 145;
    HPRecommendShopModel*model=self.ModelArray[indexPath.row];
    NSArray*specail=model.holiday;
    CGFloat top=158.0;
    for (int i=0; i<specail.count; i++) {
        top=top+18+10;
    }
    
    return top;

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
