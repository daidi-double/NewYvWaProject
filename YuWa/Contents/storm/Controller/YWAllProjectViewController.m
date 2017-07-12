//
//  YWAllProjectViewController.m
//  YuWa
//
//  Created by double on 17/6/28.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWAllProjectViewController.h"
#import "YWHotProjectTableViewCell.h"
#import "YWSiftCollectionViewCell.h"


#define SIFTCELL @"YWSiftCollectionViewCell"
#define PROJECTCELL  @"YWHotProjectTableViewCell"
@interface YWAllProjectViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIButton * markBarBtn;

}
@property (weak, nonatomic) IBOutlet UITableView *tableViews;
@property (nonatomic,strong)UIView * chooseView;//筛选view
@property (nonatomic,strong)UICollectionView * itemCollectView;
//状态cell
@property (nonatomic, strong) YWSiftCollectionViewCell *stausCell;
//阶段cell
@property (nonatomic, strong) YWSiftCollectionViewCell *stageClee;
//类别cell
@property (nonatomic, strong) YWSiftCollectionViewCell *typeCell;
@end

@implementation YWAllProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部项目";
    [self makeUI];
}
- (void)makeUI{

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn addTarget:self action:@selector(searchProject) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"search_Nav_white"] forState:UIControlStateNormal];
    
    [searchBtn sizeToFit];
    
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn addTarget:self action:@selector(chooseProject:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn setImage:[UIImage imageNamed:@"filtertBtn_normal_white"] forState:UIControlStateNormal];
    
    [chooseBtn sizeToFit];
    UIBarButtonItem *chooseBtnItem = [[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    
    NSArray * btnAry = @[chooseBtnItem,searchBtnItem];
    self.navigationItem.rightBarButtonItems = btnAry;
    
    [self.tableViews registerNib:[UINib nibWithNibName:PROJECTCELL bundle:nil] forCellReuseIdentifier:PROJECTCELL];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        YWHotProjectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PROJECTCELL];
        
        return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        if (kScreen_Height*634/1334 < 370) {
            return 370;
        }
        return kScreen_Height*634/1334 < 370;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01f;
}

//筛选部分
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section != 2) {
        return 4;
    }
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWSiftCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SIFTCELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text = @"全部";
        if (indexPath.item == 0) {
            cell.selected = YES;
            cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            cell.nameLabel.textColor = RGBCOLOR(123, 124, 125, 1);
            if (indexPath.section == 0) {
                self.stausCell = cell;
            }
            if (indexPath.section == 1) {
                self.stageClee = cell;
            }
            if (indexPath.section == 2) {
                self.typeCell = cell;
            }
        }
//    [_itemCollectView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}
/**************修改选中cell的背景颜色*******************/
// cell点击变色
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}
//选中时的操作
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YWSiftCollectionViewCell *cell = (YWSiftCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section== 0) {
    [self updateCellStatus:self.stausCell selected:NO itemAtIndexPath:indexPath];
        self.stausCell = cell;
    }
    if (indexPath.section== 1) {
        [self updateCellStatus:self.stageClee selected:NO itemAtIndexPath:indexPath];
        self.stageClee = cell;
    }
    if (indexPath.section== 2) {
        [self updateCellStatus:self.typeCell selected:NO itemAtIndexPath:indexPath];
        self.typeCell = cell;
    }


//    cell.backgroundColor = [UIColor whiteColor];
    
    //选中之后的cell变颜色
    [self updateCellStatus:cell selected:YES itemAtIndexPath:indexPath];
}

