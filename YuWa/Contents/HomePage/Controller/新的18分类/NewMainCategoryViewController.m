//
//  NewMainCategoryViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NewMainCategoryViewController.h"
#import "YWMainShoppingTableViewCell.h"
#import "JSDropDownMenu.h"

#import "JWTools.h"

#import "PHCategoryModel.h"
#import "PHSubCategoryModel.h"
#import "PHAreaModel.h"
#import "PHBusinessCircleModel.h"
#import "PHOrderModel.h"

#import "HPRecommendShopModel.h"   //tableViewCell  Model
#import "ShopDetailViewController.h"  //push 到一个界面


#define CELL0    @"YWMainShoppingTableViewCell"

@interface NewMainCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;

    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;

    
    NSInteger _currentData1SelectedIndex;
    NSInteger _currentData2SelectedIndex;
    JSDropDownMenu *menu;
}

@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*maCategoryModel;   //18个类的model数组
@property(nonatomic,strong)NSMutableArray*maCityModel;   //地址商圈的model数据
@property(nonatomic,strong)NSMutableArray*maSortModel;  //排序的所有数组

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property (nonatomic, strong) NSMutableArray *tableViewDatasModel;

@end

@implementation NewMainCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //得到title 上的内容   接口
    [self getCategoryDatas];

    [self setUpTableView];
    
    [self setUpMJRefresh];


}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_data1 removeAllObjects];
    [_data2 removeAllObjects];
    [_data3 removeAllObjects];
    _data1 = nil;
    _data2= nil;
    _data3 = nil;

    [_maCityModel removeAllObjects];
    [_maCategoryModel removeAllObjects];
    [_maCityModel removeAllObjects];
    [_maCityModel removeAllObjects];
    [_maSortModel removeAllObjects];
   
    _maCityModel= nil;
    _maCategoryModel = nil;
    _maCityModel = nil;
    _maCityModel= nil;
    _maSortModel = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //得到title 上的内容   接口
    [self getCategoryDatas];
    
    [self setUpTableView];
    
    [self setUpMJRefresh];

}
#pragma mark --  UI
-(void)initDropMenu{
    //决定了 初始选择的位置 导航栏下的（美食、附近、离我最近）
    _currentData1Index=0;
    _currentData2Index=0;
    _currentData3Index=0;
   
    
    _currentData1SelectedIndex=0;
    _currentData2SelectedIndex=0;
    
    
    _currentData1Index=self.categoryTouch;
    
    
     menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
 

    menu.separatorColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
 
    
}

-(void)setUpTableView{
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
}


#pragma mark  -- tableView
-(void)setUpMJRefresh{

    self.pagen=10;
    self.pages=0;
    self.tableViewDatasModel=[NSMutableArray array];
    
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.tableViewDatasModel=[NSMutableArray array];
        [self getTableViewAllDatas];

    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getTableViewAllDatas];

    }];
    
    
    
    //-----------------------------
//    MJRefreshGifHeader*gifHeader=[UIScrollView scrollRefreshGifHeaderwithRefreshBlock:^{
//        self.pages=0;
//        self.tableViewDatasModel=[NSMutableArray array];
//        [self];
//        
//    }];
//    self.tableView.mj_header=gifHeader;
//     //立即刷新
//    //    [self.tableView.mj_header beginRefreshing];
//    
//    
//    //上拉刷新
//    MJRefreshAutoGifFooter*gifFooter=[UIScrollView scrollRefreshGifFooterWithRefreshBlock:^{
//        self.pages++;
//        [self getTableViewAllDatas];
//        
//        
//    }];
//    self.tableView.mj_footer=gifFooter;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewDatasModel.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMainShoppingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    
    UIView * bgLine = [self.view viewWithTag:1000];
    bgLine.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle=NO;
    cell.bgLineView.hidden = YES;
    NSInteger number=indexPath.section;
    HPRecommendShopModel*model=self.tableViewDatasModel[number];

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
    if (num>=1||num==0.00) {
        zheLabel.text=@"不打折";
    }

    
    //特图片
    UIImageView*imageTe=[cell viewWithTag:8];
    imageTe.hidden=YES;
    //特旁边的文字
    UILabel*teLabel=[cell viewWithTag:9];
    teLabel.hidden=YES;

    cell.zhekou = model.discount;

    //显示的特别活动   nsarray 里面string越多 显示越多的内容
    
    cell.holidayArray=model.holiday;

    

     return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
           NSInteger number=indexPath.section;
        HPRecommendShopModel*model=self.tableViewDatasModel[number];
        
        ShopDetailViewController*vc=[[ShopDetailViewController alloc]init];
        vc.shop_id=model.id;
        [self.navigationController pushViewController:vc animated:YES];
        
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HPRecommendShopModel*model=self.tableViewDatasModel[indexPath.section];
    if (self.tableViewDatasModel.count <2) {
        
        return [YWMainShoppingTableViewCell getCellHeight:model.holiday] +15;
    }
    return [YWMainShoppingTableViewCell getCellHeight:model.holiday]+5;

}

#pragma mark --   menu
//下拉Menu
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
//    if (column==2) {
//        
//        return YES;
//    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0||column==1) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0||column==1) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    

        return _currentData3Index;
    
}


- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            PHCategoryModel*model=_data1[leftRow];
            return  [model.tag count];
            
        }
    } else if (column==1){
        if (leftOrRight==0) {
            return _data2.count;
        }else{

            PHAreaModel*model=_data2[leftRow];
            return [model.business count];
            
        }
       
        
    } else if (column==2){
        
        return self.maSortModel.count;
    }
    
    return 0;
}

