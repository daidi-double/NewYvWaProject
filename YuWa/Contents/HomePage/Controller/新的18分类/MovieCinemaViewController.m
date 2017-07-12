//
//  MovieCinemaViewController.m
//  YuWa
//
//  Created by double on 2017/2/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MovieCinemaViewController.h"
#import "CinemaDetaliController.h"
#import "FoodViewController.h"
#import "MoviePScrollView.h"
#import "PlayTimeShowTableViewCell.h"
#import "CinemaHeaderView.h"//影院的头部视图
#import "ChooseSeatController.h"//选座
#import "SeeMovieCell.h"
#import "ShopDetaliViewController.h"
//#import "LocationViewController.h"
#import "MapNavNewViewController.h"
#import "YWLoginViewController.h"

#import "CinemaHeaderModel.h"//头部影院信息
#import "FilmListModel.h"//滑动电影信息
#import "FilmShowTimeModel.h"//影院上映的场次

#import "OtherTicketModel.h"//通兑票model
#import "OtherTicketViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#define PLAYSHOWCELL  @"PlayTimeShowTableViewCell"
@interface MovieCinemaViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CinemaHeaderViewDelegate>
{
    UIView * lineView;
    UIView * bgView;
}

@property (nonatomic,strong)UITableView * movieTableView;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,strong)UIView * btnTimeView;
@property (nonatomic,strong) CinemaHeaderModel * headerModel;
@property (nonatomic,strong) NSMutableArray * filmListAry;//滑动部分电影数据
@property (nonatomic,strong) NSMutableArray * filmShowAry;//播放场次电影
@property (nonatomic,strong)CLGeocoder * geocoder;
@property (nonatomic,assign) NSInteger index;//标记滚动部分是哪部电影
@property (nonatomic,strong)NSMutableArray * otherTicketAry;//通兑票数组
@property (nonatomic,assign)NSInteger Num;//记录当前选择的电影位于第几个
@end

@implementation MovieCinemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.filmName;
    self.index = 0;
    [self requestHeaderData];
    
    [self.view addSubview:self.movieTableView];
    
}


