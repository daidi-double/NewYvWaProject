//
//  HotMovieScrollView.h
//  YuWa
//
//  Created by double on 2017/2/16.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
@protocol HotMovieScrollViewDelegate <NSObject>

- (void)pushToDetailPage:(BannerModel*)model;

@end
@interface HotMovieScrollView : UIScrollView
@property (nonatomic,strong) UICollectionView * CarouselView;
@property (nonatomic,assign) id<HotMovieScrollViewDelegate>HotDelegate;
- (instancetype)initWithFrame:(CGRect)frame andDataAry:(NSMutableArray*)dataAry;

@end
