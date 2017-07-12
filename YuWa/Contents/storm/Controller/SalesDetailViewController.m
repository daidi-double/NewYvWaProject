//
//  SalesDetailViewController.m
//  YuWa
//
//  Created by double on 17/7/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SalesDetailViewController.h"
#import "SalesShopTableViewCell.h"
#import "SalesDetailTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
#import "PCPayViewController.h"


#import "BeginSalesViewController.h"



#define DETAILCELL @"SalesDetailTableViewCell"
#define SALESSHOPCELL  @"SalesShopTableViewCell"
#define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )//判断是否为苹果5s

@interface SalesDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UILabel *cautionMoneyLabel;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UILabel * headerTitleLabel;
@property (nonatomic,strong)UIView * windowView;//提示窗口

@end

@implementation SalesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
- (void)makeUI{
    self.title = @"竞拍明细";
    self.cautionMoneyLabel.layer.borderColor = CNaviColor.CGColor;
    self.cautionMoneyLabel.layer.borderWidth = 0.3f;
    [self.detailTableView registerNib:[UINib nibWithNibName:SALESSHOPCELL bundle:nil] forCellReuseIdentifier:SALESSHOPCELL];
    [self.detailTableView registerNib:[UINib nibWithNibName:DETAILCELL bundle:nil] forCellReuseIdentifier:DETAILCELL];
    
    [self.view addSubview:self.windowView];
}
//刷新
- (IBAction)refreshAction:(UIButton *)sender {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        SalesShopTableViewCell * saleCell = [tableView dequeueReusableCellWithIdentifier:SALESSHOPCELL];
        saleCell.selectionStyle = NO;
        
        
        return saleCell;
        
    }else{
        SalesDetailTableViewCell * salesCell = [tableView dequeueReusableCellWithIdentifier:DETAILCELL];
        salesCell.selectionStyle = NO;
        if (indexPath.row != 0) {
            salesCell.isNumberOneLabel.hidden = YES;
        }
        
        return salesCell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }
    return 50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (IS_IPHONE5) {
            
            return 240.f;
        }
        return kScreen_Height*454/1334;
      
    }
    return 75.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  nil;
    }else{
        self.headerTitleLabel.text = @"2次参拍 / 2次出价";
        return self.headerView;
    }
}


//竞拍
- (IBAction)toSalesAction:(UIButton *)sender {
    BeginSalesViewController * beginVC = [[BeginSalesViewController alloc]init];
    
    [self.navigationController pushViewController:beginVC animated:YES];
    
}
- (IBAction)moreAction:(UIButton *)sender {

}
- (IBAction)toPayAction:(UIButton *)sender {
    self.windowView.hidden = NO;
}

- (void)cancelWindows{
    self.windowView.hidden = YES;
    
}
- (void)agreementAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

- (void)sureToPay{
    MyLog(@"确定去缴纳");
    self.windowView.hidden = YES;
    PCPayViewController * PCVC = [[PCPayViewController alloc]init];
    PCVC.status = 3;
    [self.navigationController pushViewController:PCVC animated:YES];
}

//竞拍协议
- (void)salesAgreement{
    MyLog(@"竞拍协议");
}
//保证金规则
- (void)cautionedRule{
     MyLog(@"保证金规则");
}
- (UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(12, 49.5, kScreen_Width - 24, 0.5)];
        line.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [_headerView addSubview:line];
        
        UIView * lightLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        lightLine.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [_headerView addSubview:lightLine];
        
    }
    return _headerView;
}

