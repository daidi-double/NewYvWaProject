//
//  YWBaoBaoViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/11/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBaoBaoViewController.h"
#import "YWPayAnalysisViewController.h"
#import "YWForRecommendViewController.h"
#import "CouponViewController.h"
#import "BaobaoSkillViewController.h"
@interface YWBaoBaoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *BGView;
@property (weak, nonatomic) IBOutlet UIView *LVView;
@property (weak, nonatomic) IBOutlet UIView *showLVView;
@property (weak, nonatomic) IBOutlet UILabel *showLVLabel;
@property (weak, nonatomic) IBOutlet UIImageView *LVShowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *skillView;
@property (weak, nonatomic) IBOutlet UIButton *catchBabyBtn;

@property (weak, nonatomic) IBOutlet UIImageView *baobaoLVUpImageView;

@property (weak, nonatomic) IBOutlet UIButton *LVUpBtn;

@property (nonatomic,strong)UserSession * user;
@property (nonatomic,strong)NSMutableArray * baobaoGifArr;
@property (nonatomic,strong)NSMutableArray * baobaoBGGifArr;
@property (nonatomic,strong)NSMutableArray * baobaoLVUpGifArr;

@end

@implementation YWBaoBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSet];
    [self makeUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dataSet{
    self.user = [UserSession instance];
    self.baobaoGifArr = [NSMutableArray arrayWithCapacity:0];
    self.baobaoBGGifArr = [NSMutableArray arrayWithCapacity:0];
    self.baobaoLVUpGifArr = [NSMutableArray arrayWithCapacity:0];
}
- (void)makeUI{
    self.LVView.layer.borderColor = [UIColor colorWithHexString:@"#2f5bbe"].CGColor;
    self.LVView.layer.borderWidth = 2.f;
    self.LVView.layer.cornerRadius = 11.f;
    self.LVView.layer.masksToBounds = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.skillView.height = 20.f * kScreen_Width / 375.f;
        self.skillView.y = self.skillView.y - self.skillView.height + 20.f ;
    });
    
    [self showLvInfo];
}

- (void)showLvInfo{
    self.showLVLabel.text = [NSString stringWithFormat:@"%zi/%zi",self.user.baobaoEXP,self.user.baobaoNeedEXP];
    self.LVShowImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"baobaoLV%zi",(self.user.baobaoLV - 1)]];
    self.skillView.image = [UIImage imageNamed:[NSString stringWithFormat:@"baobaoSkill%zi",(self.user.baobaoLV - 1)]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//经验槽
        self.showLVView.x = ((kScreen_Width - 52.f - 87.f)*(self.user.baobaoEXP>=self.user.baobaoNeedEXP?1.f:([[NSString stringWithFormat:@"%zi",self.user.baobaoEXP] floatValue])/[[NSString stringWithFormat:@"%zi",self.user.baobaoNeedEXP] floatValue]));
    });

    for (int i = 0; i<self.user.baobaoLV; i++) {//技能栏
        UIButton * skillBtn = [self.view viewWithTag:(i+1)];
        [skillBtn setUserInteractionEnabled:YES];
        skillBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        [skillBtn setTitleColor:[UIColor colorWithHexString:@"#afe5ff"] forState:UIControlStateNormal];
    }
    
    [self.LVUpBtn setUserInteractionEnabled:(self.user.baobaoEXP >= self.user.baobaoNeedEXP?YES:NO)];
    
    //Gif动画
//    self.baobaoImageView.animationImages = self.baobaoGifArr;
//    self.baobaoImageView.animationDuration = 3;
//    self.baobaoImageView.animationRepeatCount = 0;
//    [self.baobaoImageView startAnimating];
    NSInteger lvCount = [UserSession instance].baobaoLV - 1;
    [self.baobaoBGGifArr removeAllObjects];
    for (int i=1; i<60; i++) {
        NSString * path= [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%zibaobaoBG%zi@2x",lvCount,i] ofType:@"jpg"];
        if (path) {
            if (self.baobaoBGGifArr.count>i) {
                [self.baobaoBGGifArr replaceObjectAtIndex:i withObject:[UIImage imageWithContentsOfFile:path]];
            }else{
                [self.baobaoBGGifArr addObject:[UIImage imageWithContentsOfFile:path]];
            }
        }
    }
    
    self.BGView.animationImages = self.baobaoBGGifArr;
    self.BGView.animationDuration = 3;
    self.BGView.animationRepeatCount = 0;
    [self.BGView startAnimating];
}


