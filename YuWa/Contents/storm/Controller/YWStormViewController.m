//
//  YWStormViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormViewController.h"
#import "YWStormSortTableView.h"
#import "YWStormPinAnnotationView.h"
//#import "YWStormSearchViewController.h"
#import "NewSearchViewController.h"        //搜索界面
#import "ShopDetailViewController.h"
#import "YWStormSubSortCollectionView.h"

#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define STORM_PINANNOTATION @"YWStormPinAnnotationView"
@interface YWStormViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *toMyLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (nonatomic,strong)YWStormSortTableView * sortTableView;
@property (nonatomic,strong)YWStormSubSortCollectionView * sortSubCollectionView;

@property (nonatomic,strong)CLGeocoder * geocoder;

@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger subType;
@property (nonatomic,assign)BOOL isSearch;//调用地图请求,仅自动一次

@end

@implementation YWStormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[AMapServices sharedServices] setApiKey:@"2a060bc2d45564b6d36c8fee826f35a5"];
//    [[AMapServices sharedServices]setEnableHTTPS:YES];
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.subType = 24;
    [self makeNavi];

    [self makeUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pleaseSetMap];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.sortTableView.hidden = YES;
    self.sortSubCollectionView.hidden = self.sortTableView.hidden;
    [self.navigationItem.rightBarButtonItem.customView setUserInteractionEnabled:YES];
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

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)makeNavi{
    self.navigationItem.title = @"商家";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImageName:@"search_Nav_white" withSelectImage:@"search_Nav_white" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:@"filtertBtn_normal_white" withSelectImage:@"filtertBtn_normal_white" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(sortAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
}

- (void)makeUI{
    self.searchBtn.layer.cornerRadius = 26.f;
    self.searchBtn.layer.masksToBounds = YES;
    self.locationBtn.layer.cornerRadius = 13.f;
    self.locationBtn.layer.masksToBounds = YES;
    self.toMyLocationBtn.layer.cornerRadius = 5.f;
    self.toMyLocationBtn.layer.borderColor = CNaviColor.CGColor;
    self.toMyLocationBtn.layer.borderWidth = 1.f;
    self.toMyLocationBtn.layer.masksToBounds = YES;
    
    WEAKSELF;
    
    //设置地图的默认显示区域
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.location.coordinate, 5000, 5000) animated:YES];//下法同
    //    self.mapView.region = MKCoordinateRegionMake([YWLocation shareLocation].coordinate, MKCoordinateSpanMake(0.01, 0.01));
    UICollectionViewFlowLayout * collectionFlow = [[UICollectionViewFlowLayout alloc]init];
    collectionFlow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortSubCollectionView = [[YWStormSubSortCollectionView alloc]initWithFrame:CGRectMake(kScreen_Width/3, NavigationHeight, kScreen_Width * 2/3, kScreen_Height - 64.f - 49.f) collectionViewLayout:collectionFlow];
    self.sortSubCollectionView.choosedTypeBlock = ^(NSInteger type,NSInteger subType){
        [weakSelf.sortTableView.dataStateArr replaceObjectAtIndex:type withObject:@(subType)];
        weakSelf.subType = subType;
        [weakSelf requestAnnotationData];
        
        weakSelf.sortTableView.hidden = YES;
        weakSelf.sortSubCollectionView.hidden = weakSelf.sortTableView.hidden;
    };
    [self.sortSubCollectionView dataSet];
    
    self.sortTableView = [[YWStormSortTableView alloc]initWithFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width/3, self.sortSubCollectionView.height) style:UITableViewStylePlain];
    self.sortTableView.choosedTypeBlock = ^(NSInteger type,NSInteger subType,NSArray * subArr,NSArray * subTagArr){
        weakSelf.type = type;
        weakSelf.sortSubCollectionView.allTypeIdx = type;
        weakSelf.sortSubCollectionView.choosedTypeIdx = subType;
        weakSelf.sortSubCollectionView.dataArr = subArr;
        weakSelf.sortSubCollectionView.dataTagArr = subTagArr;
        weakSelf.subType = [subTagArr[0] integerValue];
    };
    self.sortTableView.hidden = YES;
    self.sortSubCollectionView.hidden = self.sortTableView.hidden;
    [self.view addSubview:self.sortTableView];
    [self.view addSubview:self.sortSubCollectionView];
}

