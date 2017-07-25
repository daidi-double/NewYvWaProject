//
//  VoiceChatViewController.m
//  YuWa
//
//  Created by double on 17/7/6.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "VoiceChatViewController.h"
#import "HttpObject.h"
#import "YWMessageAddressBookModel.h"
@interface VoiceChatViewController ()<EMCallManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_session;
    AVCaptureVideoDataOutput *_captureOutput;
    AVCaptureDeviceInput *_captureInput;
}
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UILabel *FriendsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) int timeLength;
@property (nonatomic,strong) NSString * accountType;
@property (nonatomic,strong)NSTimer * timeTimer;

@property (strong, nonatomic) AVAudioPlayer *ringPlayer;

@end

@implementation VoiceChatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _timeLabel.hidden = YES;
    if (self.status == 0) {
        self.rejectBtn.hidden = YES;
        self.answerBtn.hidden = YES;
        self.hangupBtn.hidden = NO;
        self.FriendsNameLabel.text = self.friendsNiceName;
    }else{
        self.rejectBtn.hidden = NO;
        self.answerBtn.hidden = NO;
        self.hangupBtn.hidden = YES;
        [self _beginRing];
      
        [self getIconAccount:_remoteUsername];
       
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.friendsIcon]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (!_callSession) {
        
        NSString * string = ([[[EMClient sharedClient] currentUsername] isEqualToString:_friendsName])?_friendsName:_friendsName;
        
        NSLog(@"currentUsername = %@  ,  string = %@",[[EMClient sharedClient] currentUsername],string);
        
        [[EMClient sharedClient].callManager startCall:(_type == 1)?EMCallTypeVideo:EMCallTypeVoice remoteName:string ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
            
            NSLog(@"startCall : errorDescription = %@",aError.errorDescription);
            
            if (!aError) {
                _callSession = aCallSession;
                [self createUI];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
    }else{
        
        [self createUI];
    }
    
}
#pragma mark - Camera


- (void)viewDidLoad {
    [super viewDidLoad];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.height/2;
    
}

-(void)createUI{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//休眠关闭
    if (_status ==0) {
        
        _statusLabel.text = @"正在呼叫";
    }else{
        _statusLabel.text = _type== 0?@"邀你进行语音通话":@"邀你进行视频通话";
    }
    
    if (_type == 1) {
        
        //对方窗口
        _callSession.remoteVideoView = [[EMCallRemoteView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _callSession.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill;
        _callSession.remoteVideoView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_callSession.remoteVideoView];
        
        
        //自己窗口
        _callSession.localVideoView = [[EMCallLocalView alloc]initWithFrame:CGRectMake(kScreen_Width-120, 64, 100, 120)];
        [self.view addSubview:_callSession.localVideoView];
        
    }
    [self.view bringSubviewToFront:_answerBtn];
    [self.view bringSubviewToFront:_hangupBtn];
    [self.view bringSubviewToFront:_rejectBtn];
}
/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    MyLog(@" 通话通道完成");
    if ([aSession.remoteName isEqualToString:_callSession.remoteName]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }

    
}
/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    
    MyLog(@" 同意通话");
    self.hangupBtn.hidden = NO;
    _statusLabel.text = @"正在通话中";
    if (self.status == 0) {
        _timeLabel.hidden = NO;
        [self _startTimeTimer];
    }
    
}
/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    MyLog(@"132主叫还是被叫%d",_callSession.isCaller);
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    [self _stopRing];
    if (_status == 1) {
        
        [self clearData];
    }
    [self _stopTimeTimer];

}
#pragma mark - private ring

- (void)_beginRing
{
    [self.ringPlayer stop];
    
    //    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    SystemSoundID sound = kSystemSoundID_Vibrate;
    
    NSString *musicPath = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"SIMToolkitGeneralBeep",@"caf"];
    if (musicPath) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:musicPath],&sound);
        if (error != kAudioServicesNoError) {
            sound = 0;
        }
    }
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    self.ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.ringPlayer setVolume:1];
    self.ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([self.ringPlayer prepareToPlay])
    {
        [self.ringPlayer play]; //播放
    }
}
- (void)_stopRing
{
    [self.ringPlayer stop];
}