#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.filmShowAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.status == 1) {
        
        if (section == 0) {

            return kScreen_Height *850/1334.f;
            
        }else{
            return 100.f;
        }
    }else{
        if (section == 0) {

            return kScreen_Height *850/1334.f;
            
        }else{
            return 44.f;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0.01f;
    }else{
        return 55.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.headerModel != nil) {
            
            CinemaHeaderView * headerBGview = [[CinemaHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*0.5f)];
            headerBGview.cinema_code = self.cinema_code;
            headerBGview.movies = self.filmListAry;
            headerBGview.num = self.Num;
            headerBGview.model = self.headerModel;
            headerBGview.delegate =self;
            
            return headerBGview;
        }else{
            return nil;
        }
    }else{

        if (self.filmName != nil) {
            //从热映电影点击进来的
            for (FilmListModel * model in self.filmListAry) {
                if ([self.film_code isEqualToString:model.code]) {
                    NSArray * date = [model.allDate componentsSeparatedByString:@","];
                    if (date.count>0) {
                        
                        for (UIButton * dateBtn in self.btnTimeView.subviews) {
                            if (dateBtn.tag>=1) {
                              
                                if (dateBtn.tag<=date.count) {
                                     dateBtn.hidden = NO;
                                    [dateBtn setTitle:date[dateBtn.tag-1] forState:UIControlStateNormal];
                                    if ([dateBtn.titleLabel.text isEqualToString:@""]||dateBtn.titleLabel.text == nil) {
                                        [dateBtn setUserInteractionEnabled:NO];
                                    }else{
                                        [dateBtn setUserInteractionEnabled:YES];
                                    }
                                }else{
                                    dateBtn.hidden = YES;
                                }
                            }
                        }
                    }else{
                        
                        self.time = @"";
                    }
                    
                }
            }
        }else{
            //            还未选择电影，即从影院数据进来的
            FilmListModel * model;
            if (self.filmListAry.count >0) {
                
                model= self.filmListAry[_index];
            }
            NSArray * dateAry = [model.allDate componentsSeparatedByString:@","];
            if (dateAry.count>0) {
                
                for (UIButton * dateBtn in self.btnTimeView.subviews) {
                    if (dateBtn.tag>=1) {
                        
                        if (dateBtn.tag<=dateAry.count) {
                            [dateBtn setTitle:dateAry[dateBtn.tag-1] forState:UIControlStateNormal];
                            if ([dateBtn.titleLabel.text isEqualToString:@""]||dateBtn.titleLabel.text == nil) {
                                [dateBtn setUserInteractionEnabled:NO];
                            }else{
                                [dateBtn setUserInteractionEnabled:YES];
                            }
                        }
                    }
                }
            }
            
            
            
        }

        if (self.filmShowAry.count <=0) {
            lineView.hidden = YES;

        }else{
            lineView.hidden = NO;

        }
        return self.btnTimeView;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        FilmShowTimeModel * showModel = self.filmShowAry[indexPath.row];
        ChooseSeatController * chooseSeat = [[ChooseSeatController alloc]init];
        chooseSeat.channelshowcode = showModel.channelshowcode;
        chooseSeat.hall_name = showModel.hall_name;
        chooseSeat.headerModel = showModel;
        chooseSeat.cinemaName = self.headerModel.cinema_name;
        chooseSeat.cinemaCode = self.cinema_code;
        FilmListModel * model = self.filmListAry[_index];
        if (self.filmName == nil) {
            self.filmName = model.name;
        }
        chooseSeat.filmName = self.filmName;
        MyLog(@"渠道编码2 = %@",showModel.channelshowcode);//1710490158461
        [self.navigationController pushViewController:chooseSeat animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"movieTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieTableViewCell"];
    }
    if (indexPath.section == 1){
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        
        PlayTimeShowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PLAYSHOWCELL];
        cell.accessoryType = UITableViewCellAccessoryNone;
        FilmShowTimeModel * showModel = self.filmShowAry[indexPath.row];
        cell.model = showModel;
        _buy_ticket = [cell viewWithTag:100];
        _buy_ticket.layer.cornerRadius = 5;
        _buy_ticket.layer.borderColor = CNaviColor.CGColor;
        _buy_ticket.layer.borderWidth = 1;
        _buy_ticket.layer.masksToBounds = YES;
        [_buy_ticket addTarget:self action:@selector(goToBuyTicket:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return cell;
}
- (void)chooseDate:(UIButton*)sender{
    FilmListModel * filmModel;
    if (self.filmName != nil) {
        filmModel = self.filmListAry[self.Num];
        
    }else{
        filmModel = self.filmListAry[self.index];
    }
    NSArray * date = [filmModel.allDate componentsSeparatedByString:@","];
    if (date.count < sender.tag) {
        return;
    }
    lineView.centerX = sender.centerX;
    self.time = date[sender.tag-1];
    [self requestFootData];
}

- (void)goToBuyTicket:(UIButton *)sender{
    if ([self judgeLogin]) {
        PlayTimeShowTableViewCell * cell = (PlayTimeShowTableViewCell*)[[sender superview]superview];
        NSIndexPath * path = [self.movieTableView indexPathForCell:cell];
        ChooseSeatController * chooseVC = [[ChooseSeatController alloc]init];
        FilmListModel * model = self.filmListAry[_index];
        if (self.filmName == nil) {
            self.filmName = model.name;
        }
        chooseVC.filmName = self.filmName;
        chooseVC.cinemaName = self.headerModel.cinema_name;
        chooseVC.cinemaCode = self.cinema_code;
        chooseVC.headerModel = self.filmShowAry[path.row];
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    
}
- (void)ToCinemaDetaliPage{
    CinemaDetaliController * detaliVC = [[CinemaDetaliController alloc]init];
    detaliVC.cinemaCode = self.cinema_code;
    [self.navigationController pushViewController:detaliVC animated:YES];
    
}
- (void)ToFoodPage{
    FoodViewController * foodVC = [[FoodViewController alloc]init];
    [self.navigationController pushViewController:foodVC animated:YES];
}
- (void)ToLocation{
    
    MapNavNewViewController * locationVC = [[MapNavNewViewController alloc]init];
    locationVC.coordinatex = self.headerModel.longitude;
    locationVC.coordinatey = self.headerModel.latitude;
    locationVC.shopName = self.headerModel.cinema_name;
    [self.navigationController pushViewController:locationVC animated:YES];
    
}
- (void)callIphone:(NSString *)iphoneStr{
    NSArray * iphoneAry;
    UIAlertAction * tel;
    UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"拨打影院电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if ([iphoneStr containsString:@" "]) {
        iphoneAry = [iphoneStr componentsSeparatedByString:@" "];
        tel = [UIAlertAction actionWithTitle:iphoneAry[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * allString = [NSString stringWithFormat:@"tel:%@",iphoneAry[0]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            
        }];
        UIAlertAction* tel2 = [UIAlertAction actionWithTitle:iphoneAry[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * allString = [NSString stringWithFormat:@"tel:%@",iphoneAry[1]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            
        }];
        
        [alerVC addAction:tel];
        [alerVC addAction:tel2];
        [alerVC addAction:cancel];

    }else{
        
        tel = [UIAlertAction actionWithTitle:iphoneStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
             NSString * allString = [NSString stringWithFormat:@"tel:%@",iphoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            
        }];
        [alerVC addAction:tel];
        [alerVC addAction:cancel];
        
    }
    [self.navigationController presentViewController:alerVC animated:YES completion:nil];
    
}
- (void)filmName:(NSString *)filmName andIndex:(NSInteger)index andfilmCode:(NSString *)filmCode andPlayDate:(NSString *)playDate{
    self.filmName = filmName;
    self.index = index;
    self.Num = index;
    self.title = filmName;
    self.film_code = filmCode;
    self.time= playDate;
    [self requestFootData];
}

- (BOOL)judgeLogin{
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    return [UserSession instance].isLogin;
}
#pragma mark -- http
//头部视图数据
- (void)requestHeaderData{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAHEADER];
    
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinema_code":self.cinema_code};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }

    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"影院头部%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            self.headerModel = [CinemaHeaderModel yy_modelWithDictionary:data[@"data"][@"cinemaInfo"]];
            
            //            滑动部分的电影
            [self.filmListAry removeAllObjects];
            NSArray * ary = data[@"data"][@"filmList"];
            if (![ary isKindOfClass:[NSNull class]]) {
                
                for (int i = 0; i <ary.count; i ++ ) {
                    
                    FilmListModel * filmModel = [FilmListModel yy_modelWithDictionary:ary[i]];
                    [self.filmListAry addObject:filmModel];
                    
                    if (self.film_code == nil) {
                        if (i == 0) {
                            self.film_code = filmModel.code;
                            self.Num = 0;
                            NSArray * date = [filmModel.allDate componentsSeparatedByString:@","];
                            if (date.count>0) {
                                
                                self.time = date[0];
                            }else{
                                self.time = @"";
                            }
                            [self requestFootData];
                        }
                    }else if ([self.film_code isEqualToString:filmModel.code]) {
                        self.Num = i;
                        self.film_code = filmModel.code;
                        NSArray * date = [filmModel.allDate componentsSeparatedByString:@","];
                        if (date.count>0) {
                            
                            self.time = date[0];
                        }else{
                            self.time = @"";
                        }
                        [self requestFootData];
                    }
                }
            }
            
            
            [self.movieTableView reloadData];
        }else{
            [JRToast showWithText:@"网络错误，请检查网络" duration:1];
        }
    }];
    
}

