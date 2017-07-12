//
//  MapNavNewViewController.m
//  YuWa
//
//  Created by double on 17/3/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MapNavNewViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MyAnnotation.h"
#import "CustomAnnotationView.h"
#import <MapKit/MapKit.h>
@interface MapNavNewViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
{
    CLGeocoder * geCoder;
    NSInteger _seleIndex;
}
@property (nonatomic,strong)MAMapView * mapView;
@property (nonatomic,strong)AMapLocationManager * locationManager;
//@property (strong ,nonatomic)AMapNaviDriveView *driveView;       //导航界面
//@property (strong ,nonatomic)AMapNaviDriveManager *driveManager; //导航管理者
@property (nonatomic,strong)MAPointAnnotation * pointAnnotation;//定位商家的位置标志
@property (nonatomic, strong)CustomAnnotationView *annotationView;//纯自定义大头针标注视图
//@property (nonatomic,assign)CLLocationCoordinate2D myLocation;

@end

@implementation MapNavNewViewController
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        
    }
    return _locationManager;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self createPointAnnotion];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopName;
    [[AMapServices sharedServices] setApiKey:@"2a060bc2d45564b6d36c8fee826f35a5"];
    [[AMapServices sharedServices]setEnableHTTPS:YES];
    [self initMapView];
    _seleIndex = 0;
    
}
- (void)initMapView{
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate = self;
    
    //配置属性
    _mapView.showsLabels = YES;//显示底部标图
    _mapView.showsScale  = YES; //显示比例尺
    _mapView.showTraffic = YES;//显示交通
    _mapView.showsCompass= YES;//显示指南针
    _mapView.zoomEnabled = YES;//开启缩放手势
    _mapView.scrollEnabled = YES;//开启滑动手势
    [self.view addSubview:_mapView];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.locationManager setDistanceFilter:10];
    
    //定位超时时间，最低2s，此处设置为2s
    [self.locationManager setLocationTimeout:6];
    
    //逆地理请求超时时间，最低2s，此处设置为2s
    [self.locationManager setReGeocodeTimeout:3];
    
    
    [self.locationManager startUpdatingLocation];



    UIButton * navBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    navBtn.frame = CGRectMake(10, kScreen_Height- 50, kScreen_Width-40, 40);
    navBtn.centerX = kScreen_Width/2;
    navBtn.layer.masksToBounds = YES;
    navBtn.layer.cornerRadius = 5;
    [navBtn setTitle:@"开始导航" forState:UIControlStateNormal];
    [navBtn setBackgroundColor:CNaviColor];
    [navBtn addTarget:self action:@selector(beginNav) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBtn];
  
    
}
- (void)createPointAnnotion{
    self.pointAnnotation = [[MAPointAnnotation alloc]init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.coordinatey doubleValue], [self.coordinatex doubleValue]);
    [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
    [_mapView addAnnotation:self.pointAnnotation];
}
//获取标志视图
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        return [self fullCustomAnnotationViewWithMapView:mapView viewForAnnotation:annotation];
    }
    return nil;
}

- (CustomAnnotationView *)fullCustomAnnotationViewWithMapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    static NSString *reuseIndetifier = @"annotationReuseIndetifier";
    _annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
    if (_annotationView == nil)
    {
        _annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
    }
    [_annotationView.annotation setTitle:self.shopName];
    _annotationView.shopName = self.shopName;
    _annotationView.image = [UIImage imageNamed:@"icon_location"];
    
    //设置为NO，用以调用自定义的calloutView
    _annotationView.canShowCallout = NO;
    
    //设置中心点偏移，使得标注底部中间点成为经纬度对应点
    _annotationView.centerOffset = CGPointMake(0, -18);
    
    return _annotationView;
}

- (void)beginNav{
    UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"请选择您要使用的导航地图" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"高德地图",@"系统地图",nil];
    [aler show];
    aler.tag = 1213;
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    MyLog(@"buttonIndex%ld",buttonIndex);
    if (alertView.tag == 1213) {
        switch (buttonIndex) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
//                [self onDaoHangForBaiDuMap];
                 [self onDaoHangForGaoDeMap];
            }
                break;
            case 2:
            {
                [self onDaoHangForIOSMap];
            }
                break;
            case 3:
            {
               
            }
                break;
                
            default:
                break;
        }
    }
}
//    [self initDriveView];
//    [self initDriveManager];
//}

