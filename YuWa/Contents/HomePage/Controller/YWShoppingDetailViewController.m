//
//  YWShoppingDetailViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShoppingDetailViewController.h"


#import "DetailStoreFirstTableViewCell.h"    
#import "DetailStorePreferentialTableViewCell.h"
#import "ShowShoppingTableViewCell.h"
#import "CommentTableViewCell.h"
#import "StoreDescriptionTableViewCell.h"
#import "YWMainShoppingTableViewCell.h"

#import "YWPayViewController.h"    //优惠买单
#import "StorePhotoViewController.h"   //商家相册
#import "SeeMoreShoppingViewController.h"    //店铺商品详情
#import "ShowMoreCommitViewController.h"    //评论详情
#import "ScheduleViewController.h"    //预定
#import "YWLoginViewController.h"

#import "ShopdetailModel.h"     //店铺详情
#import "ShowShoppingModel.h"   //推荐商品
#import "CommentModel.h"   //推荐评论
#import "HPRecommendShopModel.h" //推荐商品

#import "MapNavNewViewController.h"//地图导航



#define CELL0   @"DetailStoreFirstTableViewCell"
#define CELL1   @"DetailStorePreferentialTableViewCell"
#define CELL2   @"ShowShoppingTableViewCell"
#define CELL3   @"CommentTableViewCell"
#define CELL4   @"StoreDescriptionTableViewCell"
#define CELL5   @"YWMainShoppingTableViewCell"


#define HeaderHeight 175.f
#import "PaytheBillView.h"
#import "YWdetailHeaderView.h"

@interface YWShoppingDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)PaytheBillView*topView;
@property(nonatomic,strong)UIView*bottomView;
@property(nonatomic,strong)YWdetailHeaderView*headerView;
//tableHeaderView上的两个控件 需要赋值
@property(nonatomic,strong)UIImageView*backgroundImageView;
@property(nonatomic,strong)UILabel*tableHeaderShowNumberLabel;

@property(nonatomic,strong)ShopdetailModel*mainModel;   //大model
@property(nonatomic,strong)NSMutableArray*maMDatasGoods;  //所有商品的model
@property(nonatomic,strong)NSMutableArray*maMCommit;  //所有评论的model
@property(nonatomic,strong)NSMutableArray*maMRecommend; //推荐的model
@property(nonatomic,assign)int conmentHight;


@end

@implementation YWShoppingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDatas];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self makeHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL2 bundle:nil] forCellReuseIdentifier:CELL2];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:CELL3];
        [self.tableView registerNib:[UINib nibWithNibName:CELL5 bundle:nil] forCellReuseIdentifier:CELL5];
    self.tableView.bounces = NO;
    // 得到浏览量
    [self getPageView];
}
//登录
- (BOOL)judgeLogin{
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return [UserSession instance].isLogin;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //需要判断 当前的naviBar 是否显示
   CGFloat offset_Y= self.tableView.contentOffset.y;
    
    if (offset_Y>=0&&offset_Y<=HeaderHeight-64) {
        CGFloat number=HeaderHeight-64;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:offset_Y/number];
        
        
        
    }else if (offset_Y>=HeaderHeight-64){
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        
    }

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
    
    
}

-(void)makeHeaderView{
    
    CGFloat topHeight =175.f;
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, topHeight)];
    self.bottomView.layer.masksToBounds=YES;
    
    self.backgroundImageView=[[UIImageView alloc]initWithFrame:self.bottomView.frame];
