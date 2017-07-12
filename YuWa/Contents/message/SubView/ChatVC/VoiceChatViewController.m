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
    _statusLabel.text = @"正在呼叫";
    
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
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [self _stopTimeTimer];
    _callSession = nil;
    [self clearData];
    
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
    [self _stopTimeTimer];
    
    if (self.callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:aReason];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//拒绝
- (IBAction)rejectAction:(UIButton *)sender {
    [self _stopTimeTimer];
    
    [self hangupCallWithReason:EMCallEndReasonDecline];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//挂断
- (IBAction)hangupAction:(UIButton *)sender {
    [self _stopTimeTimer];
    if (_callSession) {
        
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonHangup];
        _callSession = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//接听
- (IBAction)answerAction:(UIButton *)sender {
    _timeLabel.hidden = NO;
    [self _startTimeTimer];
    
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
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:self.callSession.callId reason:EMCallEndReasonHangup];
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    
    
}

- (void)clearData{
    [self dismissViewControllerAnimated:YES completion:nil];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    
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
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelTemp.header_img]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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