//
//  YWSalesroomViewController.m
//  YuWa
//
//  Created by double on 17/6/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWSalesroomViewController.h"
#import "YWBarnerTableViewCell.h"
#import "YWHotProjectTableViewCell.h"
#import "YWStarCollectionViewCell.h"
#import "YWShopPlanViewController.h"//商业计划书
#import "YWAllProjectViewController.h"//全部项目


#import "IssuanceViewController.h"//发布项目



#define STARCOLLECTVIEWCELL @"YWStarCollectionViewCell"
#define HOTPROJECTCELL @"YWHotProjectTableViewCell"
#define BARNERCELL  @"YWBarnerTableViewCell"
@interface YWSalesroomViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YWHotProjectTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabbleViews;
@property (nonatomic,strong)UICollectionView * starCollectView;
@property (nonatomic,strong)UIView * footView;
@property (nonatomic,strong)UIView * headerView;
@end

@implementation YWSalesroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self makeUI];
}
- (void)makeUI{
    
    [self.navigationItem setTitle:@"美食项目专场"];
    [self.tabbleViews registerNib:[UINib nibWithNibName:HOTPROJECTCELL bundle:nil] forCellReuseIdentifier:HOTPROJECTCELL];
    UIBarButtonItem * searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_homepage_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchProject)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
}
- (void)searchProject{
    MyLog(@"搜索项目");
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 1) {
        return 1;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        YWBarnerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:BARNERCELL];
        if (!cell) {
            cell = [[YWBarnerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BARNERCELL];
        }
        
        return cell;
    }else {
        YWHotProjectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HOTPROJECTCELL];
        cell.selectionStyle = NO;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kScreen_Height*352/1334;
    }else{
        if (kScreen_Height*634/1334 < 370) {
            return 370;
        }
        return kScreen_Height*634/1334 < 370;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height*300/1334;
    }
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.footView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.headerView;
    }
    return nil;
}
- (void)toLookAll{
    MyLog(@"查看全部");
    
    /*
     暂时
     */
    IssuanceViewController * vc = [[IssuanceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWStarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:STARCOLLECTVIEWCELL forIndexPath:indexPath];
  
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen_Width-32)/4, kScreen_Height * 220/1334);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 8, 0, 8);
}

- (void)toAllProject{
    MyLog(@"全部项目");
    YWAllProjectViewController * allVC = [[YWAllProjectViewController alloc]init];
    [self.navigationController pushViewController:allVC animated:YES];
}
//商业计划书
- (void)toShopPlanPage:(UIButton *)sender{
    YWHotProjectTableViewCell * cell = (YWHotProjectTableViewCell*)[[sender superview] superview];
    NSIndexPath * indexPath = [self.tabbleViews indexPathForCell:cell];
    MyLog(@"%ld~~%ld",indexPath.section,indexPath.row);
    //添加数据
    YWShopPlanViewController * planVC = [[YWShopPlanViewController alloc]init];
    [self.navigationController pushViewController:planVC animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (UIView*)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height*300/1334)];
        _footView.backgroundColor = [UIColor whiteColor];
        UILabel * sectionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width/4, 25)];
        sectionNameLabel.centerY = 20;
        sectionNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        sectionNameLabel.font = [UIFont systemFontOfSize:15];
        sectionNameLabel.text = @"投资明星";
        [_footView addSubview:sectionNameLabel];
        
        UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.frame = CGRectMake(kScreen_Width*0.7f, 0, kScreen_Width*0.25f, 40);
        [allBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [allBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
        [allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [allBtn addTarget:self action:@selector(toLookAll) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:allBtn];
        
        //划分线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(12, allBtn.bottom, kScreen_Width-24, 0.5)];
        line.backgroundColor = RGBCOLOR(240, 241, 242, 1);
        [_footView addSubview:line];
        
        //明星
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        
        _starCollectView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, line.bottom+5, kScreen_Width, _footView.height - allBtn.height - line.height-5) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _starCollectView.delegate = self;
        _starCollectView.dataSource = self;
        _starCollectView.showsHorizontalScrollIndicator = NO;
        _starCollectView.contentSize = CGSizeMake(kScreen_Width*1.5, _footView.height - allBtn.height - line.height-10);
        _starCollectView.backgroundColor = [UIColor whiteColor];
        [_footView addSubview:_starCollectView];
        
        [_starCollectView registerNib:[UINib nibWithNibName:STARCOLLECTVIEWCELL bundle:nil] forCellWithReuseIdentifier:STARCOLLECTVIEWCELL];
        
    }
    return _footView;
}
- (UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [_headerView addSubview:bgView];
        UILabel * sectionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreen_Width/4, 25)];
        sectionNameLabel.centerY = 20;
        sectionNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        sectionNameLabel.font = [UIFont systemFontOfSize:15];
        sectionNameLabel.text = @"热门项目";
        [bgView addSubview:sectionNameLabel];
        
        UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allBtn.frame = CGRectMake(kScreen_Width*0.7f, 0, kScreen_Width*0.25f, 40);
        [allBtn setTitle:@"全部项目" forState:UIControlStateNormal];
        [allBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
        [allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [allBtn addTarget:self action:@selector(toAllProject) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:allBtn];
        

        
    }
   return _headerView;
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