//    self.backgroundImageView.image=[UIImage imageNamed:@"backImage"];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_mainModel.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.bottomView addSubview:self.backgroundImageView];
    
    UIView *headerView=[[UIView alloc]initWithFrame:self.bottomView.frame];
    [headerView addSubview:self.bottomView];
    YWdetailHeaderView * headerView1 = [[YWdetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 175.f)];
   [headerView1.imageVIew sd_setImageWithURL:[NSURL URLWithString:_mainModel.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.headerView = headerView1;
    [headerView1.bgImageView sd_setImageWithURL:[NSURL URLWithString:_mainModel.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.tableView.tableHeaderView=headerView1;
   
    
    //图片上的按钮
    UIView*imageButtonView=[[NSBundle mainBundle]loadNibNamed:@"imageButtonView" owner:nil options:nil].firstObject;
    imageButtonView.layer.cornerRadius=25;
    imageButtonView.layer.masksToBounds=YES;
    imageButtonView.backgroundColor=[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.8];
//    imageButtonView.alpha=1;
    imageButtonView.frame=CGRectMake(kScreen_Width-10-50, topHeight-10-50, 50, 50);
    [headerView addSubview:imageButtonView];
    
    UILabel*numberLabel=[imageButtonView viewWithTag:2];
    numberLabel.text=[NSString stringWithFormat:@"%@张",self.mainModel.total_photo];
    self.tableHeaderShowNumberLabel=numberLabel;

    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTopImageView)];
    [imageButtonView addGestureRecognizer:tap];
    [headerView addGestureRecognizer:tap];
    


}

//headerTableView 赋值
-(void)giveValueForTableHeaderView{
    self.tableHeaderShowNumberLabel.text=[NSString stringWithFormat:@"%@张",self.mainModel.total_photo];
    [self.headerView.imageVIew sd_setImageWithURL:[NSURL URLWithString:_mainModel.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    [self.headerView.bgImageView sd_setImageWithURL:[NSURL URLWithString:_mainModel.company_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
}


#pragma mark   --- 滚动视图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    
//    NSLog(@"%f",offset_Y);
    if (offset_Y < 0) {
        //放大比例
        CGFloat add_topHeight = -(offset_Y);
        CGFloat scale = (HeaderHeight+add_topHeight)/HeaderHeight;
        //改变 frame
        CGRect contentView_frame = CGRectMake(0,-add_topHeight, kScreen_Width, HeaderHeight+add_topHeight);
//        NSLog(@"top  %f",contentView_frame.origin.y);
        self.bottomView.frame = contentView_frame;
        
        CGRect imageView_frame = CGRectMake(-(kScreen_Width*scale-kScreen_Width)/2.0f,0,kScreen_Width*scale,
                                            HeaderHeight+add_topHeight);
        self.backgroundImageView.frame = imageView_frame;
//        self.visualEffectView.frame=imageView_frame;


        
}
    
    if (offset_Y>=0&&offset_Y<=HeaderHeight-64) {
        CGFloat number=HeaderHeight-64;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:offset_Y/number];
       
        
    }else if (offset_Y>=HeaderHeight-64){
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];

    }
  
    //
    if (offset_Y>=HeaderHeight-64+20) {
        //加上的 view 显示
        self.topView.hidden=NO;
        
    }else{
        //加上的view 隐藏
        self.topView.hidden=YES;
        
    }
    
}


#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 5;
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return self.maMDatasGoods.count;
        
    }else if (section==3){
        return self.maMCommit.count;
        
    }else if (section==5){
        return self.maMRecommend.count;
    }
    return 1;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    
    if (indexPath.section==0) {
#pragma 优惠买单
       DetailStoreFirstTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        //标题
        UILabel*titleLabel=[cell viewWithTag:1];
        titleLabel.text=self.mainModel.company_name;
        
        //分数
        UILabel*pointLabel=[cell viewWithTag:2];
        pointLabel.text=[NSString stringWithFormat:@"%@",self.mainModel.star];
        //人均
        UILabel*per_capita=[cell viewWithTag:3];
        per_capita.text=[NSString stringWithFormat:@"人均：￥%@",self.mainModel.per_capita];
//        //优惠买单
        
        UIButton*disBuy=[cell viewWithTag:4];
        disBuy.layer.masksToBounds = YES;
        disBuy.layer.cornerRadius = 5;
        CGFloat aa=[self.mainModel.discount floatValue];
        if (aa>=1) {
            disBuy.enabled=NO;
            [disBuy setTitle:@"不能购买" forState:UIControlStateDisabled];
        }else{
            disBuy.enabled=YES;
        }
        
//        //月消费人次
//        UILabel*monthPay=[cell viewWithTag:5];
//        monthPay.text=[NSString stringWithFormat:@""];
        
        //地址
        UILabel*addresslabel=[cell viewWithTag:22];
        addresslabel.text=self.mainModel.company_address;
       
        //分数
        //星星数量 -------------------------------------------------------
        CGFloat realZhengshu;
        CGFloat realXiaoshu;
        NSString*starNmuber=self.mainModel.star;
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
        
        for (int i=40; i<45; i++) {
            UIImageView*imageView=[cell viewWithTag:i];
            if (imageView.tag-40<realZhengshu) {
                //亮
                imageView.image=[UIImage imageNamed:@"home_lightStar"];
            }else if (imageView.tag-40==realZhengshu&&realXiaoshu!=0){
                //半亮
                imageView.image=[UIImage imageNamed:@"home_halfStar"];
                
            }else{
                //不亮
                imageView.image=[UIImage imageNamed:@"home_grayStar"];
            }
            
            
        }
        //------------------------------------------
        
        //收藏按钮
        UIButton*collectionButton=[cell viewWithTag:25];
        if (!self.mainModel.is_collection) {
            [collectionButton setBackgroundImage:[UIImage imageNamed:@"page_collection"] forState:UIControlStateNormal];
        }else{
             [collectionButton setBackgroundImage:[UIImage imageNamed:@"page_collection_selected"] forState:UIControlStateNormal];
        }
        
        WEAKSELF;
        //加入到收藏夹
        cell.touchAddCollection=^(){
          
         [weakSelf addToCollection];
            
            
        };

        
        cell.touchPayBlock=^(){
            //点击支付
              [weakSelf gotoPay];
        };
        
        cell.touchLocateBlock=^(){
            //跳地图
            MapNavNewViewController * mapNaviVC = [[MapNavNewViewController alloc]init];
            mapNaviVC.coordinatex = weakSelf.mainModel.coordinatex;
            mapNaviVC.coordinatey = weakSelf.mainModel.coordinatey;
            mapNaviVC.shopName = weakSelf.mainModel.company_name;
            [weakSelf.navigationController pushViewController:mapNaviVC animated:YES];
            
        };
        cell.touchPhoneBlock=^(){
          //跳电话
            [weakSelf alertShowPhone];
        };
        
        cell.touchQiangBlock=^{
          //抢优惠券
//            MyLog(@"抢优惠券");
            [weakSelf rushCoupon];
        };
        
        
        cell.selectionStyle=NO;
        return cell;
        
    }else if (indexPath.section==1){
#pragma holiday
        
        DetailStorePreferentialTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        
        NSMutableArray*mtArray=[self.mainModel.holiday mutableCopy];
        
        if (!cell) {
            cell=[[DetailStorePreferentialTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL1];
        }
        [tableView setSeparatorColor:RGBCOLOR(228, 228, 228, 1)];
        cell.defultZhe=self.mainModel.discount;//这里不变model 到了cell里面变model
        cell.allDatas=[mtArray copy];
        
      
        cell.selectionStyle=NO;
        return cell;
        
    }else if (indexPath.section==2){
        
#pragma 商品
       
        cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        cell.selectionStyle=NO;
//       ShowShoppingModel*model= self.maMDatasGoods[indexPath.row];
        
        
//        UIImageView*leftImage=[cell viewWithTag:1];
//        [leftImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//        
//        
//        UILabel*titleLabel=[cell viewWithTag:2];
//        titleLabel.text=model.goods_name;
//        
//        
//        UILabel*detailLabel=[cell viewWithTag:3];
//        detailLabel.text=model.goods_info;
        //获取内容高度
//        CGRect rect = [detailLabel.text boundingRectWithSize:CGSizeMake(detailLabel.frame.size.width, 999)
//                                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
//                                                    context:nil];
//      
//        self.conmentHight =rect.size.height;
//        UILabel*moneyLabel=[cell viewWithTag:4];
//        moneyLabel.text=[NSString stringWithFormat:@"￥%@",model.goods_price];
        
        
        
        return cell;
        
        
        
        
    }else if (indexPath.section==3){
#pragma 评论
        CommentModel*model=self.maMCommit[indexPath.row];
      
        
        CommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL3];
        cell.selectionStyle=NO;
        [cell giveValueWithModel:model];
        
              return cell;
        
    }else if (indexPath.section==4){
#pragma 商家详情
     
        
        
        StoreDescriptionTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL4];
        if (!cell) {
            cell=[[StoreDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL4 ];
        }
        cell.selectionStyle=NO;
        cell.allDatas=self.mainModel.infrastructure;
        return cell;
        
        
    }else if (indexPath.section==5){
        
#pragma 为你推荐
        
        YWMainShoppingTableViewCell* cell= [[[NSBundle mainBundle]loadNibNamed:@"YWMainShoppingTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle=NO;
        
        
         HPRecommendShopModel*model=self.maMRecommend[indexPath.row];
        
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
        categoryLabel.text=[NSString stringWithFormat:@"%@",arrayStr];   //model.catname
        
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
        if (num>=1 || num == 0.00) {
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
    
    
    
    
    cell.textLabel.text=@"6666";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==5) {
         HPRecommendShopModel*model=self.maMRecommend[indexPath.row];
        YWShoppingDetailViewController*vc=[[YWShoppingDetailViewController alloc]init];
        vc.shop_id=model.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section==2){
        //更多店铺
        [self touchSeeMore];
        
    }else if (indexPath.section==3){
        //更多评论
        [self commitShowMore];
        
    }
    
    
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        if (self.maMDatasGoods.count<1) {
            return nil;
        }else{
        UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        headView.backgroundColor=[UIColor whiteColor];
        
        UILabel*label=[[UILabel alloc]init];
        label.text=@"推荐商品";
        label.font=FONT_CN_30;
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_left).offset(10);
            make.centerY.mas_equalTo(headView.mas_centerY);
            
        }];
        
        UIImageView*imageView=[[UIImageView alloc]init];
        imageView.image=[UIImage imageNamed:@"home_rightArr"];
        [headView addSubview:imageView];

        UIButton*button=[[UIButton alloc]init];
        [button setTitle:@"查看更多" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchSeeMore) forControlEvents:UIControlEventTouchUpInside];

        
//        button.backgroundColor=CNaviColor;
        [button setTitleColor:CNaviColor forState:UIControlStateNormal];
        button.titleLabel.font=FONT_CN_30;
        [headView addSubview:button];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView.right).offset(-20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(headView.mas_centerY);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView.right).offset(-40);
            make.centerY.mas_equalTo(headView.mas_centerY);
        
        }];
        
        button.frame=CGRectMake(kScreen_Width-80-20, 10, 80, 20);
        
        return headView;
        }
    }else if (section==3){
        
#pragma 评论
        UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreen_Width, 40)];
        headerView.backgroundColor=[UIColor whiteColor];
        
        CGFloat toLeft=15;
        for (int i=0; i<5; i++) {
            UIImageView*imageView=[[UIImageView alloc]init];
//            imageView.backgroundColor=[UIColor blueColor];
            imageView.image=[UIImage imageNamed:@"home_lightStar"];
            imageView.tag=i+100;
            [headerView addSubview:imageView];
            
           
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(headerView.mas_centerY);
                    make.left.mas_equalTo(toLeft);
                    make.size.mas_equalTo(CGSizeMake(12, 12));
                    
                }];
                
            toLeft=toLeft+3+12;
            
        }
        
        //星星数量 -------------------------------------------------------
        CGFloat realZhengshu;
        CGFloat realXiaoshu;
        NSString*starNmuber=self.mainModel.star;
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
        
        for (int i=0; i<5; i++) {
            UIImageView*imageView=[headerView viewWithTag:i+100];
            if (imageView.tag-100<realZhengshu) {
                //亮
                imageView.image=[UIImage imageNamed:@"home_lightStar"];
            }else if (imageView.tag-100==realZhengshu&&realXiaoshu!=0){
                //半亮
                imageView.image=[UIImage imageNamed:@"home_halfStar"];
                
            }else{
                //不亮
                imageView.image=[UIImage imageNamed:@"home_grayStar"];
            }
            
            
        }
        //--------------------------------------------------------------------------
        
        
        
        UIImageView*rightImageView=[headerView viewWithTag:100+4];
        UILabel*pointLabel=[[UILabel alloc]init];
        pointLabel.text=[NSString stringWithFormat:@"%@分",self.mainModel.star];
        pointLabel.font=FONT_CN_24;
        [headerView addSubview:pointLabel];
        [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(rightImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            
        }];
        
        
        
        
        UILabel*label1=[[UILabel alloc]init];
        label1.text=self.mainModel.top_than_other;
        label1.font=FONT_CN_24;
        [headerView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pointLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            
        }];

        UILabel*numberLabel=[[UILabel alloc]init];
        numberLabel.text=[NSString stringWithFormat:@"%@条评论",self.mainModel.total_comment];
        numberLabel.font=FONT_CN_24;
        [headerView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headerView.mas_right).offset(-15);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            
        }];

        
        
        return headerView;
        
        
    }else if (section==5){
            UIView*view=[[UIView alloc]init];
            view.backgroundColor=[UIColor whiteColor];
            
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 15, 15)];
//            imageView.backgroundColor=[UIColor greenColor];
            imageView.image=[UIImage imageNamed:@"home_jian"];
            [view addSubview:imageView];
            
            UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+15+10, 15, kScreen_Width/2, 15)];
            titleLabel.textColor=CNaviColor;
            titleLabel.text=@"为你推荐";
            titleLabel.font=FONT_CN_30;
            [view addSubview:titleLabel];
            
            
            return view;
    

        
    }
    
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        
    }else if (section==3){
        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        bottomView.backgroundColor=[UIColor clearColor];
        
        UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        backgroundView.backgroundColor=[UIColor whiteColor];
        [bottomView addSubview:backgroundView];
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width-15, 30)];
        [button setTitle:@"查看全部评价" forState:UIControlStateNormal];
        [button setTitleColor:CNaviColor forState:UIControlStateNormal];
        button.titleLabel.font=FONT_CN_24;
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
        [button addTarget:self action:@selector(commitShowMore) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:button];
        
        UIImageView*rightArr=[[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width-30, 8, 14, 14)];
        rightArr.image=[UIImage imageNamed:@"home_rightArr"];
        [backgroundView addSubview:rightArr];
        
        
        return bottomView;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        if (self.maMDatasGoods.count < 1) {
            return 0.01f;
        }else{
            return 40;
        }
    }else if (section==3){
        return 40;
    }else if (section==5){
        return 40;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 10;
    }else if (section==3){
        return 30+10;   //10是空余的
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
        
    }else if (indexPath.section==1){
        NSMutableArray*mtArray=[self.mainModel.holiday mutableCopy];
        return [DetailStorePreferentialTableViewCell getCellHeightWitharray:mtArray];
    }else if (indexPath.section==2){
        if (self.maMDatasGoods.count <1) {
            return 0.01;
        }else{
           
            return 95+self.conmentHight-13;
        }
    }else if (indexPath.section==3){

        CommentModel*model=self.maMCommit[indexPath.row];
        return [CommentTableViewCell getCellHeight:model];
        
        
    }else if (indexPath.section==4){

        NSArray*array=self.mainModel.infrastructure;
        return [StoreDescriptionTableViewCell getHeight:array];
        
        
    }else if (indexPath.section==5){
        
        HPRecommendShopModel*model=self.maMRecommend[indexPath.row];
        return [YWMainShoppingTableViewCell getCellHeight:model.holiday]-10;

    }
    
    return 44;
}

