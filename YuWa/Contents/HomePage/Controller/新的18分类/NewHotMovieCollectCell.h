//
//  NewHotMovieCollectCell.h
//  YuWa
//
//  Created by double on 17/5/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotMovieModel.h"
@interface NewHotMovieCollectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieScoreLabel;
@property (nonatomic,strong)HotMovieModel * model;
@end
