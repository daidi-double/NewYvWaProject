//
//  ChooseOneModel.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseOneModel : NSObject

@property(nonatomic,strong)NSString*mainString;
@property(nonatomic,strong)NSString*subString;

@property(nonatomic,strong)NSArray*addressArray;
@property(nonatomic,assign)BOOL isSelected;
@end