//打电话
-(void)alertShowPhone{
    if ([self judgeLogin]) {
        UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([self.mainModel.company_first_tel  isEqual: @""]) {
            if (self.mainModel.company_second_tel == nil) {
                
                UIAlertAction * alertACNO =[UIAlertAction actionWithTitle:@"商家未预留电话哦,您可以进行预约！" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:alertACNO];
            }else{
                WEAKSELF;
                UIAlertAction * alertAC2 =[UIAlertAction actionWithTitle:self.mainModel.company_second_tel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString*str=[NSString stringWithFormat:@"tel:%@",weakSelf.mainModel.company_second_tel];
                    UIWebView*callWebView=[[UIWebView alloc]init];
                    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebView];
                    
                    [alertVC addAction:alertAC2];
                }];
            }
            
        }else{
            UIAlertAction*alertAC=[UIAlertAction actionWithTitle:self.mainModel.company_first_tel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.mainModel.company_first_tel];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                
            }];
             [alertVC addAction:alertAC];
            }

            
#pragma 咨询
        WEAKSELF;
            UIAlertAction*consult=[UIAlertAction actionWithTitle:@"预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ScheduleViewController*vc=[[ScheduleViewController alloc]init];
                vc.shopid=weakSelf.shop_id;
                [weakSelf.navigationController pushViewController:vc animated:NO];
            }];
            
            
            UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            
           
            [alertVC addAction:consult];
            [alertVC addAction:cancel];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }
    
}