//#pragma mark ------------------------------ 导航 - 百度
//-(void) onDaoHangForBaiDuMap
//{
//    
//    //    mode  导航模式，固定为transit、driving、walking，分别表示公交、驾车和步行
//    NSString * modeBaiDu = @"driving";
//    switch (_seleIndex) {
//        case 1:
//        {
//            modeBaiDu = @"transit";
//        }
//            break;
//        case 2:
//        {
//            modeBaiDu = @"driving";
//        }
//            break;
//        case 3:
//        {
//            modeBaiDu = @"walking";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%f,%f&mode=%@&src=公司|APP",[ shareSingleObject].currentCoordinate.latitude,[SingleObject shareSingleObject].currentCoordinate.longitude,self.location.latitude,self.location.longitude,modeBaiDu] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
//    
//    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    
//    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])// -- 使用 canOpenURL:[NSURL URLWithString:@"baidumap://"] 判断不明白为什么为否。
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }else{
//        [[[UIAlertView alloc]initWithTitle:@"没有安装百度地图" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil nil] show];
//    }
//    
//}
#pragma mark ------------------------------ 导航 - 高德
-(void) onDaoHangForGaoDeMap
{
    //    m 驾车：0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵 公交：0：最快捷，2：最少换乘，3：最少步行，5：不乘地铁 ，7：只坐地铁 ，8：时间短  是
    //    t = 0：驾车 =1：公交 =2：步行
    
    NSString * t = @"0";
    switch (_seleIndex) {
        case 1:
        {
            t = @"1";
        }
            break;
        case 2:
        {
            t = @"0";
        }
            break;
        case 3:
        {
            t = @"2";
        }
            break;
            
        default:
            break;
    }
    //起点
//    CLLocation * location = [[CLLocation alloc]initWithLatitude:[SingleObject shareSingleObject].currentCoordinate.latitude longitude:[SingleObject shareSingleObject].currentCoordinate.longitude];
    
//    location = [location locationMarsFromBaidu];
    
//    CLLocationCoordinate2D coor =location.coordinate;
    CLLocationCoordinate2D coor = _myLocation.coordinate;
    
    //目的地的位置
    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:[self.coordinatey doubleValue] longitude:[self.coordinatex doubleValue]];
//    location2 = [location2 locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor2 =location2.coordinate;
    //    导航 URL：iosamap://navi?sourceApplication=%@&poiname=%@&lat=%lf&lon=%lf&dev=0&style=0",@"APP"
    //    路径规划 URL：iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=A&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=0
    // -- 不能直接让用户进入导航，应该给用户更多的选择，所以先进行路径规划
    
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=雨娃宝&backScheme=backschemes&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",coor.latitude,coor.longitude, coor2.latitude,coor2.longitude,self.shopName,t]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString* url = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=雨娃宝&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",]
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"没有安装高德地图" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil] show];
    }
    
    
}
#pragma mark ------------------------------ 导航 - iosMap
-(void) onDaoHangForIOSMap
{
//    //起点
//    CLLocation * location = [[CLLocation alloc]initWithLatitude:[SingleObject shareSingleObject].currentCoordinate.latitude longitude:[SingleObject shareSingleObject].currentCoordinate.longitude];
//    location = [location locationMarsFromBaidu];
    CLLocationCoordinate2D coor = _myLocation.coordinate;
    
//    CLLocationCoordinate2D coor =location.coordinate;
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:coor  addressDictionary:nil]];
    currentLocation.name =@"我的位置";
    
    //目的地的位置
    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:[self.coordinatey doubleValue] longitude:[self.coordinatex doubleValue]];
