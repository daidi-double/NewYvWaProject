//
//  MovieViewController.m
//  YuWa
//
//  Created by double on 2017/2/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieViewController.h"
#import "HotMovieScrollView.h"//轮播scrollview
#import "HotMovieCollectCell.h"
#import "CinameTableViewCell.h"
#import "ChooseMovieController.h"
#import "DetaliViewController.h"
#import "LookAllViewController.h"
#import "MovieCinemaViewController.h"
#import "LookDetaliViewController.h"
#import "SearchViewController.h"//需要修改
#import "TableBGView.h"
#import "OtherTicketModel.h"
#import "NewHotMovieCollectCell.h"
#import "CityCodeModel.h"

#import "HotMovieModel.h"//热映电影model
#import "BannerModel.h"//轮播图模型
#import "MovieHeaderModel.h"

#import "LookAllCinemaViewController.h"
#import "HomeCinemaListModel.h"//影院模型

#define newHotCell  @"NewHotMovieCollectCell"
#define CINEMASHOWCELL @"CinameTableViewCell"
@interface MovieViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,HotMovieScrollViewDelegate,UIGestureRecognizerDelegate,TableBGViewDelegate>
{
    UIButton * markBtn;
    NSInteger  markIndexPath;
    UIPageControl * _page;
    NSIndexPath * markTableIndexPath;
    TableBGView * tableViewBG;
    UIView * menuBG;
    HotMovieScrollView * hotScrollView;
    UIView * bgView2;//遮挡层
    UIView * btnView12;//筛选地区
}

@property (nonatomic,strong) UITableView * movieTableView;
@property (nonatomic,strong) NSMutableArray * theaterNameAry;//影城列表数据
@property (nonatomic,strong) NSMutableArray * hotMovieSAry;//轮播热映数组
@property (nonatomic,strong) NSMutableArray * hotCollectDataAry;//热映影片数组
@property (nonatomic,strong) NSMutableArray * cityCodeAry;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,copy)NSString * cinema_code;//影院编码
@property (nonatomic,copy)NSString * cityCode;//城市编码
@property (nonatomic,copy)NSString * type;//地区类型：1单个地区，0是全部地区
@property (nonatomic,copy)NSString * typeList;//0：离我最近 1，价格最低，2好评优先
@property (nonatomic,strong) UICollectionView *movieCollectView;
@property (nonatomic,assign)BOOL isselected;
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger pagen;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityCode = @"350500";//目前只使用泉州地区编码

    self.pagen = 10;
    self.pages = 0;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = @"0";
    self.typeList = @"0";
    if (self.coordinatex== nil||self.coordinatey == nil) {
        self.coordinatex = @"118:37";
        self.coordinatey = @"24:54";
    }
    [self.view addSubview:self.movieTableView];
    [self.movieTableView registerNib:[UINib nibWithNibName:CINEMASHOWCELL bundle:nil] forCellReuseIdentifier:CINEMASHOWCELL];
    [self setRJRefresh];
    [self requestBannerData];
    [self requestHotData];
    [self getlocatCityCode];
    [self getHomePageCinemaList];

   UIImage * image = [UIImage imageNamed:@"yuwabaomovie"];

    UIImageView * titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width*20/image.size.height, 20)];
    titleImageView.image = image;
    titleImageView.centerX = kScreen_Width/2;
    self.navigationItem.titleView = titleImageView;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
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



