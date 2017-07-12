//
//  ChangeNibNameViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TouchType){
    TouchTypeNickName=0,
    TouchTypeCity
    
};

@protocol ChangeNibNameViewControllerDelegate <NSObject>

-(void)DelegateToChangeNibName:(NSString*)name andTouchType:(TouchType)type;

@end
@interface ChangeNibNameViewController : UIViewController
@property(nonatomic,assign)TouchType type;

@property(nonatomic,assign)id<ChangeNibNameViewControllerDelegate>delegate;
@end
