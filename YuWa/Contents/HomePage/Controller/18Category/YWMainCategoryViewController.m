//
//  YWMainCategoryViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMainCategoryViewController.h"


#import "YWMainShoppingTableViewCell.h"   



#import "YWChooseOneView.h"    //   choose 1
#import "YWChooseTwoView.h"     //choose 2



#define CELL0    @"YWMainShoppingTableViewCell"

@interface YWMainCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)UIView*cover;  //蒙版
@property(nonatomic,strong)YWChooseOneView*chooseOneView;   //选中的第一个视图
@property(nonatomic,strong)YWChooseTwoView*chooseTwoView;   //第二个视图

@end

@implementation YWMainCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets=YES;
    [self.view addSubview: self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWMainShoppingTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pleaseSetMap];
    
}

- (void)pleaseSetMap{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways &&[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse && [CLLocationManager authorizationStatus] !=kCLAuthorizationStatusNotDetermined) {
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

-(UIView*)makeTopChooseView{
    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    
    NSArray*array=@[@"小吃快餐",@"全城",@"智能排序",@"筛选"];
    
    for (int i=0; i<4; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(i*kScreen_Width/4, 0, kScreen_Width/4, 40)];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_arrow_dropdown_selected"] forState:UIControlStateSelected];
        [button setTitleColor:CNaviColor forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag=100+i;
        [button addTarget:self action:@selector(touchFourButton:) forControlEvents:UIControlEventTouchUpInside];

         [topView addSubview:button];
        

        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width, 0, button.imageView.bounds.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
        
        
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(kScreen_Width/4+kScreen_Width/4*i, 8, 1, 24)];
        lineView.backgroundColor=RGBCOLOR(229, 229, 229, 1);
        [topView addSubview:lineView];
       
        
        
        
    }
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreen_Width, 1)];
    bottomView.backgroundColor=RGBCOLOR(229, 229, 229, 1);
    [topView addSubview:bottomView];
    
    return topView;
    
}

#pragma mark --  tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMainShoppingTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];

    UIView*backgroundView=[cell viewWithTag:111];
    if (!backgroundView) {
        backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 145, kScreen_Width, 10)];
        backgroundView.backgroundColor=RGBCOLOR(239, 239, 239, 1);
        [cell.contentView addSubview:backgroundView];
        backgroundView.hidden=YES;
    }
    backgroundView.hidden=NO;
    
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
         return [self makeTopChooseView];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 40;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -- touch