- (void)cityNameSetWithStr:(NSString *)locality{
    NSMutableString * str = [NSMutableString stringWithString:locality];
    NSRange strRange = [str rangeOfString:@"市"];
    if (strRange.length>0)[str deleteCharactersInRange:strRange];
    
    if (![self.locationBtn.titleLabel.text isEqualToString:locality]) {
        [self.locationBtn setTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark - Control Action
- (void)searchAction{
    NewSearchViewController * vc = [[NewSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sortAction{
    self.sortTableView.hidden = !self.sortTableView.hidden;
    self.sortSubCollectionView.hidden = self.sortTableView.hidden;
}

- (IBAction)toMyLocationBtnAction:(id)sender {
    self.mapView.centerCoordinate = [YWLocation shareLocation].coordinate;
    [self requestAnnotationData];
}
- (IBAction)searchBtnAction:(id)sender {
    [self searchAction];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    if (!self.isSearch) {
        [self requestAnnotationData];
    }
    [self getMyLocationPlacemark:location];
}

- (void)getMyLocationPlacemark:(CLLocation *)location{
    WEAKSELF;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull placemark, NSUInteger idx, BOOL * _Nonnull stop) {//地址反编译
//            MyLog(@"current location is %@",placemark.name);
            [weakSelf cityNameSetWithStr:placemark.locality];
        }];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(nonnull id<MKAnnotation>)annotation{
    if (![annotation isKindOfClass:[YWStormAnnotationModel class]]) return nil;//用户位置
    
    YWStormPinAnnotationView * annotationView = (YWStormPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"STORM_PINANNOTATION"];
    if (!annotationView)annotationView = [[YWStormPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"STORM_PINANNOTATION"];
    
    __weak typeof(annotationView)weakAnnotationView = annotationView;
    annotationView.callViewBlock = ^(){
        
        ShopDetailViewController * vc = [[ShopDetailViewController alloc]init];
        vc.shop_id = weakAnnotationView.model.annotationID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    annotationView.canShowCallout = YES;
    annotationView.model = (YWStormAnnotationModel *)annotation;
    return annotationView;
}
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    if (![view isKindOfClass:[YWStormPinAnnotationView class]]) return;
//    YWStormPinAnnotationView * annotationView = (YWStormPinAnnotationView *)view;
//    MyLog(@"Select %@ AnnotationView",annotationView.model.type);
//    YWShoppingDetailViewController * vc = [[YWShoppingDetailViewController alloc]init];
//    vc.shop_id = annotationView.model.annotationID;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - Http
- (void)requestAnnotationData{
    NSDictionary * pragram = @{@"tag_id":[NSString stringWithFormat:@"%zi",self.subType],@"coordinatex":[NSString stringWithFormat:@"%f",[YWLocation shareLocation].lon],@"coordinatey":[NSString stringWithFormat:@"%f",[YWLocation shareLocation].lat]};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_STORM_NEARSHOP withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.isSearch = YES;
        [self.mapView removeAnnotations:self.mapView.annotations];
//        NSDictionary * dataDic = responsObj[@"data"];
//        NSArray * dataArr = [dataDic allValues];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            YWStormAnnotationModel * model = [YWStormAnnotationModel yy_modelWithJSON:dataArr[i]];
            model.coordinate = (CLLocationCoordinate2D){[model.coordinatey floatValue],[model.coordinatex floatValue]};
            [model setTitle:@"\n"];
            [self.mapView addAnnotation:model];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


@end
