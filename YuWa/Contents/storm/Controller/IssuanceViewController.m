//
//  IssuanceViewController.m
//  YuWa
//
//  Created by double on 17/7/5.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "IssuanceViewController.h"
#import "IssuanceProjectTableViewCell.h"
#import "IntroduceTableViewCell.h"
#import "ProjectPhotoTableViewCell.h"

#define PHOTOCELL   @"ProjectPhotoTableViewCell"
#define INTRODUCECELL @"IntroduceTableViewCell"
#define PROJECTCELL @"IssuanceProjectTableViewCell"
@interface IssuanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *issuanceTableView;
@property (nonatomic,strong)NSArray * titleAry;
@property (nonatomic,strong)NSArray * introAry;
@property (nonatomic,strong)UIView * footView;
@end

@implementation IssuanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

-(void)makeUI{
    self.title = @"发布项目";
    self.titleAry = @[@[@"商品名称",@"城市地址:"],@[@"起拍价格:",@"项目标语:",@"发展阶段:"],@[@"商家介绍:"],@[@"产品快照:"],@[@"卖家介绍:"],@[@"商业模式:"],@[@"潜在目标市场(人)",@"潜在市场规模(元)",@"目标市场类型:",@"目标市场类型:"],@[@"商家团队介绍"],@[@"商家优势介绍"],@[@"市场价值(元):",@"预估月收入(元):"],@[@"项目大事件"]];
    self.introAry = @[@[@"请输入商品名称",@"请输入您的所在地"],@[@"请输入您的起拍价格",@"(一句话介绍项目)",@"请选择阶段🔽"],@[@"商家介绍,不得少于200字"],@[@"必须上传至少3张"],@[@"请输入卖家介绍"],@[@"请输入商业模式"],@[@"有多少潜在锁定消费者",@"潜在可锁定消费者一年的总消费能力",@"人群年龄段",@"人群年龄段"],@[@"请输入团队介绍"],@[@"请输入商家优势"],@[@"请输入市场价值",@"请输入预估月收入"],@[@"请输入项目大事件"]];
    [self.issuanceTableView registerNib:[UINib nibWithNibName:PROJECTCELL bundle:nil] forCellReuseIdentifier:PROJECTCELL];
    [self.issuanceTableView registerNib:[UINib nibWithNibName:INTRODUCECELL bundle:nil] forCellReuseIdentifier:INTRODUCECELL];
    [self.issuanceTableView registerNib:[UINib nibWithNibName:PHOTOCELL bundle:nil] forCellReuseIdentifier:PHOTOCELL];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 11;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0||section == 9) {
        return 2;
    }else if (section == 1){
        return 1;
    }else if ((section > 1&&section<6)||(section == 10)||(section == 7||section == 8)){
        return 1;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    self.issuanceTableView.separatorStyle = NO;
    if (indexPath.section == 0||indexPath.section == 1 ||indexPath.section== 4||indexPath.section == 6|| indexPath.section == 9) {
        IssuanceProjectTableViewCell * issuanceCell = [tableView dequeueReusableCellWithIdentifier:PROJECTCELL];
        issuanceCell.titleLabel.text = self.titleAry[indexPath.section][indexPath.row];
        issuanceCell.contentTextFild.placeholder = self.introAry[indexPath.section][indexPath.row];
        issuanceCell.selectionStyle = NO;
        return issuanceCell;
    }else if (indexPath.section !=3 ){
        IntroduceTableViewCell * introCell = [tableView dequeueReusableCellWithIdentifier:INTRODUCECELL];
        introCell.selectionStyle = NO;
        introCell.titleNameLabel.text = self.titleAry[indexPath.section][indexPath.row];
        introCell.explainLabel.text = self.introAry[indexPath.section][indexPath.row];
        return introCell;
    }else{
        ProjectPhotoTableViewCell * photoCell = [tableView dequeueReusableCellWithIdentifier:PHOTOCELL];
        photoCell.selectionStyle = NO;
        return photoCell;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 10) {
        return self.footView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return kScreen_Height*320/1334;
    }else if (indexPath.section == 2){
        return kScreen_Height * 284/1334;
    }else if (indexPath.section == 5||indexPath.section == 10||indexPath.section == 7||indexPath.section == 8){
        return kScreen_Height*340/1334;
    }else{
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 10) {
        return 80.f;
    }else{
        return 0.01f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40.f;
    }else{
        return 20.f;
    }
}
//发布
- (void)subcommitAction{
    MyLog(@"发布");
}
- (UIView*)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
        _footView.backgroundColor = [UIColor clearColor];
        UIButton * subcomitBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        subcomitBtn.frame = CGRectMake(12, 20, kScreen_Width-24, 40);
        [subcomitBtn setTitle:@"发布" forState:UIControlStateNormal];
        subcomitBtn.backgroundColor = CNaviColor;
        subcomitBtn.layer.masksToBounds = YES;
        subcomitBtn.layer.cornerRadius = 5;
        [subcomitBtn addTarget:self action:@selector(subcommitAction) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:subcomitBtn];
    }
    return _footView;
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
