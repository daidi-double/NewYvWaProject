//
//  LookAllCinemaViewController.m
//  YuWa
//
//  Created by double on 17/6/12.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "LookAllCinemaViewController.h"
#import "CinemaModel.h"
#import "SearchViewController.h"
#import "CinameTableViewCell.h"
#import "MovieCinemaViewController.h"


#define  CINEMACELL @"CinameTableViewCell"
@interface LookAllCinemaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *movieTableView;
@property (nonatomic,strong)NSMutableArray * theaterNameAry;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger pagen;

@end

@implementation LookAllCinemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部影院";
    self.pagen = 10;
    self.pages = 0;
    [self setRJRefresh];
    [self getHomePageCinemaList];
    UIBarButtonItem * searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_homepage_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchMovie)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    [self.view addSubview:self.movieTableView];
    [self.movieTableView registerNib:[UINib nibWithNibName:CINEMACELL bundle:nil] forCellReuseIdentifier:CINEMACELL];
}
- (void)setRJRefresh {
    
    self.movieTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.theaterNameAry=[NSMutableArray array];
        [self getHomePageCinemaList];
        
    }];
    
    //上拉刷新
    self.movieTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
       
        [self getHomePageCinemaList];
        
    }];
    
}


- (void)searchMovie{
    SearchViewController *vc=[[SearchViewController alloc]init];
    vc.coordinatey = self.coordinatey;
    vc.coordinatex = self.coordinatex;
    vc.cityCode = self.cityCode;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.theaterNameAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CinameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CINEMACELL];
    CinemaModel * model = self.theaterNameAry[indexPath.section];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CinemaModel * model = self.theaterNameAry[indexPath.section];
    
    MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
    movieVC.cinema_code = model.code;
    movieVC.cityCode = model.city;
    if ([model.goodstype integerValue] != 1) {
        movieVC.status = 1;
        
    }else{
        
        movieVC.status = 0;
        
    }
    [self.navigationController pushViewController:movieVC animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}
//获取首页影院列表
- (void)getHomePageCinemaList{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOME_CINEMALIST];
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":@"0",@"device_id":[JWTools getUUID],@"typeList":@"0",@"pages":@(self.pages),@"pagen":@(self.pagen),@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([UserSession instance].isLogin) {
        [dic setValue:[UserSession instance].token forKey:@"toke"];
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
    }
    
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"首页影院列表 %@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            NSArray * dataAry = data[@"data"];
            if (dataAry.count>0) {
                [self.theaterNameAry removeAllObjects];
                self.pages ++;
                
            }else{
                if (self.pages == 0) {
                    [self.theaterNameAry removeAllObjects];
                }
            }
            for (NSDictionary * dict in data[@"data"]) {
                CinemaModel * model = [CinemaModel yy_modelWithDictionary:dict];
                [self.theaterNameAry addObject:model];
            }
            
            [self.movieTableView reloadData];
            [self.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else{
            [JRToast showWithText:@"网络异常,请检查网络" duration:1];
        }
        [self.movieTableView.mj_header endRefreshing];
        [self.movieTableView.mj_footer endRefreshing];
    }];
    
}
-(UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
    }
    return _movieTableView;
}
- (NSMutableArray *)theaterNameAry{
    if (!_theaterNameAry) {
        _theaterNameAry = [NSMutableArray array];
    }
    return _theaterNameAry;
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
