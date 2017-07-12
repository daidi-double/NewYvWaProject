//
//  ChooseMovieController.m
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChooseMovieController.h"
#import "ChooseMovieHeaderView.h"//电影详情海报
#import "CinameTableViewCell.h"
#import "MovieCinemaViewController.h"
#import "PlayViewController.h"
#import "CommendViewController.h"
#import "TableBGView.h"
#import "MovieDetailViewController.h"
#import "CinemaAndBuyTicketModel.h"

#import "CinemaModel.h"//影院id
#define CINEMASHOWCELL @"CinameTableViewCell"
@interface ChooseMovieController ()<UITableViewDelegate,UITableViewDataSource,ChooseMovieHeaderViewDelegate,UIGestureRecognizerDelegate,TableBGViewDelegate>
{
    UIButton * markTimeBtn;
    UIView * lineView;
    UIButton * markBtn;
    NSIndexPath * markIndexPath;
    TableBGView * tableViewBG;
    UIView * menuBG;
    
}
@property (nonatomic,strong) UITableView * movieTableView;
@property (nonatomic,strong) NSMutableArray * headerViewAry;//海报数据
@property (nonatomic,strong) NSMutableArray * movieDataAry;//电影场次数组
@property (nonatomic,assign) BOOL isselected;
@property (nonatomic,assign) NSInteger pages;//页数
@property (nonatomic,assign) NSInteger pagen;
@property (nonatomic,copy) NSString * time;//日期
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) ChooseMovieHeaderView * movieView;
@property (nonatomic,strong) CinemaAndBuyTicketModel * model;//头部model
@property (nonatomic,strong) CinemaModel * cinemaModel;//影院model
@property (nonatomic,strong) NSString * type;//类型
@property (nonatomic,copy)NSString * cityType;//地区类型：1单个地区，0是全部地区
@property (nonatomic,copy)NSString * typeList;//0：离我最近 1，价格最低，2好评优先
@end

@implementation ChooseMovieController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.filmName;
    [self.view addSubview:self.movieTableView];
    [self.movieTableView registerNib:[UINib nibWithNibName:CINEMASHOWCELL bundle:nil] forCellReuseIdentifier:CINEMASHOWCELL];
    _isselected = 0;
    self.pages=0;
    self.pagen = 10;
    self.type = @"0";
    self.typeList = @"0";
    self.cityType = @"0";
    self.time = [self todayDate];
    [self setRJRefresh];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMovieData];
}

- (void)setRJRefresh {
    self.pagen = 10;
    self.movieTableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.movieDataAry=[NSMutableArray array];
         [self requestMovieData];
         [self requestCinemaData];
    }];
    
    //上拉刷新
    self.movieTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
         [self requestCinemaData];
        
    }];
    [self.movieTableView.mj_header beginRefreshing];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieDataAry.count;
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        self.movieView.model = self.model;
        return self.bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kScreen_Height *0.3 + 40.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 100.f;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MovieCinemaViewController * MCinemaVC = [[MovieCinemaViewController alloc]init];
    CinemaModel * models = self.movieDataAry[indexPath.row];
    MCinemaVC.cinema_code = models.code;
    MCinemaVC.film_code = self.model.code;//35050321
    MCinemaVC.cityCode = self.cityCode;
    MCinemaVC.filmName = self.filmName;
    if (([models.goodstype integerValue] == 1 ||[models.goodstype integerValue] == 4)&&[models.goodstype integerValue] !=3 ) {
        
        MCinemaVC.status = 0;
    }else if ([models.goodstype integerValue] == 3){
        return;
    }else{
        MCinemaVC.status = 1;
    }
    
    [self.navigationController pushViewController:MCinemaVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CinameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CINEMASHOWCELL];
    self.cinemaModel = self.movieDataAry[indexPath.row];
    cell.model = self.cinemaModel;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}
- (void)menuBtnAction:(UIButton*)btn{
    NSLog(@"%ld",btn.tag);
    btn.selected = YES;
    markBtn.selected = NO;
    markBtn = btn;

    
    [self creatPlaceView:btn.tag andTitle:btn.titleLabel.text];
    
}

