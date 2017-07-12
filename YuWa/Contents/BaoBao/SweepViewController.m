//
//  SweepViewController.m
//  YuWa
//
//  Created by double on 17/3/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SweepViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"
#import "CatchWawaModel.h"
#import "HttpObject.h"
static const CGFloat kBorderW = 100;//边框宽度
static const CGFloat kMargin = 30;//扫描窗口的外边距
@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIGestureRecognizerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *touchBGView;
@property (nonatomic,weak)UIView * maskView;
@property (nonatomic,strong)UIView * scanWindow;
@property (nonatomic,strong)UIImageView * scanNetImageView;
@property (nonatomic,strong)AVCaptureSession * session;
@property (nonatomic,strong)UIImageView * gainView;
@property (nonatomic,copy)NSString * catchNumber;
@property (nonatomic,assign)NSInteger staus;

@end

@implementation SweepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    [self setupmaskView];//遮罩层
    [self setupScanWindowView];
    [self beginQRCode];
    [self resumeAnimation];
   
}
- (void)setupmaskView{
    UIView * mask = [[UIView alloc]initWithFrame:CGRectMake(-65, self.view.origin.y, self.view.width+kBorderW + kMargin, self.view.width+kBorderW + kMargin)];
    self.maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:00 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    [self.view addSubview:mask];
    UIView*mask1=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.y+_maskView.height, self.view.width,300)];
    mask1.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask1];
}

- (void)beginQRCode{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    _session = [[AVCaptureSession alloc]init];

    if (!input) return;
    [_session addInput:input];
    [_session addOutput:output];

    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
   [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    AVCaptureVideoPreviewLayer * captureLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    captureLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:captureLayer atIndex:0];
    [_session startRunning];
    
}
- (void)setupScanWindowView{
    CGFloat scanWindowH = kScreen_Width - kMargin * 2;
    CGFloat scanWindowW = kScreen_Width - kMargin * 2;
    //扫描窗口创建
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanWindowW, scanWindowH)];
    //扫描动画图片是添加在这个扫描窗口上的  窗口以外要隐藏
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
    //扫描动画图
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    //四个角落小图标
    CGFloat buttonWH = 18;
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH-6, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y-2, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
     [self setupmaskView];//遮罩层
}

#pragma mark -- AVCaptureMetadataOutputObjectDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count> 0) {
        [self resumeAnimation];
        [_session stopRunning];
        CatchWawaModel * catchModel = [metadataObjects firstObject];
        self.stringValue = catchModel.stringValue;
        MyLog(@"metadataObjects = %@",catchModel.stringValue);
        if (self.stringValue != nil || [self.stringValue isEqualToString:@""]) {
            [self checkUpUserNumber];
//            [self upRequesData];
        }
    }
}