//抢优惠券
-(void)rushCoupon{
    if ([self judgeLogin]) {
      
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GET_CONPON];
        NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"shop_id":self.shop_id};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            NSNumber*number=data[@"errorCode"];
            NSString*errorCode =[NSString stringWithFormat:@"%@",number];
            if ([errorCode isEqualToString:@"0"]) {
                [JRToast showWithText:data[@"data"]];
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }

            
        }];
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  -- 店铺详情
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SHOPDETAIL];
     NSDictionary*dict=@{@"shop_id":self.shop_id,@"device_id":[JWTools getUUID]};
    NSMutableDictionary*params=[NSMutableDictionary dictionaryWithDictionary:dict];
    if ([UserSession instance].isLogin) {
        [params setObject:@([UserSession instance].uid) forKey:@"user_id"];
        [params setObject:[UserSession instance].token forKey:@"token"];
    }
   
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode =[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.mainModel=[ShopdetailModel yy_modelWithDictionary:data[@"data"]];
            
            self.maMDatasGoods=[NSMutableArray array];
            self.maMCommit=[NSMutableArray array];
            self.maMRecommend=[NSMutableArray array];
            
            //所有商品的model
            for (NSDictionary*dict in self.mainModel.goods) {
                ShowShoppingModel*model= [ShowShoppingModel yy_modelWithDictionary:dict];
                [self.maMDatasGoods addObject:model];
            }
            
            for (NSDictionary*dict in self.mainModel.comment) {
                CommentModel*model=[CommentModel yy_modelWithDictionary:dict];
                [self.maMCommit addObject:model];
            }
            
            for (NSDictionary*dict in self.mainModel.recommend_shop) {
                HPRecommendShopModel*model=[HPRecommendShopModel yy_modelWithDictionary:dict];
                [self.maMRecommend addObject:model];
            }
            
            [self giveValueForTableHeaderView];
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

        
        
    }];
    
    
}

