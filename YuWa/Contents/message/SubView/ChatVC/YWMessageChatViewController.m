//
//  YWMessageChatViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageChatViewController.h"
#import "YWOtherSeePersonCenterViewController.h"
#import "ShopDetailViewController.h"

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NSDate+Category.h"
#import "EaseUsersListViewController.h"
#import "EaseMessageReadManager.h"
#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseCustomMessageCell.h"
#import "UIImage+EMGIF.h"
#import "EaseLocalDefine.h"
#import "EaseSDKHelper.h"

#import "VoiceChatViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "EMCDDeviceManager.h"

#define KHintAdjustY    50

#define IOS_VERSION [[UIDevice currentDevice] systemVersion]>=9.0
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface YWMessageChatViewController ()<EMCallManagerDelegate>
@property (nonatomic,strong)VoiceChatViewController * voiceViewController;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)EMCallSession * currentSession;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation YWMessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.friendNikeName?self.friendNikeName:@"聊天";
    //移除实时通话回调
    [[EMClient sharedClient].callManager removeDelegate:self];
    //注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];

    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"haveaccount"] style:UIBarButtonItemStylePlain target:self action:@selector(toOtherPersen)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)toOtherPersen{
    MyLog(@"查看个人中心");
    if ([self.user_type isEqualToString:@"1"]) {
        //如果是1，表示是用户账号。就跳转，如果是商家则跳转到店铺
        YWOtherSeePersonCenterViewController * vc = [[YWOtherSeePersonCenterViewController alloc]init];
        vc.uid = self.friendID;
        vc.nickName = self.friendNikeName;
        vc.otherIcon = self.friendIcon;
        vc.user_type = self.user_type;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ShopDetailViewController * detailVC = [[ShopDetailViewController alloc]init];
        detailVC.shop_id = self.friendID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)makeCall:(NSNotification*)notification{
    
    
    NSString * type = [notification object][@"type"];
    _voiceViewController = [[VoiceChatViewController alloc]init];
    _voiceViewController.friendsName = [notification object][@"chatter"];
    _voiceViewController.type = [type integerValue];
    _voiceViewController.isSender = YES;
    _voiceViewController.status = 0;
    _voiceViewController.friendsIcon = self.friendIcon;
    _voiceViewController.conversation = [[EMClient sharedClient].chatManager getConversation:[notification object][@"chatter"] type:EMConversationTypeChat createIfNotExist:YES];
    _voiceViewController.friendsNiceName = self.friendNikeName;
    [self _startCallTimer];
    [self presentViewController:_voiceViewController animated:YES completion:nil];
    WEAKSELF;
    _voiceViewController.addBlock = ^(EMMessage*textmessage){
        textmessage.status = EMMessageStatusSuccessed;
        [weakSelf addMessageToDataSource:textmessage progress:nil];
        if ([weakSelf _shouldMarkMessageAsRead])
        {
            [weakSelf.conversation markMessageAsReadWithId:textmessage.messageId error:nil];
        }
    };
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            [self addMessageToDataSource:message progress:nil];
            
            if ([self _shouldMarkMessageAsRead])
            {
                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
            }
           
        }
    }
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {

    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"收到图片消息", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"收到位置消息", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"收到语音消息", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"收到视频消息", @"Video");
            }
                break;
            default:
                break;
        }
        
//        do {
////            NSString *title = [self getNickNameWithUsername:message.from];
//            MyLog(@"消息来自谁 = %@",message.from);
//            NSString * title = @"";
//            if (message.chatType == EMChatTypeGroupChat) {
//                NSDictionary *ext = message.ext;
//                if (ext && ext[kGroupMessageAtList]) {
//                    id target = ext[kGroupMessageAtList];
//                    if ([target isKindOfClass:[NSString class]]) {
//                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                    else if ([target isKindOfClass:[NSArray class]]) {
//                        NSArray *atTargets = (NSArray*)target;
//                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                }
//                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:message.conversationId]) {
//                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                        break;
//                    }
//                }
//            }
//            else if (message.chatType == EMChatTypeChatRoom)
//            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//                if (chatroomName)
//                {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//                }
//            }
//            
//            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
//        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"有一条未读消息", @"you have a new message");

    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送

    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
        
    }
}


- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewControllerShouldMarkMessagesAsRead:)]) {
        isMark = [self.dataSource  messageViewControllerShouldMarkMessagesAsRead:self];
    }
    else{
        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
        {
            isMark = NO;
        }
    }
    
    return isMark;
}


- (void)_startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}
- (void)_timeoutBeforeCallAnswered
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"对方暂时无法接通", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"好的", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}
/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    [self _stopCallTimer];

}
/*
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */

- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError
{
    [self _stopCallTimer];
    [self.voiceViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)hangupCallWithReason:(EMCallEndReason)aReason
{

    [self _stopCallTimer];
    if (_currentSession) {
        
        [[EMClient sharedClient].callManager endCall:_currentSession.callId reason:aReason];
        _currentSession = nil;
    }
    [self _clearCurrentCallViewAndData];
    
    
    
}

- (void)_clearCurrentCallViewAndData
{
    self.currentSession = nil;
    if (self.voiceViewController) {
        
        [self.voiceViewController clearData];
    }
    self.voiceViewController = nil;
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }else{
        id<IMessageModel> model = object;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [self.delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[EaseMessageCell class]]) {
                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                    if ([model.nickname isEqualToString:[UserSession instance].account]) {
                        emcell.nameLabel.text = [UserSession instance].nickName;
                        [emcell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                        emcell.hasRead.hidden = YES;
                    }else{
                        emcell.nameLabel.text = self.friendNikeName;
                        [emcell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                        emcell.hasRead.hidden = YES;
                    }
                }
                
                return cell;
            }
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [self.dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                NSString *CellIdentifier = [EaseCustomMessageCell cellIdentifierWithModel:model];
                //send cell
                EaseCustomMessageCell *sendCell = (EaseCustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                // Configure the cell...
                if (sendCell == nil) {
                    sendCell = [[EaseCustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionURLFormessageViewController:messageModel:)]) {
                    EaseEmotion *emotion = [self.dataSource emotionURLFormessageViewController:self messageModel:model];
                    if (emotion) {
                        model.image = [UIImage sd_animatedGIFNamed:emotion.emotionOriginal];
                        model.fileURLPath = emotion.emotionOriginalURL;
                    }
                }
                sendCell.model = model;
                sendCell.delegate = self;
                if ([model.nickname isEqualToString:[UserSession instance].account]) {
                    sendCell.nameLabel.text = [UserSession instance].nickName;
                    [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                    sendCell.hasRead.hidden = YES;
                }else{
                    sendCell.nameLabel.text = self.friendNikeName;
                    [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                    sendCell.hasRead.hidden = YES;
                }
                return sendCell;
            }
        }
        
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        if ([model.nickname isEqualToString:[UserSession instance].account]) {
            sendCell.nameLabel.text = [UserSession instance].nickName;
            [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
            sendCell.hasRead.hidden = YES;
        }else{
            sendCell.nameLabel.text = self.friendNikeName;
            [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
            sendCell.hasRead.hidden = YES;
        }
        return sendCell;
    }
}

- (void)avatarViewSelcted:(id<IMessageModel>)model{
    if ([model.nickname isEqualToString:[UserSession instance].account])return;
    MyLog(@"用户点击头像");
    if ([self.user_type isEqualToString:@"1"]) {
        //如果是1，表示是用户账号。就跳转，如果是商家则跳转到店铺
        YWOtherSeePersonCenterViewController * vc = [[YWOtherSeePersonCenterViewController alloc]init];
        vc.uid = self.friendID;
        vc.nickName = self.friendNikeName;
        vc.otherIcon = self.friendIcon;
        vc.user_type = self.user_type;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ShopDetailViewController * detailVC = [[ShopDetailViewController alloc]init];
        detailVC.shop_id = self.friendID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
