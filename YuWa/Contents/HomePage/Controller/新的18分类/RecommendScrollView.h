//
//  RecommendScrollView.h
//  YuWa
//
//  Created by double on 2017/2/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendScrollView : UIScrollView
@property (nonatomic,strong) UIImageView * movieImageView;
@property (nonatomic,strong) UIButton * playBtn;

- (instancetype)initWithFrame:(CGRect)frame andWithArray:(NSMutableArray*)ary;
@end