- (void)_startTimeTimer
{
    MyLog(@"开启定时器");
    self.timeLength = 0;
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)_stopTimeTimer
{
    MyLog(@"销毁定时器");
    [self.timeTimer invalidate];
    self.timeTimer = nil;
    
    self.timeLabel.text = nil;
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason
{

    [self _stopRing];
    if (self.callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:aReason];
    }
    NSString * text;
    if (aReason == EMCallEndReasonHangup) {
        text = [NSString stringWithFormat:@"通话时长%@",_timeLabel.text];

        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"已取消";
            }else{
                text = @"未接听";
            }
        }
        
        EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:text];
        EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:[EMClient sharedClient].currentUsername to:_callSession.callId body:textMessageBody ext:nil];
        textMessage.status = EMMessageStatusSuccessed;
        textMessage.direction = EMMessageDirectionSend;
        textMessage.chatType = (EMChatType)self.conversation.type;
        textMessage.isDeliverAcked = YES;
        /** 刷新当前聊天界面 */
        if (self.addBlock) {
            
            self.addBlock(textMessage);
        }
        if (_timeLabel.text.length != 0) {
            
        }
        
        /** 存入当前会话并存入数据库 */
        
        [self.conversation insertMessage:textMessage error:nil];
        MyLog(@"最后一条信息%@---%@",self.conversation.latestMessage,textMessage.body);
        
    }
     _callSession = nil;
    [self _stopTimeTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//拒绝
- (IBAction)rejectAction:(UIButton *)sender {
    [self _stopRing];
    [self hangupCallWithReason:EMCallEndReasonDecline];
    [self _stopTimeTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//挂断
- (IBAction)hangupAction:(UIButton *)sender {
    [self _stopRing];
    if (_callSession) {
        
        [self hangupCallWithReason:EMCallEndReasonHangup];
       
    }
    [self _stopTimeTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//接听
- (IBAction)answerAction:(UIButton *)sender {
    _timeLabel.hidden = NO;
    [self _startTimeTimer];
    [self _stopRing];
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:self.callSession.callId];
    
    if (error) {
        
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonFailed];
    }else{
        self.rejectBtn.hidden = YES;
        sender.hidden = YES;
    }
}



-(void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//休眠关闭
    [self _stopRing];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonHangup];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    
    
}

- (void)clearData{
    [self dismissViewControllerAnimated:YES completion:nil];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [self _stopRing];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonHangup];
    self.callSession.remoteVideoView.hidden = YES;
    self.callSession.remoteVideoView = nil;
    _callSession = nil;
}

- (void)getIconAccount:(NSString *)username{
    
    NSString * account = [username substringFromIndex:1];
    if (username.length == 12) {
        if ([JWTools isPhoneIDWithStr:account]) {
            username = account;
            self.accountType = @"2";
        }
    }else if ([[username substringToIndex:1] isEqualToString:@"2"]){
        
        if ([JWTools checkIsHaveNumAndLetter:username] == 3) {
            self.accountType = @"2";
            username = account;
        }else{
            self.accountType = @"1";
        }
    }else{
        self.accountType = @"1";
    }
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":username,@"user_type":@(1),@"type":self.accountType};
    [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
        YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
        if ([modelTemp.header_img isEqualToString:@""]) {
            
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelTemp.header_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else{
            NSURL *url = [NSURL URLWithString:modelTemp.header_img]; // 获取的图片地址
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            _iconImageView.image = image;
        }
        if ([modelTemp.friend_remark isEqualToString:@""]) {
            
            self.FriendsNameLabel.text = modelTemp.nikeName;
        }else{
            self.FriendsNameLabel.text  = modelTemp.friend_remark;
        }
    } failur:^(id errorData, NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