#pragma mark - tableViewDelete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.theaterNameAry.count;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * headerFirstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 1052/1334.f)];
        //轮播图
        hotScrollView = [[HotMovieScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, headerFirstView.size.height * 610/1052.f) andDataAry:self.hotMovieSAry];
        hotScrollView.contentSize = CGSizeMake(self.hotMovieSAry.count*kScreen_Width, headerFirstView.size.height * 0.4f);//容量要根据数据修改
        hotScrollView.delegate = self;
        hotScrollView.pagingEnabled = YES;
        hotScrollView.HotDelegate = self;
        hotScrollView.showsHorizontalScrollIndicator = NO;
        [headerFirstView addSubview:hotScrollView];
        
        UIPageControl * moviePage = [[UIPageControl alloc]initWithFrame:CGRectMake(0, hotScrollView.height* 0.85f, kScreen_Width, 30)];
        moviePage.numberOfPages = self.hotMovieSAry.count;//修改
        moviePage.currentPage = 0;
        moviePage.currentPageIndicatorTintColor = [UIColor redColor];
        moviePage.pageIndicatorTintColor = [UIColor whiteColor];
        [headerFirstView addSubview:moviePage];
        [moviePage addTarget:self action:@selector(pageController:) forControlEvents:UIControlEventValueChanged];
        if (self.timer == nil) {
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        }
        if (self.hotMovieSAry.count>0) {
            [self.timer setFireDate:[NSDate distantPast]];
        }else{
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        _page = moviePage;
        
        
        UIView * hotMovieBGView = [[UIView alloc]initWithFrame:CGRectMake(0, hotScrollView.bottom, kScreen_Width, 40)];
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        
        line3.backgroundColor = RGBCOLOR(245, 246, 247, 1);
        [hotMovieBGView addSubview:line3];
        
        [headerFirstView addSubview: hotMovieBGView];
        UILabel * hotLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width/2, 40)];
        hotLbl.textAlignment = NSTextAlignmentLeft;
        hotLbl.textColor = [UIColor colorWithHexString:@"#333333"];
        hotLbl.font = [UIFont systemFontOfSize:15];
        hotLbl.text = @"正在热映";
        
        [hotMovieBGView addSubview:hotLbl];
        
        UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 6, 24)];
        blueView.backgroundColor = CNaviColor;
        [hotMovieBGView addSubview:blueView];
        
        UIButton * lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lookBtn.frame = CGRectMake(kScreen_Width - 13 - 70, 3, 70, hotMovieBGView.size.height);
        [lookBtn setTitle:@"全部 >" forState:UIControlStateNormal];
        [lookBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [lookBtn addTarget:self action:@selector(lookAll:) forControlEvents:UIControlEventTouchUpInside];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [hotMovieBGView addSubview:lookBtn];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, kScreen_Width, 0.5)];
        line2.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [hotMovieBGView addSubview:line2];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        self.movieCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, hotMovieBGView.bottom+12, kScreen_Width, headerFirstView.size.height*328/1052)  collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.movieCollectView.showsHorizontalScrollIndicator = FALSE;
        [_movieCollectView registerNib:[UINib nibWithNibName:newHotCell bundle:nil] forCellWithReuseIdentifier:newHotCell];
        _movieCollectView.backgroundColor = [UIColor whiteColor];
        _movieCollectView.delegate = self;
        _movieCollectView.dataSource = self;
        [headerFirstView addSubview:_movieCollectView];
        
        
        return headerFirstView;
    }else{
        return self.headerView;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height * 1052/1334.f;
        
    }else{
        return 80.f;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0.1f;
    }else{
        return 100.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CinemaModel * model = self.theaterNameAry[indexPath.row];
    
    MovieCinemaViewController * movieVC = [[MovieCinemaViewController alloc]init];
    movieVC.cinema_code = model.code;
    movieVC.cityCode = model.city;
    if (([model.goodstype integerValue] == 1 ||[model.goodstype integerValue] == 4)&&[model.goodstype integerValue] !=3 ) {
        
        movieVC.status = 0;
    }else if ([model.goodstype integerValue] == 3){
        return;
    }else{
        movieVC.status = 1;
    }
    [self.navigationController pushViewController:movieVC animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        
    CinameTableViewCell * cinemaCell = [tableView dequeueReusableCellWithIdentifier:CINEMASHOWCELL];
    cinemaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CinemaModel * model = self.theaterNameAry[indexPath.row];
    cinemaCell.model = model;
    return cinemaCell;
    
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zeroCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zeroCell"];
        }
        return cell;
    }
    
}
#pragma mark - collectViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotCollectDataAry.count;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 12, 12, 12);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(kScreen_Width*184/750, kScreen_Height*(256+72)/1052);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    markIndexPath = indexPath.item;
    HotMovieModel * model = self.hotCollectDataAry[indexPath.item];
    //注意修改
    ChooseMovieController * choseVC = [[ChooseMovieController alloc]init];
    choseVC.filmCode = model.code;
    choseVC.filmName = model.name;
    choseVC.cityCodeAry = self.cityCodeAry;
    choseVC.cityCode = @"350500";//重新赋值回泉州地区
    choseVC.coordinatex = self.coordinatex;
    choseVC.coordinatey = self.coordinatey;
    [self.navigationController pushViewController:choseVC animated:YES];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewHotMovieCollectCell * collectCell = (NewHotMovieCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:newHotCell forIndexPath:indexPath];
    HotMovieModel * model = self.hotCollectDataAry[indexPath.item];
    collectCell.model = model;

    return collectCell;
}

