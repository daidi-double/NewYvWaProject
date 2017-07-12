//
//  MyAnnotation.h
//  YuWa
//
//  Created by double on 17/3/15.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@interface MyAnnotation : NSObject <MAAnnotation>
@property (nonatomic ) CLLocationCoordinate2D coordinate;
// Title and subtitle for use by selection UI.
@property (nonatomic, copy, nullable) NSString *title;


@end