- (void)requestFootData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CINEMAFOOT];
    
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"cinema_code":self.cinema_code,@"film_code":self.film_code,@"time":self.time};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([self judgeLogin]) {
        
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
        [dic setValue:[UserSession instance].token forKey:@"token"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"电影场次%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            
            [self.filmShowAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                
                FilmShowTimeModel * showModel = [FilmShowTimeModel yy_modelWithDictionary:dict];
                
                [self.filmShowAry addObject:showModel];
            }
            
            
            [self.movieTableView reloadData];
        }else{
            [JRToast showWithText:@"网络错误，请检查网络" duration:1];
        }
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [self.movieTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
}

-(UIView*)btnTimeView{
    
    NSArray * arr = @[@"",@"",@""];
    if (self.status == 1) {
        if (!_btnTimeView) {
            _btnTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
            
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
            line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
            [_btnTimeView addSubview:line];
            UIView * blakView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, kScreen_Width, 10)];
            blakView.backgroundColor = RGBCOLOR(234, 235, 236, 1);
            [_btnTimeView addSubview:blakView];
            for (int j = 0; j<3; j++) {
                UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                dateBtn.frame = CGRectMake(10 + (kScreen_Width/3-3)*j, 56, kScreen_Width/3-3, _btnTimeView.height - 56);
                dateBtn.tag = j +1;
                [dateBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
                [_btnTimeView addSubview:dateBtn];
                dateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [dateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                [dateBtn setTitle:arr[j] forState:UIControlStateNormal];

                
            }
            lineView = [[UIView alloc]initWithFrame:CGRectMake(5, _btnTimeView.height-1, kScreen_Width/3, 1)];
            lineView.backgroundColor = CNaviColor;
            [_btnTimeView addSubview:lineView];
            bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 55.5)];

            [_btnTimeView addSubview:bgView];
            UIImageView * picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 35.5, 35.5)];
            picImageView.image = [UIImage imageNamed:@"otherticketpic"];
            [bgView addSubview:picImageView];
            
            UILabel * otherTicketLabel = [[UILabel alloc]initWithFrame:CGRectMake(picImageView.right + 20, 0, kScreen_Width * 0.7f, 30)];
            otherTicketLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            otherTicketLabel.centerY = picImageView.centerY;
            otherTicketLabel.font = [UIFont systemFontOfSize:13];
            otherTicketLabel.text = @"可观看2D,3D,免预约,可升级";
            [bgView addSubview:otherTicketLabel];
            
            UIImageView * picImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 30, 25, 8, 15)];
            picImageView2.centerY = otherTicketLabel.centerY;
            picImageView2.image = [UIImage imageNamed:@"common_icon_arrow"];
            [bgView addSubview:picImageView2];
            UITapGestureRecognizer * otherTicketTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toOtherTicker)];
            otherTicketTap.delegate = self;
            otherTicketTap.numberOfTapsRequired = 1;
            otherTicketTap.numberOfTouchesRequired = 1;
            [bgView addGestureRecognizer:otherTicketTap];
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, picImageView.bottom+10, kScreen_Width, 0.5)];
            line3.backgroundColor = RGBCOLOR(240, 240, 240, 1);
            [_btnTimeView addSubview:line3];
        }
        return _btnTimeView;
    }else{
        if (!_btnTimeView) {
            _btnTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
            
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
            line.backgroundColor = RGBCOLOR(240, 240, 240, 1);
            [_btnTimeView addSubview:line];
            
            
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _btnTimeView.height-2, kScreen_Width/3, 2)];
            lineView.backgroundColor = CNaviColor;
            [_btnTimeView addSubview:lineView];
            UIView * blakView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, kScreen_Width, 10)];
            blakView.backgroundColor = RGBCOLOR(234, 235, 236, 1);
            [_btnTimeView addSubview:blakView];
            for (int j = 0; j<3; j++) {
                UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                dateBtn.frame = CGRectMake(10 + (kScreen_Width/3-3)*j, 1, kScreen_Width/3-3, _btnTimeView.height);
                dateBtn.tag = j +1;
                [dateBtn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
                [_btnTimeView addSubview:dateBtn];
                dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [dateBtn setTitle:arr[j] forState:UIControlStateNormal];
             
            }
        }
        return _btnTimeView;
    }
    
}

