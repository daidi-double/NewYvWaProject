//
//  YWStormMapBtnView.h
//  YuWa
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWStormMapBtnView : UIView
@property (nonatomic,copy)void (^callViewBlock)();

@property (strong, nonatomic)UIButton *BGbtn;

@property (strong, nonatomic)UIImageView *showImageView;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *distanceLabel;

- (void)lengthSet;

@end
