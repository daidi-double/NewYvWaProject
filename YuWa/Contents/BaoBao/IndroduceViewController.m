//
//  IndroduceViewController.m
//  YuWa
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "IndroduceViewController.h"
#import "AwardViewController.h"
#import "ExchangeCodeModel.h"

@interface IndroduceViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UIView * bgView;
    UIView * exchangeView ;
    UIView *line;
}
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic,strong)UIImageView * introduceImageView;
@property (nonatomic,strong)UITextField * codeTextField;
//@property (nonatomic,strong)NSMutableArray * historyArr;
@property (nonatomic,strong)NSMutableArray * codeListArr;
@end

@implementation IndroduceViewController
//- (NSMutableArray *)historyArr{
//    if (!_historyArr) {
//        _historyArr = [NSMutableArray array];
//    }
//    return _historyArr;
//}

-(NSMutableArray*)codeListArr{
    if (!_codeListArr) {
        _codeListArr = [NSMutableArray array];
    }
    return _codeListArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self creatInPutExchangeCodeView];
    _codeTextField.text = nil;
    // Do any additional setup after loading the view from its nib.
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    [self getMyExchangeList];
//    
//}png
- (void)makeUI{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"娃娃机开大奖" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];

    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    scrollView.contentSize=CGSizeMake(kScreen_Width, kScreen_Width * image.size.height/image.size.width);
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * image.size.height/image.size.width)];
    imageView.image = image;
    
    [scrollView addSubview:imageView];
    self.imageScrollView=scrollView;
   
        CGFloat btnWidth = (kScreen_Width - 10 - 40)/2;
        NSArray * btnImageArr = @[@"shuru",@"领奖"];
        for (int i = 0; i<2; i++) {
            UIButton * touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            touchBtn.frame = CGRectMake(20 + (btnWidth + 10)* i, kScreen_Width * image.size.height/image.size.width* 0.43f, btnWidth, btnWidth/2.5);
            [touchBtn setImage:[UIImage imageNamed:btnImageArr[i] ] forState:UIControlStateNormal];
            touchBtn.tag = i + 1;
            [touchBtn addTarget:self action:@selector(toExchangeCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.imageScrollView addSubview:touchBtn];
    
        
        
    }
 
}
- (IBAction)toExchangeCodeAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            
            [self getMyExchangeList];
            bgView.hidden = NO;
            exchangeView.hidden = NO;
            break;
            
        default:
        {
            AwardViewController * vc = [[AwardViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }

    
}

- (void)creatInPutExchangeCodeView{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgView.alpha = 0.6f;
    bgView.hidden = YES;
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    
    exchangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width*0.9f , kScreen_Height * 0.45f)];
    exchangeView.backgroundColor = [UIColor whiteColor];
    exchangeView.hidden = YES;
    exchangeView.center = bgView.center;
  
    [self.view addSubview:exchangeView];
    
    UIImageView * backBtn = [[UIImageView alloc]initWithFrame:CGRectMake(exchangeView.right - 17, -17, 17, 17)];
    backBtn.image = [UIImage imageNamed:@"x"];
    [exchangeView addSubview:backBtn];
    
    UIImage * giftImage = [UIImage imageNamed:@"gift"];
    UIImageView * picImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, -50, exchangeView.width/2, exchangeView.height * giftImage.size.height/giftImage.size.width/2)];
    picImageView.centerX = exchangeView.centerX;
    picImageView.image = giftImage;
    
    [exchangeView addSubview:picImageView];
    
    
    UITapGestureRecognizer* tapt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tapt.numberOfTapsRequired = 1;
    tapt.numberOfTouchesRequired = 1;
    tapt.delegate = self;
    [bgView addGestureRecognizer:tapt];
    
    UILabel * codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, picImageView.bottom +20, kScreen_Width * 0.5f , 30)];
    codeLabel.font = [UIFont systemFontOfSize:14];
    codeLabel.text = @"输入兑换码:";
    CGRect shopNameWidth = [codeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: codeLabel.font} context:nil];
    codeLabel.frame= CGRectMake(20, picImageView.bottom +20, shopNameWidth.size.width , 30);
    codeLabel.textColor = RGBCOLOR(105, 105, 105, 1);
    [exchangeView addSubview:codeLabel];
    
    self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(25 +codeLabel.width, codeLabel.y, exchangeView.width*0.4f, 30)];
    _codeTextField.font = [UIFont systemFontOfSize:14];
    _codeTextField.borderStyle = UITextBorderStyleLine;
    [exchangeView addSubview:_codeTextField];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(exchangeView.width*0.78f, codeLabel.y, exchangeView.width * 0.2f, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:CNaviColor];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(updataAction) forControlEvents:UIControlEventTouchUpInside];
    [exchangeView addSubview:sureBtn];
    
    UILabel * historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, codeLabel.bottom+5, exchangeView.width * 0.5f +30, 25)];
    historyLabel.font = [UIFont systemFontOfSize:12];
    historyLabel.textColor = RGBCOLOR(140, 140, 140, 1);
    historyLabel.text = @"历史兑换记录";
    [exchangeView addSubview:historyLabel];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(20, historyLabel.y+25, exchangeView.width - 40, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [exchangeView addSubview:line];
    
}
- (void)tapAction{
    bgView.hidden = YES;
    exchangeView.hidden = YES;
    [self.view endEditing: YES];
    [self clerCode];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
//确定
- (void)updataAction{
    bgView.hidden = YES;
    exchangeView.hidden = YES;
    [self.view endEditing:YES];
    if ([_codeTextField.text isEqualToString:@""]) {
        [JRToast showWithText:@"兑换码为空" duration:1];
        return;
    }
    if (_codeTextField.text.length >11 || _codeTextField.text.length < 11 ) {
        [JRToast showWithText:@"请输入正确的兑换码" duration:1];
        return;
    }
    [self upCode];
    [self clerCode];

    
}

//上传兑换码
- (void)upCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_UPCODE];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"code":_codeTextField.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
    
}

//获取兑换记录
-(void)getMyExchangeList{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETHISTROYLIST];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        [self.codeListArr removeAllObjects];
        if (number == 0) {
            for (NSDictionary * dict in data[@"data"]) {
                
                ExchangeCodeModel * model = [ExchangeCodeModel yy_modelWithDictionary:dict];
                
                [self.codeListArr addObject:model];
                
            }
            CGFloat labelWidth = (exchangeView.width -20 -20)/2;
            for (int i = 0; i< self.codeListArr.count; i++) {
                ExchangeCodeModel * model = self.codeListArr[i];
                
                UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, line.y+5 + 30 *i, labelWidth, 30)];
                timeLabel.text = [JWTools getTimeTwo:model.ctime];
                timeLabel.textColor = RGBCOLOR(123, 123, 123, 1);
                timeLabel.font = [UIFont systemFontOfSize:14];
                [exchangeView addSubview:timeLabel];
                
                UILabel * historyCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 +(labelWidth +20), line.y+5 + 30*i, labelWidth , 30)];
                historyCodeLabel.text = model.code;
                historyCodeLabel.textColor = [UIColor lightGrayColor];
                historyCodeLabel.font = [UIFont systemFontOfSize:14];
                [exchangeView addSubview:historyCodeLabel];
            }
            

            [self reloadInputViews];
        }else{
            [JRToast showWithText:@"errorMessage" duration:1];
        }
    }];
}
- (void)clerCode{
    _codeTextField.text = nil;
}
- (void)inputRefreshView{
    [exchangeView reloadInputViews];
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
