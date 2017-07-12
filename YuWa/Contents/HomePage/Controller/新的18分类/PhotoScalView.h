//
//  PhotoScalView.h
//  YuWa
//
//  Created by double on 17/6/7.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScalView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic,copy)NSString * imageUrl;
@property (nonatomic,strong)NSArray * imageAry;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * strLabel;
@property (nonatomic,strong)NSString * totalNum;//总张数
@property (nonatomic,assign)NSInteger  currentNum;//当前张数
@property (nonatomic,strong) UIView * BGView;
@property (nonatomic,strong) NSMutableArray * dataAry;
@end