- (void)creatPlaceView:(NSInteger)tag andTitle:(NSString *)title{
    UIView * bgView2;
    if (!menuBG) {
       bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        bgView2.backgroundColor = [UIColor whiteColor];
        bgView2.backgroundColor = CNaviColor;
        [self.view addSubview:bgView2];
        menuBG = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationHeight, kScreen_Width, kScreen_Height)];
        menuBG.backgroundColor = RGBCOLOR(195, 202, 203, 0.3);
        
        [self.view addSubview:menuBG];
    }
    bgView2.hidden = NO;
    menuBG.hidden = NO;
    UITapGestureRecognizer*cancelFirstObject=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelMenuBG:)];
    cancelFirstObject.numberOfTouchesRequired = 1;
    cancelFirstObject.numberOfTapsRequired = 1;
    cancelFirstObject.delegate= self;
    menuBG.contentMode = UIViewContentModeScaleToFill;
    [menuBG addGestureRecognizer:cancelFirstObject];
    UIView * bgView;
    if (tableViewBG) {
        [tableViewBG removeFromSuperview];
    }
    if (bgView) {
        [bgView removeFromSuperview];
    }
    if (tag == 1112) {
        tableViewBG = [[TableBGView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 45*3 + 30) andTag:tag andTitle:title andIndex:1 andFilmCode:self.filmCode andCityCode:self.cityCode] ;
    }else{
        CGFloat hight;
        if (44 * self.cityCodeAry.count <= kScreen_Height * 0.7f) {
            hight = 44* self.cityCodeAry.count;
        }else{
            hight = kScreen_Height * 0.7f;
        }
        tableViewBG = [[TableBGView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, hight) andTag:tag andTitle:title andIndex:1 andFilmCode:self.filmCode andCityCode:self.cityCode];
    }
    tableViewBG.filmCode = self.filmCode;
    tableViewBG.cityCode = self.cityCode;
    tableViewBG.delegate = self;
    tableViewBG.backgroundColor = [UIColor whiteColor];
    if (markBtn.tag != tag) {
        for (UIButton * touchBtn in _bgView.subviews) {
            if (touchBtn.tag == tag) {
                markBtn = touchBtn;
            }
        }
    }
    __weak typeof(markBtn)weakBtn = markBtn;
    __weak typeof(menuBG)weakMenuBG = menuBG;
    __weak typeof(bgView2)weakBgView = bgView2;
    WEAKSELF;
    tableViewBG.titleBlock = ^(NSString *titleStr,NSString * cityCode){
        weakBtn.selected = NO;
        [weakBtn setTitle:titleStr forState:UIControlStateNormal];
        weakMenuBG.hidden = YES;
        weakBgView.hidden = YES;
        if ([titleStr isEqualToString:@"全部地区"]) {
            weakSelf.cityType = @"0";
        }else{
            weakSelf.cityType = @"1";
        }
        weakSelf.cityCode = cityCode;
        weakSelf.pages = 0;
        [weakSelf requestCinemaData];
    };
    tableViewBG.titleBlockT = ^(NSString * titleStr,NSString * listType){
        weakBtn.selected = NO;
        [weakBtn setTitle:titleStr forState:UIControlStateNormal];
        weakMenuBG.hidden = YES;
        weakBgView.hidden = YES;
        weakSelf.typeList = listType;
        weakSelf.pages = 0;
        [weakSelf requestCinemaData];
        
    };
    [menuBG addSubview:tableViewBG];
    if (tag == 1111) {
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, tableViewBG.bottom+30, kScreen_Width, kScreen_Height)];
    }else{
       bgView = [[UIView alloc]initWithFrame:CGRectMake(0, tableViewBG.bottom, kScreen_Width, kScreen_Height)];
    }
    bgView.backgroundColor = [UIColor lightGrayColor];
    bgView.alpha = 0.7f;
    [menuBG addSubview:bgView];
    
    
}
- (void)cancelMenuBG:(UIGestureRecognizer*)tap{
    tap.view.hidden = YES;
    _isselected = 0;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_movieTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    
}
//获取今天的日期
- (NSString *)todayDate{
    return [JWTools currentTime2];
}
- (NSString *)tomorrowDate{
    return [JWTools tommorowTime];
}
- (NSString *)threeDayDate{
    return [JWTools getThreeDayTime];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)cancelFirstObject:(UIGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    _isselected = 0;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [_movieTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)tapDetali{
    NSLog(@"详细界面");
    MovieDetailViewController * vc = [[MovieDetailViewController alloc]init];
    vc.filmCode = self.filmCode;
    MyLog(@"filmCode233 = %@",self.filmCode);
//    vc.cinemaDetailModel = self.model;051100192011
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)play{
    PlayViewController * playVC = [[PlayViewController alloc]init];
    
    [self.navigationController pushViewController:playVC animated:YES];
}
-(void)commend{
    CommendViewController * commendVC = [[CommendViewController alloc]init];
    commendVC.headerModel = self.model;
    [self.navigationController pushViewController:commendVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//判断是否登入
- (BOOL)judgeLogin{

    return [UserSession instance].isLogin;
}
#pragma mark -- http
- (void)requestMovieData{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAANDBUYTICKET];

    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmCode":self.filmCode,@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
       
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"电影信息%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"][@"filmsInfo"]) {
                
                self.model = [CinemaAndBuyTicketModel yy_modelWithDictionary:dict];
            }

        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
//    [self.movieTableView.mj_header endRefreshing];
//    [self.movieTableView.mj_footer endRefreshing];
    
}
//获取影院数据
- (void)requestCinemaData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMANDDATE];
    NSString * pagesStr = [NSString stringWithFormat:@"%ld",self.pages];
    NSString * pagenStr = [NSString stringWithFormat:@"%ld",self.pagen];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"filmCode":self.filmCode,@"pages":pagesStr,@"pagen":pagenStr,@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey,@"type":self.cityType,@"typeList":self.typeList,@"area":self.cityCode};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"电影影院和购票，影院数据下半部%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            if (self.pages == 0) {
                
                [self.movieDataAry removeAllObjects];
            }
            for (NSDictionary * cinemaDic in data[@"data"]) {
                
                self.cinemaModel = [CinemaModel yy_modelWithDictionary:cinemaDic];
                [self.movieDataAry addObject:self.cinemaModel];
            }
            
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
        [self.movieTableView.mj_header endRefreshing];
        [self.movieTableView.mj_footer endRefreshing];
    
}
- (UIView*)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.3f+65.5)];
        _bgView.backgroundColor = [UIColor whiteColor];
        

        NSArray * arr = @[@"全部地区",@"离我最近"];
        
        for (int i = 0; i<2; i++) {
            UIButton * timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            timeBtn.frame = CGRectMake(kScreen_Width/2*i, _bgView.height - 65.5, kScreen_Width/2, 40);
            NSString * titleTime = [NSString stringWithFormat:arr[i],i];
            [timeBtn setTitle:titleTime forState:UIControlStateNormal];
            [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            timeBtn.tag = 1111 + i;
            timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [timeBtn setTitleColor:[UIColor colorWithHexString:@"#d5d5d5"] forState:UIControlStateSelected];
            [timeBtn setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
            [timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
            [timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            
            [timeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];

            [timeBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:timeBtn];
            
        }
    }
    return _bgView;
}

- (ChooseMovieHeaderView*)movieView{
    if (!_movieView) {
        
        _movieView = [[ChooseMovieHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.3f)];
        _movieView.delegate =self;
        [self.bgView addSubview:_movieView];
        UITapGestureRecognizer*PrivateTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetali)];
        PrivateTap.numberOfTouchesRequired = 1;
        PrivateTap.numberOfTapsRequired = 1;
        PrivateTap.delegate= self;
        _movieView.contentMode = UIViewContentModeScaleToFill;
        [_movieView addGestureRecognizer:PrivateTap];
        _movieView.backgroundColor = [UIColor darkGrayColor];
    }
    return _movieView;
}

- (UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        
    }
    return _movieTableView;
}

- (NSMutableArray*)headerViewAry{
    if (!_headerViewAry) {
        _headerViewAry = [NSMutableArray array];
    }
    return _headerViewAry;
}

- (NSMutableArray*)movieDataAry{
    if (!_movieDataAry) {
        _movieDataAry = [NSMutableArray array];
    }
    return _movieDataAry;
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
