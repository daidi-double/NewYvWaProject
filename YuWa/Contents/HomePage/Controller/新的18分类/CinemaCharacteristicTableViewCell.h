//
//  CinemaCharacteristicTableViewCell.h
//  YuWa
//
//  Created by double on 17/5/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CinemaCharacteristicTableViewCellDelegate <NSObject>

-(void)seeAllPhoto;

@end
@interface CinemaCharacteristicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic,strong)NSArray * imageAry;
@property (nonatomic,assign)id<CinemaCharacteristicTableViewCellDelegate>delegate;
@end