#pragma mark - requestData
//轮播图
- (void)requestBannerData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOMEPAGE];

    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"电影轮播图%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                
                BannerModel* model = [BannerModel yy_modelWithDictionary:dict];
                [self.hotMovieSAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieTableView reloadData];
    }];
    [self.movieTableView.mj_header endRefreshing];
    [self.movieTableView.mj_footer endRefreshing];
    
}
//热映电影
- (void)requestHotData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOMEHOTMOVIE];

    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"电影首页热门影片%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.hotCollectDataAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                
                HotMovieModel* model = [HotMovieModel yy_modelWithDictionary:dict];
                [self.hotCollectDataAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时，请检查网络" duration:1];
        }
        [self.movieCollectView reloadData];
    }];
    [self.movieTableView.mj_header endRefreshing];
    [self.movieTableView.mj_footer endRefreshing];
    
}

//判断是否含有通兑票
- (void)judgeIsContentOtherTicket:(NSString*)cinema_code andFilmCode:(NSString*)filmCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_JUDGECONTENTOTHERTICKET];
    NSDictionary * pragrams = @{@"cityNo":self.cityCode,@"cinemaNo":cinema_code};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"是否有通兑票 %@",data);
        [self.otherTicketAry removeAllObjects];
        if ([data[@"errorCode"] integerValue] == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                OtherTicketModel * model = [OtherTicketModel yy_modelWithDictionary:dict];
                [self.otherTicketAry addObject:model];
                
            }

        }else{
            
        }
        
    }];

}
//获取地区编码
- (void)getlocatCityCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODE];
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":self.type};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"地区编码 %@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.cityCodeAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                CityCodeModel * model = [CityCodeModel yy_modelWithDictionary:dict];
                [self.cityCodeAry addObject:model];
            }
        }else{
           
        }

        
    }];
    
}
//获取首页影院列表
- (void)getHomePageCinemaList{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOME_CINEMALIST];
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":self.type,@"device_id":[JWTools getUUID],@"typeList":self.typeList,@"pages":@(self.pages),@"pagen":@(self.pagen),@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([UserSession instance].isLogin) {
        [dic setValue:[UserSession instance].token forKey:@"toke"];
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
    }
    
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"首页影院列表 %@",data);
        MyLog(@"参数%@",dic);
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
            if (self.pages > 1) {
                
                [self.movieTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }else{
            [JRToast showWithText:@"网络异常,请检查网络" duration:1];
        }
        [self.movieTableView.mj_header endRefreshing];
        [self.movieTableView.mj_footer endRefreshing];
    }];
    
}


- (void)lookAll:(UIButton*)btn{
    NSLog(@"查看全部");
    LookAllViewController * lookAllView = [[LookAllViewController alloc]init];
    lookAllView.coordinatex = self.coordinatex;
    lookAllView.coordinatey = self.coordinatey;
//    lookAllView.cityCode = self.cityCode;
    [self.navigationController pushViewController:lookAllView animated:YES];
}
//- (void)lookDetail:(UIButton*)sender{
//    NSLog(@"查看详情");
//    LookDetaliViewController * lookVC = [[LookDetaliViewController alloc]init];
//    [self.navigationController pushViewController:lookVC animated:YES];
//}
//搜索，查看全部影院
- (void)searchMovie{
    LookAllCinemaViewController *vc=[[LookAllCinemaViewController alloc]init];
    vc.coordinatey = self.coordinatey;
    vc.coordinatex = self.coordinatex;
    vc.cityCode = @"350500";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)menuBtn:(UIButton*)btn{
    NSLog(@"%ld",btn.tag);
    btn.selected = YES;
    markBtn.selected = NO;
    markBtn = btn;

    [self creatPlaceView:btn.tag andTitle:btn.titleLabel.text];
 
}

