//
//  VIPPersonCenterViewController.h
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/7.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,showViewCategory){
    showViewCategoryNotes=0,
    showViewCategoryAlbum=1,
    showViewCategoryCommit=2,

    
    
};

@interface VIPPersonCenterViewController : UIViewController

@property(nonatomic,assign)showViewCategory showWhichView;

@end
