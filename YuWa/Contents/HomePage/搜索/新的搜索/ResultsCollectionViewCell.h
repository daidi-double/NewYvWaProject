//
//  ResultsCollectionViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultsModel;

@interface ResultsCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel*firstLabel;
-(void)cellModel:(ResultsModel*)model;
@end
