//
//  YWStormSubSortCollectionView.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWStormSubSortCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy)void(^choosedTypeBlock)(NSInteger,NSInteger);
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong)NSArray * dataTagArr;
@property (nonatomic,assign)NSInteger allTypeIdx;
@property (nonatomic,assign)NSInteger choosedTypeIdx;

- (void)dataSet;

@end