-(void)touchFourButton:(UIButton*)sender{
//    MyLog(@"%lu",sender.tag);
    for (int i=0; i<4; i++) {
        UIButton*button=[self.view viewWithTag:100+i];
        if (button.tag==sender.tag) {
            
        }else{
             button.selected=NO;
        }
        //显示图
        UIView*showView=[self.view viewWithTag:3000+i];
        if (showView.tag==sender.tag+2900) {
            // 是当前的显示图
        }else{
           
            showView.hidden=YES;
            
        }
        
    }
    
    
    
    if (sender.selected==YES) {
        //取消选中
        sender.selected=NO;
        
        self.cover.hidden=YES;
        UIView*showView=[self.view viewWithTag:sender.tag+2900];
        showView.hidden=YES;
        
        
    }else{
#pragma 选中了某一个
        sender.selected=YES;
        self.cover.hidden=NO;

        
        if (sender.tag==100) {
            //分类
          
            NSArray*array=@[@{@"mainString":@"全部",@"subString":@"111"},@{@"mainString":@"火锅",@"subString":@"111"},@{@"mainString":@"生日蛋糕",@"subString":@"111"},@{@"mainString":@"甜点饮品",@"subString":@"111"},@{@"mainString":@"自助餐",@"subString":@"111"},@{@"mainString":@"小吃快餐",@"subString":@"111"},@{@"mainString":@"日韩料理",@"subString":@"111"},@{@"mainString":@"西餐",@"subString":@"111"},@{@"mainString":@"聚餐宴请",@"subString":@"111"},@{@"mainString":@"闽菜",@"subString":@"111"},@{@"mainString":@"烧烤烤肉",@"subString":@"111"},@{@"mainString":@"川湘菜",@"subString":@"111"},@{@"mainString":@"香锅烤鱼"}];
            
            
            if (array.count*44<kScreen_Height-64-40-75) {
                 self.chooseOneView.frame=CGRectMake(0, 64+40, kScreen_Width, array.count*44);
            }else{
                self.chooseOneView.frame=CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40-75);

            }
            self.chooseOneView.hidden=NO;
            self.chooseOneView.allDatas=array;
            
            __weak typeof(self)weakSelf = self;
            self.chooseOneView.ChooseOneBlock=^(NSString*name){
                
                [weakSelf touchDismiss];
                MyLog(@"%@",name);
                //此处吊接口   刷新
                
                
            };
            
            
            
        }else if (sender.tag==101){
            //城市
//            NSDictionary*dict=@{@"left":@"附近",@"right":@[@"附近",@"1km",@"3km",@"5km",@"10km",@"全城"]};
//            NSArray*array=@[dict,dict,dict,dict,dict,dict,dict];
            
//            NSDictionary*dict=@{@"附近":@[@"附近",@"1km",@"3km",@"5km",@"10km",@"全城"]};
//            NSArray*aStore=@[dict,dict,dict,dict,dict,dict];
//            
//            NSDictionary*dictt=@{@"1号线":@[@"全线",@"莘庄",@"上海火车站",@"中山北路",@"延长路",@"上海马戏城",@"汶水路"]};
//            NSArray*aSubway=@[dictt,dictt,dictt,dictt,dictt,dictt];
//            
//            NSArray*allArray=@[aStore,aSubway];
            
//            NSDictionary*dict=@{@"mainString":@"浦东新区"};
//            NSArray*leftArray=@[dict,dict,dict,dict,dict,dict,dict,dict];
//            
//            NSDictionary*dictt=@{};
            
//            NSDictionary*dict=@{@"mainString":@};
            
            
            NSDictionary*subDict0=@{@"mainString":@"全部",@"subString":@"525"};
            NSDictionary*subDict1=@{@"mainString":@"中山公园",@"subString":@"125"};
            NSDictionary*subDict2=@{@"mainString":@"天山",@"subString":@"125"};
            NSDictionary*subDict3=@{@"mainString":@"古北",@"subString":@"12"};
            NSDictionary*subDict4=@{@"mainString":@"虹桥",@"subString":@"96"};
            NSDictionary*subDict5=@{@"mainString":@"上海影城/新华路",@"subString":@"51"};
            NSDictionary*subDict6=@{@"mainString":@"北新泾",@"subString":@"96"};
            NSDictionary*subDict7=@{@"mainString":@"动物园/虹桥机场",@"subString":@"17"};
            
            NSArray*subArray=@[subDict0,subDict1,subDict2,subDict3,subDict4,subDict5,subDict6,subDict7];
            
            NSDictionary*mainDict=@{@"长宁区":subArray};
            NSArray*allArray=@[mainDict,mainDict,mainDict,mainDict,mainDict,mainDict,mainDict,mainDict];
            
            
            self.chooseTwoView.hidden=NO;
            self.chooseTwoView.frame=CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40-75);
            self.chooseTwoView.allDatas=allArray;

            
            __weak typeof(self)weakSelf=self;
            self.chooseTwoView.touchAddressBlock=^(NSInteger number){
                //传不同的值   就两个
                 weakSelf.chooseTwoView.allDatas=allArray;
                
            };
            
            
            self.chooseTwoView.touchTableViewCellBlock=^(NSString*name){
                MyLog(@"%@",name);
                [weakSelf touchDismiss];
                
                
            };
            
            
            
            
        }else if (sender.tag==102){
            //智能排序
            
        }else if (sender.tag==103){
            //筛选
            
            
        }

        
        
    }
    
    
    
    
    
    
}

-(void)touchDismiss{
    self.cover.hidden=YES;
    for (int i=0; i<4; i++) {
        UIButton*button=[self.view viewWithTag:100+i];
        button.selected=NO;
        
        UIView*showView=[self.view viewWithTag:3000+i];
        showView.hidden=YES;
        

        
    }
}


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

-(UIView *)cover{
    if (!_cover) {
        _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40)];
        _cover.backgroundColor=[UIColor blackColor];
        _cover.alpha=0.6;
        _cover.hidden=YES;
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDismiss)];
        [_cover addGestureRecognizer:tap];
        
        [self.view  addSubview:_cover];
    }
    
    return _cover;
}

#pragma 3种选择类型
-(YWChooseOneView *)chooseOneView{
    if (!_chooseOneView) {
        _chooseOneView=[[YWChooseOneView alloc]init];
        _chooseOneView.backgroundColor=[UIColor whiteColor];
        _chooseOneView.tag=3000+0;
        _chooseOneView.hidden=YES;
        [self.view addSubview:_chooseOneView];
    }
    
    return _chooseOneView;
}

-(YWChooseTwoView *)chooseTwoView{
    if (!_chooseTwoView) {
        _chooseTwoView=[[YWChooseTwoView alloc]init];
        _chooseTwoView.backgroundColor=[UIColor whiteColor];
        _chooseTwoView.tag=3000+1;
        _chooseTwoView.hidden=YES;
        [self.view addSubview:_chooseTwoView];

    }
    
    return _chooseTwoView;
}

@end