- (UILabel *)headerTitleLabel{
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, kScreen_Width/2, 30)];
        _headerTitleLabel.textColor = LightColor;
        _headerTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.headerView addSubview:_headerTitleLabel];
    }
    return _headerTitleLabel;
}
- (UIView *)windowView{
    if (!_windowView) {
        _windowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _windowView.hidden = YES;
        UIToolbar * tool = [[UIToolbar alloc]initWithFrame:_windowView.bounds];
        tool.alpha = 0.95f;
        tool.barStyle = UIBarStyleBlackTranslucent;
        [_windowView addSubview:tool];
        
        UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(18, 0, kScreen_Width - 36, kScreen_Height * 870/1334)];
        if (IS_IPHONE5) {
            BGView.height = 440.f;
        }
        BGView.centerY = (kScreen_Height-NavigationHeight)/2+30;
        BGView.backgroundColor = [UIColor whiteColor];
        [_windowView addSubview:BGView];
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, kScreen_Width/4, 30)];
        titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"缴纳保证金";
        [BGView addSubview:titleLabel];
      
        
        UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(kScreen_Width -83, 5, 30, 30);
        [cancelBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelWindows) forControlEvents:UIControlEventTouchUpInside];
        [BGView addSubview:cancelBtn];
        
        UIView * lightLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreen_Width-36, 10)];
        lightLine.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [BGView addSubview:lightLine];
        
        
        UILabel * cautionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lightLine.bottom + 30, kScreen_Width/2, 35)];
        cautionTitleLabel.attributedText = [NSString stringWithFirstStr:@"保证金" withFont:[UIFont systemFontOfSize:13] withColor:LightColor withSecondtStr:@"1000" withFont:[UIFont systemFontOfSize:30] withColor:LightColor];
        cautionTitleLabel.centerX = kScreen_Width/2;
        CGRect NameWidth = [cautionTitleLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width/2, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22]} context:nil];
        cautionTitleLabel.width = NameWidth.size.width;
        [BGView addSubview:cautionTitleLabel];
        
        UILabel * RMBLabel = [[UILabel alloc]initWithFrame:CGRectMake(cautionTitleLabel.right, lightLine.bottom + 37, 40, 35)];
        RMBLabel.textColor = LightColor;
        RMBLabel.font = [UIFont systemFontOfSize:13];
        RMBLabel.text = @"RMB";
        [BGView addSubview:RMBLabel];
        CGFloat markHeight = 0.0f;
        NSArray * contentAry = @[@"1.系统将在您的钱包中锁定当前拍卖价10%的保证金",@"2.若竞拍成功，保证金将退到钱包中",@"3.竞拍不成功，保证金将自动返还"];
        for (int i = 0; i<3; i ++) {
            CGFloat labelHeight =[contentAry[i] boundingRectWithSize:CGSizeMake(BGView.width - 72, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size.height;
            
            UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, cautionTitleLabel.bottom + 25+markHeight,BGView.width - 72, labelHeight)];
            textLabel.numberOfLines = 0;
            textLabel.textColor = LightColor;
            textLabel.font = [UIFont systemFontOfSize:13];
            textLabel.text = contentAry[i];
            [BGView addSubview:textLabel];
            markHeight = labelHeight + markHeight+10;
        }
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, cautionTitleLabel.bottom+25 + markHeight+10, BGView.width, 0.5)];
        line.backgroundColor = RGBCOLOR(234, 235, 236, 1);
        [BGView addSubview:line];
        
        UIButton * agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreementBtn setImage:[UIImage imageNamed:@"agreement_nol"] forState:UIControlStateNormal];
        [agreementBtn setImage:[UIImage imageNamed:@"agreement_sel"] forState:UIControlStateSelected];
        agreementBtn.frame = CGRectMake(20, line.bottom + 20, 30, 30);
        [agreementBtn addTarget:self action:@selector(agreementAction:) forControlEvents:UIControlEventTouchUpInside];
        [BGView addSubview:agreementBtn];
        
        UILabel * agereeStrLabel = [[UILabel alloc]initWithFrame:CGRectMake(agreementBtn.right, line.bottom +25, [self getLabelHightOrWidth:@"我同意" andStatus:1 andLabelWidth:0 andLabelHeight:25], 25)];
        agereeStrLabel.centerY = agreementBtn.centerY;
        agereeStrLabel.font = [UIFont systemFontOfSize:13];
        agereeStrLabel.textColor = LightColor;
        agereeStrLabel.text = @"我同意";
        [BGView addSubview:agereeStrLabel];
        
        UILabel * agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(agereeStrLabel.right, agereeStrLabel.y, kScreen_Width/2, 25)];
        agreeLabel.attributedText = [NSString stringWithFirstStr:@"《竞拍协议》" withFont:[UIFont systemFontOfSize:13] withColor:CNaviColor withSecondtStr:@"并支付保证金" withFont:[UIFont systemFontOfSize:13] withColor:LightColor];
        [agreeLabel setUserInteractionEnabled:YES];
        [BGView addSubview:agreeLabel];
        
        UITapGestureRecognizer * agreementTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(salesAgreement)];
        agreementTouch.numberOfTapsRequired = 1;
        agreementTouch.numberOfTouchesRequired = 1;
        agreementTouch.delegate = self;
        [agreeLabel addGestureRecognizer:agreementTouch];
        
        
        UILabel * agreeTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(agereeStrLabel.left, agereeStrLabel.bottom +10, BGView.width-agereeStrLabel.x - 25, 25)];

        agreeTwoLabel.textColor = LightColor;
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"我理解了《保证金详情规则》(因拍品性质特殊，不支持7天无理由退货，请谨慎参拍)"];
        
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 39)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:CNaviColor range:NSMakeRange(4, 9)];
        
        agreeTwoLabel.attributedText = AttributedStr;
        agreeTwoLabel.numberOfLines = 0;
        agreeTwoLabel.userInteractionEnabled = YES;
        agreeTwoLabel.height = [self getLabelHightOrWidth:agreeTwoLabel.text andStatus:0 andLabelWidth:BGView.width-agereeStrLabel.x - 25 andLabelHeight:0];
        [BGView addSubview:agreeTwoLabel];

        UITapGestureRecognizer * ruleTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cautionedRule)];
        ruleTouch.numberOfTapsRequired = 1;
        ruleTouch.numberOfTouchesRequired = 1;
        ruleTouch.delegate = self;
        [agreeTwoLabel addGestureRecognizer:ruleTouch];
        
    
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(20, agreeTwoLabel.bottom+20, BGView.width- 40, 35);
        sureBtn.backgroundColor = CNaviColor;
        [sureBtn setTitle:@"确定缴纳" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureToPay) forControlEvents:UIControlEventTouchUpInside];
        [BGView addSubview:sureBtn];
    }
    return _windowView;
}

- (CGFloat )getLabelHightOrWidth:(NSString * )str andStatus:(NSInteger)status andLabelWidth:(NSInteger)width  andLabelHeight:(NSInteger)height{
    if (status == 0) {//返回高度
        
        CGRect  Rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
        return Rect.size.height;
        
    }else{//返回宽度
        CGRect  Rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
        return Rect.size.width;
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