//加入到收藏
-(void)addToCollection{
    if ([self judgeLogin]) {
 
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ADDCOLLECTION];
        NSLog(@"self.mainModel.id%@",self.mainModel.id);

    NSDictionary*params=@{@"shop_id":self.mainModel.id,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode =[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
            
            self.mainModel.is_collection=1;
        //xx 字段更改为1
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

    }];
    
    }
}

//浏览量
-(void)getPageView{
    if (![UserSession instance].isLogin) {
        return;
    }
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETPAGEVIEW];
    NSDictionary*params=@{@"user_id":@([UserSession instance].uid),@"shop_id":self.shop_id};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            
        }
        
    }];
    
}


#pragma mark  --  touch

-(void)touchSeeMore{
    SeeMoreShoppingViewController*vc=[[SeeMoreShoppingViewController alloc]init];
    vc.shop_id=self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)touchTopImageView{
   
    StorePhotoViewController*vc=[[StorePhotoViewController alloc]init];
    vc.shop_id=self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

//查看更多评论
-(void)commitShowMore{
//    MyLog(@"22");
    ShowMoreCommitViewController*vc=[[ShowMoreCommitViewController alloc]init];
    vc.shop_id=self.shop_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)gotoPay{
    MyLog(@"pay");
    if ([self judgeLogin]) {
//        CGFloat zhekou=[self.mainModel.discount floatValue];
        
//        YWPayViewController*vc=[YWPayViewController payViewControllerCreatWithWritePayAndShopName:self.mainModel.company_name andShopID:self.mainModel.id andZhekou:zhekou];
//        [self.navigationController pushViewController:vc animated:YES];

    }
    
  }

#pragma mark  --  set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(PaytheBillView *)topView{
    if (!_topView) {
        _topView=[[NSBundle mainBundle]loadNibNamed:@"PaytheBillView" owner:nil options:nil].firstObject;
        _topView.frame=CGRectMake(0, 64, kScreen_Width, 65);
        
        UILabel*titLabel=[_topView viewWithTag:1];
        UIButton*button=[_topView viewWithTag:2];
        
        CGFloat moneyF=[self.mainModel.discount floatValue];
        if (moneyF>=1 || moneyF <= 0.00) {
            button.enabled=NO;
            titLabel.text=@"不打折";
            [button setTitle:@"不能购买" forState:UIControlStateDisabled];
            
        }else{
            button.enabled=YES;
            NSString*zhe=[self.mainModel.discount substringFromIndex:2];
            if ([zhe integerValue] % 10 == 0) {
                zhe = [NSString stringWithFormat:@"%ld",[zhe integerValue]/10];
            }else{
                zhe = [NSString stringWithFormat:@"%.1f",[zhe floatValue]/10];
            }
            titLabel.text=[NSString stringWithFormat:@"雨娃闪付立享%@折",zhe];
            [button setTitle:@"优惠买单" forState:UIControlStateNormal];
           
        }
        
        
        WEAKSELF;
        _topView.touchPayBlock=^(){
            [weakSelf gotoPay];
            
        };
        [self.view addSubview:_topView];
        
    }
    
    return _topView;
    
}

-(NSMutableArray *)maMDatasGoods{
    if (!_maMDatasGoods) {
        _maMDatasGoods=[NSMutableArray array];
    }
    
    return _maMDatasGoods;
}


@end
