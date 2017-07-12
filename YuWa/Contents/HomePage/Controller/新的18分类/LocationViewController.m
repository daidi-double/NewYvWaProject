//
//  LocationViewController.m
//  YuWa
//
//  Created by double on 17/2/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "LocationViewController.h"
#import "MapAnnotation.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationDegrees lati;
    CLLocationDegrees longti;
}
@property (nonatomic,strong)CLLocationManager * manager;
@property (nonatomic,strong)MKMapView * mapView;
@property (nonatomic,strong)CLGeocoder *geocoder;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longtude;
@end

@implementation LocationViewController
- (CLLocationManager*)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        if ([[UIDevice currentDevice].systemVersion integerValue]>= 8.0) {
            [_manager requestAlwaysAuthorization];
            _manager.delegate = self;
            
        }
        [self.manager startUpdatingLocation];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self makeMap];
    _geocoder = [[CLGeocoder alloc]init];
    [self.view addSubview:backBtn];
    [self locationMyPlace];
}
- (void)locationMyPlace{
    UIButton * locationMyPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    locationMyPlace.frame = CGRectMake(10, self.view.height * 0.9f, 30, 30);
    [locationMyPlace setImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
    [locationMyPlace addTarget:self action:@selector(MyPlace) forControlEvents:UIControlEventTouchUpInside];
    locationMyPlace.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:locationMyPlace];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)makeMap{
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.mapType = 0;
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(24.78756, 118.55827);
    MapAnnotation *map = [[MapAnnotation alloc]init];
    map.coordinate = coordinate;
    map.title = @"影院";
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)];
    [_mapView addAnnotation:map];
//    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
//    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,115.404));
//    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    MKPinAnnotationView * piview = (MKPinAnnotationView *)[views objectAtIndex:0];
    [self.mapView selectAnnotation:piview.annotation animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"用户关闭";
            // 定位不可用 —— 传虚拟经纬度
            lati = 0.000000;
            longti = 0.000000;
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"位置数据不可用";
            //Do something else...
            break;
        default:
            errorString = @"未知错误";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)MyPlace{
    [self manager];
    
    _mapView.showsUserLocation = YES;
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
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
