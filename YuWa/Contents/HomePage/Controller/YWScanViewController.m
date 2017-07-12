//
//  YWScanViewController.m
//  YuWa
//
//  Created by double on 17/3/31.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"
#import "ScanModel.h"
//#import "YWPayViewController.h"
#import "ShopDetailViewController.h"
#import "YWNewDiscountPayViewController.h"

static const CGFloat kBorderW = 100;//边框宽度
static const CGFloat kMargin = 30;//扫描窗口的外边距
@interface YWScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,weak)UIView * maskView;
@property (nonatomic,strong)UIView * scanWindow;
@property (nonatomic,strong)UIImageView * scanNetImageView;
@property (nonatomic,strong)AVCaptureSession * session;

@property (nonatomic,assign)NSInteger staus;
@end

@implementation YWScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        [self beginQRCode];//启动摄像头
    }
    [self resumeAnimation];
    [self setupScanWindowView];
    [self setupmaskView];//遮罩层

}

- (void)setupmaskView{
    UIView * mask = [[UIView alloc]initWithFrame:CGRectMake(-65, self.view.origin.y, kScreen_Width+kBorderW + kMargin, kScreen_Width+kBorderW + kMargin)];
    self.maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:00 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    [self.view addSubview:mask];
    UIView*mask1=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.y+_maskView.height, kScreen_Width,300)];
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
}

#pragma mark -- AVCaptureMetadataOutputObjectDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count> 0) {
        [self resumeAnimation];
        [_session stopRunning];
        if (metadataObjects.count>0)
        {
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
            MyLog(@"%@",metadataObject.stringValue);
            if ([metadataObject.stringValue hasPrefix:@"yuwabao"]){
                NSArray*array=[metadataObject.stringValue componentsSeparatedByString:@"/"];
                NSString*idd=array.lastObject;
                ShopDetailViewController * vc = [[ShopDetailViewController alloc]init];
                vc.shop_id = idd;
                [self.navigationController pushViewController:vc animated:YES];
            }else if  (![metadataObject.stringValue hasPrefix:@"yvwa.com/"]) {
                NSArray*array=[metadataObject.stringValue componentsSeparatedByString:@"/"];
                NSString*idd=array.lastObject;
                [self getDatasWithIDD:idd];

            }else {
                
                //不是我们的二维码
                NSString*strr=[NSString stringWithFormat:@"可能存在风险，是否打开此链接?\n %@",metadataObject.stringValue];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:strr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接", nil];
                [alert show];

            }
          
        }else{
            //扫描结果不成功
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果" message:@"无法识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)getDatasWithIDD:(NSString*)idd{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_QRCODE_ID];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"code":idd};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        //        MyLog(@"%@",data);
        
        NSString*company_name=data[@"data"][@"company_name"];   //这个 名字 需要改。
        NSString*shopID=data[@"data"][@"seller_uid"];
        CGFloat discount=[data[@"data"][@"discount"] floatValue];
        CGFloat total_money=[data[@"data"][@"total_money"] floatValue];
        CGFloat non_discount_money=[data[@"data"][@"non_discount_money"] floatValue];
        
        YWNewDiscountPayViewController*vc=[YWNewDiscountPayViewController payViewControllerCreatWithQRCodePayAndShopName:company_name andShopID:shopID andZhekou:discount andpayAllMoney:total_money andNOZheMoney:non_discount_money];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
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
        CGFloat scanWindowH = kScreen_Width - kMargin * 2;//扫描窗口的高度
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