- (void)beginCatchWawa{
    if (self.gainView) {
        [self.gainView removeFromSuperview];
    }
    if (self.staus == 0) {
    _gainView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _gainView.image = [UIImage imageNamed:@"gain.jpg"];
    [self.view addSubview:_gainView];
    _gainView.userInteractionEnabled = YES;
    
    UILabel * infomation = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreen_Width-60, kScreen_Height/5)];
    infomation.center = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    infomation.text = [NSString stringWithFormat:@"今日免费抓娃娃%@",self.catchNumber];
    infomation.font = [UIFont systemFontOfSize:16];
    infomation.textColor = [UIColor blackColor];
    infomation.textAlignment = 1;
    [self.view addSubview:infomation];
    
    UIButton * goCatchBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    goCatchBtn.frame = CGRectMake(40, kScreen_Height * 0.75f, kScreen_Width /3, 50);
    goCatchBtn.layer.masksToBounds = YES;
    goCatchBtn.layer.cornerRadius = 5;

    [goCatchBtn setImage:[UIImage imageNamed:@"beginCatch"] forState:UIControlStateNormal];
    [goCatchBtn addTarget:self action:@selector(goCatch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goCatchBtn];
    
//    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, kScreen_Height/5)];
//    number.center = CGPointMake(kScreen_Width/2, kScreen_Height/2+30);
//    if ([number.text integerValue] == 0) {
//        number.textColor = [UIColor redColor];
//    }
//    number.textColor = [UIColor greenColor];
//    [self.view addSubview:number];
    
    UIAlertController * alertVC  = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"恭喜您获得今日免费抓娃娃的机会，是否马上开始抓娃娃" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction * ture = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //调用接口，发送请求
        [self upRequesData];
        MyLog(@"开始抓娃娃");
        
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ture];
    [self presentViewController:alertVC animated:YES completion:nil];
        
    }else{
        _gainView = [[UIImageView alloc]initWithFrame:self.view.frame];
        _gainView.image = [UIImage imageNamed:@"sorry"];
        [self.view addSubview:_gainView];
        _gainView.userInteractionEnabled = YES;
        
        UILabel * infomation = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreen_Width-60, kScreen_Height/5)];
        infomation.center = CGPointMake(kScreen_Width/2, kScreen_Height/2);
        infomation.text = [NSString stringWithFormat:@"%@",self.catchNumber];
        infomation.font = [UIFont systemFontOfSize:16];
        infomation.textColor = [UIColor redColor];
        infomation.textAlignment = 1;
        [self.view addSubview:infomation];

    }
}
- (void)resumeAnimation
{
    //先判断是否是在动画
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        //移除
        [_scanNetImageView.layer removeAnimationForKey:@"translationAnimation"];
        
    }else{//没有这个动画就添加
        CGFloat scanNetImageViewH = 241;//扫描动画图的高度
        CGFloat scanWindowH = self.view.width - kMargin * 2;//扫描窗口的高度
        CGFloat scanNetImageViewW = _scanWindow.width;//扫描动画图的宽度
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        //设置从自身位置经过的值为扫描窗口的高度
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
    
    
}
- (void)goCatch{
    [JRToast showWithText:@"开始抓娃娃" duration:1];
    [self upRequesData];
}
- (void)checkUpUserNumber{

    NSDictionary * params = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"config_id":@""};
    [[HttpObject manager]postNoHudWithType:YuWaType_WAWA_CheckUpNumber withPragram:params success:^(id responsObj) {
        MyLog(@"responsObj = %@",responsObj);
        NSInteger number = [responsObj[@"errorCode"] integerValue];
        if (number == 0) {
            self.staus = 0;
            self.catchNumber = responsObj[@"msg"];
            [self beginCatchWawa];
            
        }
        
    } failur:^(id errorData, NSError *error) {
        self.staus = 1;
        self.catchNumber = errorData[@"errorMessage"];
        [self beginCatchWawa];
//        今日次数已经用完，请尝试其他方式！
        MyLog(@"self.catchNumber = %@",self.catchNumber);
    }];
}

//开始抓娃娃
- (void)upRequesData{

    NSDictionary * params = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"config_id":@"",@"value":self.stringValue};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_WAWA_CatchWaWa withPragram:params success:^(id responsObj) {
        MyLog(@"responsObj = %@",responsObj);
        NSInteger number = [responsObj[@"errorCode"] integerValue];
        if (number == 0) {
            self.staus = 0;
            self.catchNumber = responsObj[@"msg"];
           
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkUpUserNumber];
        });
        
    } failur:^(id errorData, NSError *error) {
        self.staus = 1;
        self.catchNumber = errorData[@"errorMessage"];
        [self beginCatchWawa];
        //        今日次数已经用完，请尝试其他方式！

    }];

//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        MyLog(@"responseObject = %@",responseObject);
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////        if ([dic[@"errorCode"] isEqualToString:@"0"]) {
////            
////        }
//        MyLog(@"dic = %@",dic[@"errorMessage"]);
//        
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//    }];
    

}

//- (void)longAnRecognition:(UIGestureRecognizer*)gesture{
//
//   if(gesture.state==UIGestureRecognizerStateBegan){
//       timer.fireDate=[NSDate distantFuture];
//    UIImageView*tempImageView=(UIImageView*)gesture.view;
//       
//    if(tempImageView.image){
//        //1. 初始化扫描仪，设置设别类型和识别质量
//        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
//        //2. 扫描获取的特征组
//        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:tempImageView.image.CGImage]];
//        //3. 获取扫描结果
//        CIQRCodeFeature *feature = [features objectAtIndex:0];
//        NSString *scannedResult = feature.messageString;
//
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"确定");
//            NSURL * url = [NSURL URLWithString:scannedResult];
//            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
//            //先判断是否能打开该url
//            if (canOpen)
//            {   //打开微信
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"weixin://%@",url]]];
//               //
//                
//                //未完
//                
//                //
//                
//                
//            }else {
//                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"您未安装微信，请先下载安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
//                
//            }
//        }];
//        [alert addAction:alertAction];
//        
//        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
//            
//            NSLog(@"取消");
//            
//        }];
//
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//       
//   }else if (gesture.state==UIGestureRecognizerStateEnded){
//       
//       timer.fireDate=[NSDate distantPast];
//       
//   }
//    
//}
//
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