- (IBAction)catchBaby:(UIButton *)sender {
    BaobaoSkillViewController * catchVC = [[BaobaoSkillViewController alloc]init];
    [self.navigationController pushViewController:catchVC animated:YES];
}

- (IBAction)lvUpAction:(id)sender {
    if (self.user.baobaoLV>4)return;
    [self.LVUpBtn setUserInteractionEnabled:NO];
    [self requestLvUP];
}

- (IBAction)skillAction:(UIButton *)sender {
    if (sender.tag == 1) {
        YWForRecommendViewController * vc = [[YWForRecommendViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2) {
        YWPayAnalysisViewController * vc = [[YWPayAnalysisViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag>2) {
        [self requestLottery];
    }
}

- (void)lvUpGifShow{
    [self.BGView stopAnimating];
    self.baobaoLVUpImageView.hidden = NO;
    self.baobaoLVUpImageView.animationImages = self.baobaoLVUpGifArr;//Gif动画
    self.baobaoLVUpImageView.animationDuration = 3;
    self.baobaoLVUpImageView.animationRepeatCount = 1;
    [self.baobaoLVUpImageView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.baobaoLVUpImageView.hidden = YES;
        self.baobaoLVUpImageView.animationImages = nil;
        [self.baobaoLVUpImageView stopAnimating];
        [self.baobaoLVUpGifArr removeAllObjects];
    });
}

#pragma mark - Http
- (void)requestLvUP{
    if (self.user.baobaoEXP < self.user.baobaoNeedEXP){
        [self.LVUpBtn setUserInteractionEnabled:YES];
        return;
    }
    if (self.user.baobaoLV>=5) {
        [self showHUDWithStr:@"已经是最高级了哟" withSuccess:NO];
        [self.LVUpBtn setUserInteractionEnabled:YES];
        return;
    }
    
    NSInteger lvCount = [UserSession instance].baobaoLV;
    
    for (int i=0; i<60; i++) {
        NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%zibaobaoLVUP%zi@2x",lvCount,i] ofType:@"jpg"];
        if (path) {
            if (self.baobaoLVUpGifArr.count>i) {
                [self.baobaoLVUpGifArr replaceObjectAtIndex:i withObject:[UIImage imageWithContentsOfFile:path]];
            }else{
                [self.baobaoLVUpGifArr addObject:[UIImage imageWithContentsOfFile:path]];
            }
        }
    }
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    [[HttpObject manager]postNoHudWithType:YuWaType_BAOBAO_LVUP withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSDictionary * dataDic = responsObj[@"data"];
        self.user.baobaoLV = [dataDic[@"level"] integerValue];
        [UserSession instance].baobaoLV = self.user.baobaoLV;
        self.user.baobaoEXP = [dataDic[@"energy"] integerValue];
        NSInteger needExp = [dataDic[@"update_level_energy"] integerValue];
        self.user.baobaoNeedEXP = needExp?needExp>0?needExp:13500:13500;
        [self.LVUpBtn setUserInteractionEnabled:YES];
        [self lvUpGifShow];
        [self showLvInfo];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self.LVUpBtn setUserInteractionEnabled:YES];
    }];
}

- (void)requestLottery{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_BAOBAO_LuckyDraw withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if ([responsObj[@"msg"] isEqualToString:@"恭喜您，中奖啦！"]) {
            UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"查看优惠券" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CouponViewController * vc = [[CouponViewController alloc]init];
                vc.shopID = @"0";
                [self.navigationController pushViewController:vc animated:YES];
            }];
            NSDictionary * dataDic = responsObj[@"data"];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:responsObj[@"msg"] message:[NSString stringWithFormat:@"满%@减%@元\n%@",dataDic[@"min_fee"],dataDic[@"discount_fee"],dataDic[@"name"]] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:cancelAction];
            [alertVC addAction:OKAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [self showHUDWithStr:@"本周次数已用光" withSuccess:NO];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        if (responsObj[@"errorMessage"]&&[responsObj[@"errorMessage"] isEqualToString:@"本周抽奖次数已经用完"]) {
            [self showHUDWithStr:@"本周抽奖次数已经用完" withSuccess:NO];
        }
    }];
}


@end
