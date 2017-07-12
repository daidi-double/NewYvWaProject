//
//  MapNavNewViewController.h
//  YuWa
//
//  Created by double on 17/3/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapNavNewViewController : UIViewController
@property(nonatomic,strong)NSString*coordinatex;           //经度
@property(nonatomic,strong)NSString*coordinatey;
@property (nonatomic,strong)NSString * shopName;
@property (nonatomic,assign)CLLocation * myLocation;

@end