//取消选中操作
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    YWSiftCollectionViewCell *cell = (YWSiftCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//
//
//    [self updateCellStatus:cell selected:NO itemAtIndexPath:indexPath];
//}
// 改变cell的背景颜色
-(void)updateCellStatus:(YWSiftCollectionViewCell *)cell selected:(BOOL)selected itemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = selected ? [UIColor colorWithHexString:@"#ffffff"]:[UIColor clearColor];
    cell.nameLabel.textColor = selected?RGBCOLOR(123, 124, 125, 1):[UIColor colorWithHexString:@"#ffffff"];
    cell.layer.borderWidth = selected ? 0:0.3;
    cell.layer.borderColor= [UIColor colorWithHexString:@"#ffffff"].CGColor;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 2) {
        return CGSizeMake((kScreen_Width-100)/4, 25);
    }
    return CGSizeMake((kScreen_Width-86)/3, 25);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 30, 17, 30);
}
//同一行相邻cell间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}
//同一列相邻cell间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 17;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    
        header.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, 8, 23)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [header addSubview:whiteView];
        UILabel * labelOne = [[UILabel alloc]initWithFrame:CGRectMake(whiteView.right+10, 0, 55, 30)];
        labelOne.centerY = whiteView.centerY;
        labelOne.text =@"状态";
        labelOne.font = [UIFont systemFontOfSize:15.0f];
        labelOne.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [header addSubview:labelOne];
    }else if (indexPath.section == 1){
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(12, 10, 8, 23)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [header addSubview:whiteView];
        UILabel * labelOne = [[UILabel alloc]initWithFrame:CGRectMake(whiteView.right+10, 0, 55, 30)];
        labelOne.centerY = whiteView.centerY;
        labelOne.text =@"阶段";
        labelOne.font = [UIFont systemFontOfSize:15.0f];
        labelOne.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [header addSubview:labelOne];
    }else{
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, 8, 23)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [header addSubview:whiteView];
        UILabel * labelOne = [[UILabel alloc]initWithFrame:CGRectMake(whiteView.right+10, 0, 55, 30)];
        labelOne.centerY = whiteView.centerY;
        labelOne.text =@"类别";
        labelOne.font = [UIFont systemFontOfSize:15.0f];
        labelOne.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [header addSubview:labelOne];
    }
    return header;
}
- (void)searchProject{
    MyLog(@"搜索项目");
}
- (void)chooseProject:(UIButton *)sender{
    MyLog(@"筛选");
    if (_chooseView == nil) {
        [self.view addSubview:self.chooseView];
    }
    sender.selected = !sender.selected;
    markBarBtn = sender;
    if (sender.selected) {
        
        self.chooseView.hidden = NO;
    }else{
        self.chooseView.hidden = YES;
    }
}
- (void)cancelBGView{
//    _chooseView.hidden = YES;
//    markBarBtn.selected = !markBarBtn.selected;
}
- (UIView *)chooseView{
    if (!_chooseView) {
        _chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationHeight, kScreen_Width, kScreen_Height)];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, _chooseView.height)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.alpha = 0.95;
        _chooseView.hidden = YES;
        [_chooseView addSubview:toolbar];
        
//        UITapGestureRecognizer * cancelTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBGView)];
//        cancelTouch.numberOfTapsRequired = 1;
//        cancelTouch.numberOfTouchesRequired = 1;
//        cancelTouch.delegate = self;
//        [_chooseView addGestureRecognizer:cancelTouch];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.headerReferenceSize =CGSizeMake(kScreen_Width,30);//头视图大小
        _itemCollectView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, _chooseView.height) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _itemCollectView.delegate = self;
        _itemCollectView.dataSource = self;
        _itemCollectView.showsHorizontalScrollIndicator = NO;
        _itemCollectView.contentSize = CGSizeMake(kScreen_Width, _chooseView.height);
        _itemCollectView.backgroundColor = [UIColor clearColor];
        [_chooseView addSubview:_itemCollectView];
        [_itemCollectView registerClass:[YWSiftCollectionViewCell class] forCellWithReuseIdentifier:SIFTCELL];
//         _itemCollectView.allowsMultipleSelection =YES;//多选
   [_itemCollectView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    }
    return _chooseView;
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
