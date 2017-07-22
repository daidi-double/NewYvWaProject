//
//  VoiceChatViewController.h
//  YuWa
//
//  Created by double on 17/7/6.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VoiceChatViewController : UIViewController
@property (nonatomic,assign)NSInteger type;//0语音，1视频
@property (nonatomic,strong)NSString * friendsName;
@property (nonatomic,strong)NSString * friendsNiceName;
@property (nonatomic,strong)EMCallSession *callSession;
@property (nonatomic,strong)NSString * friendsIcon;
@property (nonatomic,assign)BOOL isSender;
@property (nonatomic,strong)NSString * remoteUsername;
@property (nonatomic,assign)NSInteger status;//0主动发起方，1接收方
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,strong)EMConversation *conversation;

@property (nonatomic,copy) void (^addBlock)(EMMessage*);
- (void)clearData;
@end
