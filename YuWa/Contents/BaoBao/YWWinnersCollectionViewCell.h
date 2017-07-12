//
//  YWWinnersCollectionViewCell.h
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWWinnersCollectionViewCellDelegate <NSObject>

- (void)pushToGetAward:(NSInteger)btnTag;
@end
@interface YWWinnersCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *winLabel;//几等奖
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;//编码
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *getAwardBtn;
@property (nonatomic,assign)id<YWWinnersCollectionViewCellDelegate>delegate;

@end
