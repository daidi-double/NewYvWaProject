//
//  YWStormAnnotationModel.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YWStormAnnotationModel : MKPointAnnotation
//是大头针模型 所以必须实现协议MKAnnotation协议 和CLLocationCoordinate2D中的属性coordinate

@property (nonatomic,copy) NSString * type;//cid
@property (nonatomic,copy) NSString * annotationID;
@property (nonatomic,copy) NSString * coordinatex;//经度
@property (nonatomic,copy) NSString * coordinatey;//纬度
@property (nonatomic,copy) NSString * company_img;
@property (nonatomic,copy) NSString * catname;
@property (nonatomic,strong) NSArray * tag_name;
@property (nonatomic,copy) NSString * company_name;
@property (nonatomic,copy) NSString * distance;
@property (nonatomic,copy) NSString * star;
@property (nonatomic,copy) NSString * company_near;
@property (nonatomic,copy) NSString * discount;
@property (nonatomic,copy) NSString * cid;


@end