//    location2 = [location2 locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor2 =location2.coordinate;
    //    CLLocationCoordinate2D coords = self.location;
    
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor2 addressDictionary:nil]];
    
    toLocation.name = self.shopName;
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    switch (_seleIndex) {
        case 1:
        {
            mode = MKLaunchOptionsDirectionsModeTransit;
        }
            break;
        case 2:
        {
            mode = MKLaunchOptionsDirectionsModeDriving;
        }
            break;
        case 3:
        {
            mode = MKLaunchOptionsDirectionsModeWalking;
        }
            break;
            
        default:
            break;
    }
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
//-(IBAction)onClickBusSearch
//{
//    _seleIndex = 1;
//    CLLocationCoordinate2D coor;
//    coor.latitude = [SingleObject shareSingleObject].currentCoordinate.latitude;
//    coor.longitude = [SingleObject shareSingleObject].currentCoordinate.longitude;
//    
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    start.pt = coor;
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.pt = self.location;
//    
//    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
//    transitRouteSearchOption.city= [SingleObject shareSingleObject].selectedCityObject.cityName;
//    transitRouteSearchOption.from = start;
//    transitRouteSearchOption.to = end;
//    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
//    
//    if(flag)
//    {
//        NSLog(@"bus检索发送成功");
//    }
//    else
//    {
//        NSLog(@"bus检索发送失败");
//    }
//}
//
////-(IBAction)textFiledReturnEditing:(id)sender {
////    [sender resignFirstResponder];
////}
//#pragma mark ------------------------------ 自驾
//-(IBAction)onClickDriveSearch
//{
//    _seleIndex = 2;
//    CLLocationCoordinate2D coor;
//    coor.latitude = [SingleObject shareSingleObject].currentCoordinate.latitude;
//    coor.longitude = [SingleObject shareSingleObject].currentCoordinate.longitude;
//    
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    
//    start.pt = coor;
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.pt = self.location;
//    
//    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
//    drivingRouteSearchOption.from = start;
//    drivingRouteSearchOption.to = end;
//    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
//    if(flag)
//    {
//        NSLog(@"car检索发送成功");
//    }
//    else
//    {
//        NSLog(@"car检索发送失败");
//    }
//    
//}
//#pragma mark ------------------------------ 步行
//-(IBAction)onClickWalkSearch
//{
//    _seleIndex = 3;
//    CLLocationCoordinate2D coor;
//    coor.latitude = [SingleObject shareSingleObject].currentCoordinate.latitude;
//    coor.longitude = [SingleObject shareSingleObject].currentCoordinate.longitude;
//    
//    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    
//    start.pt = coor;
//    BMKPlanNode* end = [[BMKPlanNode alloc]init];
//    end.pt = self.location;
//    
//    
//    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
//    walkingRouteSearchOption.from = start;
//    walkingRouteSearchOption.to = end;
//    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
//    if(flag)
//    {
//        NSLog(@"walk检索发送成功");
//    }
//    else
//    {
//        NSLog(@"walk检索发送失败");
//    }
//    
//}


//- (void)initDriveView
//{
//    if (!self.driveView){
//        //初始化导航界面
//        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,kScreen_Height-94)];
//        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        
//        //可以将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
//        [self.driveView setShowUIElements:YES];
//        [self.driveView setDelegate:self];
//        
//        //显示交通状况、箭头、指南针、摄像头(这些全部都可以自定义)
//        [self.driveView setShowTrafficLayer:YES];
//        [self.driveView setShowTurnArrow:YES];
//        [self.driveView setShowCompass:YES];
//        [self.driveView setShowCamera:YES];
//        
//        
//        //自定义实时交通路线Polyline的样式
//        [self.driveView setLineWidth:8];
//        //设置自定义的Car图标和CarCompass图标
//        [self.driveView setCarImage:[UIImage imageNamed:@"icon_location"]];
//        
//        
//        
//        //改变地图的追踪模式
//        if (self.driveView.trackingMode == AMapNaviViewTrackingModeCarNorth)
//        {
//            self.driveView.trackingMode = AMapNaviViewTrackingModeMapNorth;//地图指北
//        }
//        else if (self.driveView.trackingMode == AMapNaviViewTrackingModeMapNorth)
//        {
//            self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;//车头指北
//        }
//        
//        [self.view addSubview:self.driveView];
//    }
//    UIButton * navBtn= [UIButton buttonWithType:UIButtonTypeCustom];
//    navBtn.frame = CGRectMake(10, kScreen_Height- 30, kScreen_Width/4, 30);
//    [navBtn setTitle:@"结束导航" forState:UIControlStateNormal];
//    navBtn.centerX = kScreen_Width/2;
//    [navBtn addTarget:self action:@selector(endNav) forControlEvents:UIControlEventTouchUpInside];
//     [navBtn setBackgroundColor:CNaviColor];
//    [self.view addSubview:navBtn];
//    
//}
//- (void)endNav {
//    [self.driveManager stopNavi];
//}
//- (void)initDriveManager
//{
//    if (!self.driveManager){
//        
//        //初始化导航管理者
//        self.driveManager = [[AMapNaviDriveManager alloc] init];
//        [self.driveManager setDelegate:self];
//        
//        
//        //设置驾车出行路线规划
//        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:24.22 longitude:118.23];
//        AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:[self.coordinatey doubleValue] longitude:[self.coordinatex doubleValue]];
//        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:17];
//        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
//        [self.driveManager addDataRepresentative:self.driveView];
//    }
//}
//
//
//#pragma mark - AMapNaviDriveManagerDelegate
////驾车路径规划成功后的回调函数
//- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
//{
//    //算路成功后进行模拟导航
//    [self.driveManager startEmulatorNavi];
//    [self.driveManager setEmulatorNaviSpeed:80];
//}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    userLocation.title = @"我的位置";
    _myLocation = userLocation.location;
//    [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
// 
//
//    MACoordinateRegion region = MACoordinateRegionMake(userLocation.coordinate, MACoordinateSpanMake(0.000532, 0.000098));
//    [_mapView setRegion:region animated:YES];
//    

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