- (void)creatPlaceView:(NSInteger)tag andTitle:(NSString *)title{
    if (!menuBG) {
        bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
        bgView2.backgroundColor = [UIColor whiteColor];
        bgView2.backgroundColor = CNaviColor;
        [self.view addSubview:bgView2];
        menuBG = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height)];
        menuBG.backgroundColor = RGBCOLOR(195, 202, 203, 0.3);
        
        [self.view addSubview:menuBG];
    }
    menuBG.hidden = NO;
    bgView2.hidden = NO;
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
        tableViewBG = [[TableBGView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 45*3 + 30) andTag:tag andTitle:title andIndex:0 andFilmCode:nil andCityCode:self.cityCode];
    }else{
        CGFloat hight;
        if (44 * self.cityCodeAry.count <= kScreen_Height * 0.7f) {
            hight = 44* self.cityCodeAry.count+30;
        }else{
            hight = kScreen_Height * 0.7f+30;
        }
        tableViewBG = [[TableBGView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, hight) andTag:tag andTitle:title andIndex:0 andFilmCode:nil andCityCode:self.cityCode] ;
    }
    tableViewBG.delegate = self;
    tableViewBG.cityCode = self.cityCode;
    tableViewBG.backgroundColor = [UIColor whiteColor];
    if (markBtn.tag != tag) {
        for (UIButton * touchBtn in btnView12.subviews) {
            if (touchBtn.tag == tag) {
                markBtn = touchBtn;
            }
        }
    }
    __weak typeof(markBtn)weakBtn = markBtn;
    __weak typeof(menuBG)weakMenuBG = menuBG;
    __weak typeof(bgView2)weakBgView12  = bgView2;
    WEAKSELF;
    tableViewBG.titleBlock = ^(NSString *titleStr,NSString * cityCode){
        weakBtn.selected = NO;
        [weakBtn setTitle:titleStr forState:UIControlStateNormal];
        weakMenuBG.hidden = YES;
        weakBgView12.hidden = YES;
        if ([titleStr isEqualToString:@"全部地区"]) {
            weakSelf.type = @"0";
        }else{
            weakSelf.type = @"1";
        }
        weakSelf.cityCode = cityCode;
        weakSelf.pages = 0;
        [weakSelf getHomePageCinemaList];
    };
    tableViewBG.titleBlockT = ^(NSString * titleStr,NSString * listType){
        weakBtn.selected = NO;
        [weakBtn setTitle:titleStr forState:UIControlStateNormal];
        weakMenuBG.hidden = YES;
        weakBgView12.hidden = YES;
        weakSelf.typeList = listType;
        weakSelf.pages = 0;
        [weakSelf getHomePageCinemaList];

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
//取消手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)cancelMenuBG:(UIGestureRecognizer*)tap{
    tap.view.hidden = YES;
    _isselected = 0;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_movieTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];

}
//轮播图点击后的界面
- (void)pushToDetailPage:(BannerModel *)model{
    if ([model.type integerValue] == 0) {//0影片，1链接
        ChooseMovieController * vc = [[ChooseMovieController alloc]init];
        vc.filmCode = model.film_code;
        vc.filmName = model.film_name;
        vc.cityCode = @"350500";
        vc.coordinatex = self.coordinatex;
        vc.coordinatey = self.coordinatey;
        if (model.film_code == nil || model.film_name== nil ||self.coordinatex == nil || self.coordinatey == nil) {
            return;
        }
        if (self.otherTicketAry.count <= 0) {
            vc.isOtherTicket = 0;
        }else{
            vc.isOtherTicket = 1;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //链接到活动界面
        //    DetaliViewController * detaliVC = [[DetaliViewController alloc]init];
        //    detaliVC.markTag = tag;
        //    [self.navigationController pushViewController:detaliVC animated:YES];
    }
}
- (void)timer:(NSTimer*)timer{
    static int a = 0;
    
    hotScrollView.contentOffset = CGPointMake((a%self.hotMovieSAry.count)*kScreen_Width, 0);
    _page.currentPage = a%self.hotMovieSAry.count;//修改
    a++;
   
}
- (void)pageController:(UIPageControl*)page{
    hotScrollView.contentOffset = CGPointMake(_page.currentPage * kScreen_Width, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.movieTableView) {
        CGFloat yoffset=scrollView.contentOffset.y;
        if (yoffset<=0) {
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
        }
        if (yoffset<64) {
            
            CGFloat alpha=yoffset/64;
            
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
            
            
        }else if (yoffset>=64){
            
            //        self.navigationItem.title=@"";
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
            
        }else{
            
            [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
            
        }

    }else{
       _page.currentPage = scrollView.contentOffset.x/kScreen_Width;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 懒加载
- (UITableView *)movieTableView {
    
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        _movieTableView.backgroundColor = [UIColor whiteColor];

    }
    return _movieTableView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIView * nameView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 5)];
        nameView1.backgroundColor = RGBCOLOR(245, 246, 247, 1);
        [_headerView addSubview:nameView1];
        UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kScreen_Width, 35)];
        [_headerView addSubview:nameView];
        
        UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 150, 35)];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLable.text = @"推荐影院";
        [nameView addSubview:titleLable];
        
        UIButton * allCinemaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allCinemaBtn.frame = CGRectMake(kScreen_Width - 13- 70, 0, 70, 35);
        [allCinemaBtn setTitle:@"全部 >" forState:UIControlStateNormal];
        [allCinemaBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [allCinemaBtn addTarget:self action:@selector(searchMovie) forControlEvents:UIControlEventTouchUpInside];
        allCinemaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [nameView addSubview:allCinemaBtn];

        
        UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 6, 25)];
        blueView.backgroundColor = CNaviColor;
        [nameView addSubview:blueView];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 34.5, kScreen_Width, 0.5)];
        line3.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [nameView addSubview:line3];
        
        
        btnView12 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreen_Width, 40)];
        
        
        [_headerView addSubview:btnView12];
        NSArray * titleAry = @[@"全部地区",@"离我最近"];
        CGFloat btnWidth = (kScreen_Width-6)/2;
        for (int i = 0; i<2; i++) {
            UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.frame = CGRectMake((btnWidth+3)*i, 0 ,btnWidth , 40);
            selectBtn.tag = 1111 + i;
            selectBtn.backgroundColor = [UIColor whiteColor];
            [selectBtn setTitle:titleAry[i] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
            [selectBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [selectBtn addTarget:self action:@selector(menuBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
            
            
            if (_isselected == 0) {
                selectBtn.selected = NO;
            }
            [btnView12 addSubview:selectBtn];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(selectBtn.right+1, 0, 1, 10)];
            line.centerY = selectBtn.centerY;
            line.backgroundColor = RGBCOLOR(234, 234, 234, 1);
            [btnView12 addSubview:line];
            if (i == 1) {
                line.hidden = YES;
            }
        }

    }
    return _headerView;
}
- (NSMutableArray *)theaterNameAry{
    
    if (!_theaterNameAry) {
        _theaterNameAry = [NSMutableArray array];
    }
    return _theaterNameAry;
}
- (NSMutableArray*)hotMovieSAry{
    if (!_hotMovieSAry) {
        _hotMovieSAry = [NSMutableArray array];
    }
    return _hotMovieSAry;
}

- (NSMutableArray*)hotCollectDataAry{
    if (!_hotCollectDataAry) {
        _hotCollectDataAry = [NSMutableArray array];
    }
    return _hotCollectDataAry;
}

- (NSMutableArray*)otherTicketAry{
    if (!_otherTicketAry) {
        _otherTicketAry = [NSMutableArray array];
    }
    return _otherTicketAry;
}
- (NSMutableArray*)cityCodeAry{
    if (!_cityCodeAry) {
        _cityCodeAry = [NSMutableArray array];
    }
    return _cityCodeAry;
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
 area = 350521,
	pages = 1,
	device_id = 5954E10B-F1B3-4D48-998F-8CD5AD59336B,
	typeList = 1,
	pagen = 10,
	coordinatey = 24.774296,
	toke = 80d3751499f752d2d804a8dbdbc7bbf3,
	type = 0,
	coordinatex = 118.485703,
	user_id = 134
*/

@end