// 那一条上显示的名字 共3个
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:{

            PHCategoryModel*model= _data1[_currentData1Index];
            PHSubCategoryModel*dictM=model.tag[_currentData1SelectedIndex];
            
            MyLog(@"%@",dictM.tag_name);
            return dictM.tag_name;

            break;}
        case 1:{

            PHAreaModel*model=_data2[_currentData2Index];
            PHBusinessCircleModel*subModel=model.business[_currentData2SelectedIndex];
            MyLog(@"%@",subModel.business_name);
            return subModel.business_name;

            break;}
        case 2:{
            PHOrderModel*model=self.maSortModel[_currentData3Index];
            return model.order_name;
           
            break;}
        default:
            return nil;
            break;
    }
}



//每一个row 显示的内容
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {

             PHCategoryModel*model= _data1[indexPath.row];
            return model.class_name;
            
        } else{

             PHCategoryModel*model= _data1[indexPath.leftRow];
            NSArray*array=model.tag;
            PHSubCategoryModel*subModel=array[indexPath.row];
            return subModel.tag_name;
            
               }
    } else if (indexPath.column==1) {
        
        if (indexPath.leftOrRight==0) {
            PHAreaModel*model=_data2[indexPath.row];
            return model.class_name;
        
        } else{
            PHAreaModel*model=_data2[indexPath.leftRow];
            NSArray*array=model.business;
            PHBusinessCircleModel*subModel=array[indexPath.row];
            return subModel.business_name;
            
            
        }

        
    } else {
        PHOrderModel*model=_data3[indexPath.row];
        return model.order_name;
        
       
    }
    
    
   
}



- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
   
    switch (indexPath.column) {
        case 0:{
//            leftOrRight
            if (indexPath.leftOrRight==0) {
                 _currentData1Index=indexPath.leftRow;
                
            }else{
                _currentData1SelectedIndex=indexPath.row;
                //吊用接口
                [self.tableView.mj_header beginRefreshing];
                
            }
            
            
            break;}
            
        case 1:{
            if (indexPath.leftOrRight==0) {
                  _currentData2Index=indexPath.leftRow;
            }else{
                 _currentData2SelectedIndex=indexPath.row;
                //吊用接口
                [self.tableView.mj_header beginRefreshing];

            }
          
         
            break;}
            
        case 2:{
            
            _currentData3Index=indexPath.row;
            //吊用接口
            [self.tableView.mj_header beginRefreshing];
        
            break;}
        default:
            break;
    }

    
}



#pragma mark  --  Datas

-(void)getCategoryDatas{
    self.maCategoryModel=[NSMutableArray array];
    self.maCityModel=[NSMutableArray array];
    self.maSortModel=[NSMutableArray array];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_GETCATEGORY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID]};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data[@"data"]);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
//            errorCode = 0 表示请求成功
            for (NSDictionary*dict in data[@"data"][@"allCategory"]) {
                PHCategoryModel*model=[PHCategoryModel yy_modelWithDictionary:dict];
                [self.maCategoryModel addObject:model];
            }
            
            
            for (NSDictionary*dict in data[@"data"][@"allBusiness"]) {
                PHAreaModel*model=[PHAreaModel yy_modelWithDictionary:dict];
                [self.maCityModel addObject:model];
                
            }
            
            for (NSDictionary*dict in data[@"data"][@"allOrder"]) {
                PHOrderModel*model=[PHOrderModel yy_modelWithDictionary:dict];
                [self.maSortModel addObject:model];
            }


            _data1=self.maCategoryModel;
            _data2=self.maCityModel;
            _data3=self.maSortModel;
            
            //获取上面的一条的数据
             [self initDropMenu];
            //刷新
            [self.tableView.mj_header beginRefreshing];
 
        }else{
            [JRToast showWithText:data[@"data"]];
            
        }
        
        
    }];

    
}


-(void)getTableViewAllDatas{
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];


    NSMutableDictionary*params=[NSMutableDictionary dictionary];
    [params setObject:[JWTools getUUID] forKey:@"device_id"];
    [params setObject:pagen forKey:@"pagen"];
    [params setObject:pages forKey:@"pages"];
    
    PHCategoryModel*model=self.maCategoryModel[_currentData1Index];
    NSString*categoryName=model.class_name;
    
    PHSubCategoryModel*subModel=model.tag[_currentData1SelectedIndex];
    NSString*subCategoryName=subModel.tag_name;
    
    NSNumberFormatter*numberFormatter=[[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if ([categoryName isEqualToString:subCategoryName]) {
        //大分类的名字和小标签的名字 一样的话 就不传tag的id
        
    }else{
        NSNumber*aa=[numberFormatter numberFromString:subModel.tag_id];
       
        [params setObject:aa forKey:@"tag_id"];
    }
    
    NSNumber*bb=[numberFormatter numberFromString:model.id];
    [params setObject:bb forKey:@"cid"];
    
    //得到bid
    PHAreaModel*Citymodel=self.maCityModel[_currentData2Index];
    PHBusinessCircleModel*businessModel=Citymodel.business[_currentData2SelectedIndex];
  
    NSNumber*cc=[numberFormatter numberFromString:businessModel.bid];
    [params setObject:cc forKey:@"bid"];
    //得到按哪个顺序排列
    PHOrderModel*sortModel=self.maSortModel[_currentData3Index];
    NSNumber*dd=[numberFormatter numberFromString:sortModel.id];
    [params setObject:dd forKey:@"order_by"];
    
#pragma 原理： 如果分类和tag 名字一样 就不传tag  其他参数不变

    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_CATEGORYSHOW];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            for (NSDictionary*dict in data[@"data"]) {
                HPRecommendShopModel*model=[HPRecommendShopModel yy_modelWithDictionary:dict];
                [self.tableViewDatasModel addObject:model];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    
    return _tableView;
}


-(void)dealloc{

    
}
@end