#pragma mark  -- 得到地理位置
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}
-(void)toOtherTicker{
    //通兑票
    OtherTicketViewController * VC = [[OtherTicketViewController alloc]init];
    VC.cinema_code = self.cinema_code;
    VC.cityCode = self.cityCode;
    [self.navigationController pushViewController:VC animated:YES];
}

- (UITableView*)movieTableView{
    if (!_movieTableView) {
        _movieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _movieTableView.backgroundColor = [UIColor whiteColor];
        _movieTableView.delegate = self;
        _movieTableView.dataSource = self;
        
        [_movieTableView registerNib:[UINib nibWithNibName:PLAYSHOWCELL bundle:nil] forCellReuseIdentifier:PLAYSHOWCELL];
    }
    return _movieTableView;
}
- (NSMutableArray*)filmListAry{
    if (!_filmListAry) {
        _filmListAry = [NSMutableArray array];
    }
    return _filmListAry;
}

- (NSMutableArray*)filmShowAry{
    if (!_filmShowAry ) {
        _filmShowAry = [NSMutableArray array];
    }
    return _filmShowAry;
}
- (NSMutableArray*)otherTicketAry{
    if (!_otherTicketAry) {
        _otherTicketAry = [NSMutableArray array];
    }
    return _otherTicketAry;
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
//- (void)getLocalSubName{
//    CLLocation * location = [[CLLocation alloc]initWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
//    [self.geocoder reverseGeocodeLocation: location completionHandler:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            if (placemark != nil) {
//                NSString *city = placemark.locality;
//
//                NSLog(@"当前城市名称------%@",city);
////
////                BMKOfflineMap * _offlineMap = [[BMKOfflineMap alloc] init];
////
////                NSArray* records = [_offlineMap searchCity:city];
////                BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
////                //城市编码如:北京为131
////                NSInteger cityId = oneRecord.cityID;
////
////                NSLog(@"当前城市编号-------->%zd",cityId);
////                //找到了当前位置城市后就关闭服务
////                [_locService stopUserLocationService];
//
//            }
//        }
//    }];
//
//
//
//
//}

/**当获取到定位的坐标后，回调函数*/
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//
//    BMKCoordinateRegion region;
//
//    region.center.latitude  = userLocation.location.coordinate.latitude;
//    region.center.longitude = userLocation.location.coordinate.longitude;
//    region.span.latitudeDelta = 0;
//    region.span.longitudeDelta = 0;
//    NSLog(@"当前的坐标是:%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            if (placemark != nil) {
//                NSString *city = placemark.locality;
//
//                NSLog(@"当前城市名称------%@",city);
//                BMKOfflineMap * _offlineMap = [[BMKOfflineMap alloc] init];
//                _offlineMap.delegate = self;//可以不要
//                NSArray* records = [_offlineMap searchCity:city];
//                BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
//                //城市编码如:北京为131
//                NSInteger cityId = oneRecord.cityID;
//
//                NSLog(@"当前城市编号-------->%zd",cityId);
//                //找到了当前位置城市后就关闭服务
//                [_locService stopUserLocationService];
//
//            }
//        }
//    }];
//
//}

/*
 
 NSDate *date = [NSDate date];
 
 NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 
 NSInteger unitFlags =  kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
 comps = [calendar components:unitFlags fromDate:date];
 
 NSInteger month = [comps month];
 NSInteger day = [comps day];
 NSInteger year = [comps year];
 NSString *btnTitle =[NSString stringWithFormat:@"今天%ld月%ld日",(long)month,(long)day];
 NSString * btnTitleT;
 NSString * btnAfterTitle;
 if (month == 1|month ==3|month ==5|month ==7|month ==8|month ==10|month ==12) {
 if (day == 30) {
 btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
 btnAfterTitle = [NSString stringWithFormat:@"后天%ld月1日",(long)month+1];
 
 }
 if (day == 31) {
 btnTitleT = [NSString stringWithFormat:@"明天%ld月1日",(long)month+1];
 btnAfterTitle = [NSString stringWithFormat:@"后天%ld月2日",(long)month+1];
 if (month == 12) {
 btnTitleT = @"明天1月1日";
 btnAfterTitle = @"后天1月2日";
 }
 }else{
 btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
 btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
 }
 
 }else if (year%4 ==0 && month == 2 && day == 29){
 btnTitleT = @"明天3月1日";
 btnAfterTitle = @"后天3月2日";
 }else if (year%4 != 0 && month == 2 && day == 28){
 btnTitleT = @"明天3月1日";
 btnAfterTitle = @"后天3月2日";
 }else if (month == 4|month ==6|month ==9|month ==10|month ==11){
 if (day == 29) {
 btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
 btnAfterTitle = [NSString stringWithFormat:@"后天%ld月1日",(long)month+1];
 
 }else if (day == 30) {
 btnTitleT = [NSString stringWithFormat:@"明天%ld月1日",(long)month+1];
 btnAfterTitle = [NSString stringWithFormat:@"后天%ld月2日",(long)month+1];
 }else{
 
 btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
 btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
 }
 
 }else{
 
 btnTitleT = [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day+1];
 btnAfterTitle = [NSString stringWithFormat:@"明日%ld月%ld日",(long)month,(long)day+2];
 }
 
 
 */
@end
