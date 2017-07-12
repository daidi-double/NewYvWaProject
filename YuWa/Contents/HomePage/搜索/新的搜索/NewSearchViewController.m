//
//  NewSearchViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewSearchViewController.h"
#import "SearchResultsViewController.h"
#import "showResultsViewController.h"

#import "HeaderCollectionReusableView.h"
#import "ResultsCollectionViewCell.h"
#import "ResultsModel.h"
#import "YYCoreData.h"      //存储数据

#import "HPRecommendShopModel.h"

#define SEARCHFILE   @"searchFile.plist"
#define HOTFILE      @"HOTFILE.plist"

#define HEADERVIEW   @"HeaderCollectionReusableView"
#define RESULTSCCELL  @"ResultsCollectionViewCell"
#define FOOTREUSEVIEW  @"FOOTREUSEVIEW"   //就是 那一条线
#define hisTarrCount  10      //历史记录保存的数量；

@interface NewSearchViewController ()<SearchResultsViewControllerDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UISearchController*searchController;
//@property(nonatomic,strong)SearchResultsViewController*SearchResultsVC;  //搜索结果

@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,strong)NSMutableArray*hisTArr;    //数组 用来转化成 model
@property(nonatomic,strong)NSMutableArray*historyArr;   //历史  model
@property(nonatomic,strong)NSMutableArray*hotArr;   //热门   model
@property(nonatomic,strong)NSMutableArray*hotmutableArray;   //数组  不是model
@property (nonatomic, copy) NSString * path;
@end

@implementation NewSearchViewController


-(void)DelegateForReturnRow:(NSString *)idd andText:(NSString *)text{
    
}
-(void)DelegateResignFirstRespon{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

   self.navigationItem.hidesBackButton =YES;
   self.navigationItem.leftBarButtonItem=nil;
    [self makeSearchBar];
    [self setupCollection];
    [self setDatas];
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath1 = [NSString stringWithFormat:@"%@/searchTitle.plist",documentPath];
    self.path = filePath1;
    //拼接要下载在那个地方的路径
//    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath1]) {
//        
//        [[NSFileManager defaultManager] createDirectoryAtPath:filePath1 withIntermediateDirectories:YES attributes:nil error:nil];
//        
//    }else{
        NSLog(@"有这个文件了");
        self.hisTArr = [NSMutableArray arrayWithContentsOfFile:filePath1];
        for (NSString*  str   in self.hisTArr) {
            
            ResultsModel*model=[[ResultsModel alloc]init];
            model.title = str ;
            [self.historyArr addObject:model];
        }
//    }
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
-(void)setDatas{
   YYCoreData*coreData= [YYCoreData shareCoreData];

    
//热门
    self.hotmutableArray=[NSMutableArray arrayWithContentsOfFile:[coreData userResPath:HOTFILE]];
    if (!self.hotmutableArray) {
        self.hotmutableArray=[NSMutableArray array];
        NSDictionary*dict=@{@"title":@"饭店"};
        [self.hotmutableArray addObject:dict];

    }
    
    for (NSDictionary*dict in self.hotmutableArray) {
        ResultsModel*model=[ResultsModel cellModel:dict];
        [self.hotArr addObject:model];
    }
    
     [self.collectionView reloadData];
    
   
    [self getHotDatas];
 
}

-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr=[NSMutableArray array];
    }
    return _historyArr;
}


#pragma mark  --getDatas
-(void)getHotDatas{

    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_HOTSEARCH];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDatasNoHudWithUrl:urlStr withParams:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSString*errorCode=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        if ([errorCode isEqualToString:@"0"]) {
            NSArray*array=data[@"data"];
            self.hotmutableArray=[array mutableCopy];
            NSString*str=[[YYCoreData shareCoreData] userResPath:HOTFILE];
            [self.hotmutableArray writeToFile:str atomically:YES];
            
        }
        
        
    }];
    
    
    
    
}

//点击搜索
-(void)getDatasFromSearch:(NSString*)str{
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME_SEARCH];
    NSDictionary*params=@{@"keyword":str};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*aa=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",aa];
        if ([errorCode isEqualToString:@"0"]) {
            //不是错误
            NSMutableArray*modelArray=[NSMutableArray array];
            NSArray*array=data[@"data"];
            for (NSDictionary*dict in array) {
                HPRecommendShopModel*model=[HPRecommendShopModel yy_modelWithDictionary:dict];
                [modelArray addObject:model];
            }
            
            showResultsViewController*vc=[[showResultsViewController alloc]init];
            vc.ModelArray=modelArray;
            [self.navigationController pushViewController:vc animated:YES];
            

        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
    
    
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.searchController.active = true;

}

-(void)setupCollection{
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    _collectionView.dataSource=self;
//    _collectionView.scrollEnabled=YES;
    _collectionView.alwaysBounceVertical=YES;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview: self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:HEADERVIEW bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERVIEW];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTREUSEVIEW];
    
    [self.collectionView registerClass:[ResultsCollectionViewCell class] forCellWithReuseIdentifier:RESULTSCCELL];
    
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.historyArr.count>0&&self.hotArr.count>0) {
        return 2;
    }else if (self.hisTArr.count==0&&self.hotArr.count==0){
        return 0;
    }
    
    else{
        return 1;
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.historyArr.count<=0) {
        return self.hotArr.count;
    }else{
        if (section==0) {
            return self.historyArr.count;
        }
        return self.hotArr.count;
    }
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ResultsCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:RESULTSCCELL forIndexPath:indexPath];
    if (self.historyArr.count<=0) {
        ResultsModel*model=self.hotArr[indexPath.row];
        [cell cellModel:model];
        
    }else{
        if (indexPath.section==0) {
              ResultsModel*model=self.historyArr[indexPath.row];
            [cell cellModel:model];

        }else{
              ResultsModel*model=self.hotArr[indexPath.row];
              [cell cellModel:model];
        }
        
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.historyArr.count<=0) {
        ResultsModel*model=self.hotArr[indexPath.row];
        self.searchController.searchBar.text=model.title;
//        [self.searchController.searchBar.delegate  searchBarSearchButtonClicked:self.searchController.searchBar];
        [self  searchBarSearchButtonClicked:self.searchController.searchBar];


    }else{
        if (indexPath.section==0) {
            ResultsModel*model=self.historyArr[indexPath.row];
            self.searchController.searchBar.text=model.title;
//           [self.searchController.searchBar.delegate  searchBarSearchButtonClicked:self.searchController.searchBar];
              [self  searchBarSearchButtonClicked:self.searchController.searchBar];
        }else{
            ResultsModel*model=self.hotArr[indexPath.row];
            self.searchController.searchBar.text=model.title;
//            [self.searchController.searchBar.delegate  searchBarSearchButtonClicked:self.searchController.searchBar];
              [self  searchBarSearchButtonClicked:self.searchController.searchBar];
        }

        
        
    }
    
    
    
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (self.historyArr.count>0) {
        switch (indexPath.section) {
            case 0:{
                if ([kind isEqual:UICollectionElementKindSectionFooter]) {
                    UICollectionReusableView*footer=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTREUSEVIEW forIndexPath:indexPath];
                    footer.backgroundColor=RGBCOLOR(229, 229, 229, 1);
                    return footer;

                }
                
        HeaderCollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERVIEW forIndexPath:indexPath];
                header.leftImageView.backgroundColor=[UIColor whiteColor];
                header.leftImageView.image=[UIImage imageNamed:@"时间"];
                header.title.text=@"最近搜索";
                header.rightButton.hidden=NO;
                __weak typeof (self)weakSelf=self;
                header.cleanBlock=^{
                    //清楚历史记录
                    NSFileManager*manager=[NSFileManager defaultManager];
                    [manager removeItemAtPath:self.path error:nil];
                   _historyArr=[NSMutableArray array];
                    _hisTArr=[NSMutableArray array];
                    
                    [weakSelf.collectionView reloadData];
                    
                    
                };
                    return header;
            }
                break;
            case 1:{
                HeaderCollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERVIEW forIndexPath:indexPath];
                header.leftImageView.backgroundColor=[UIColor whiteColor];
                   header.leftImageView.image=[UIImage imageNamed:@"火"];
                header.title.text=@"热门搜索";
                header.rightButton.hidden=YES;
                return header;

                
            }
                break;
     
            default:
                break;
        }
    
        
    }else{
        
        HeaderCollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERVIEW forIndexPath:indexPath];
        header.leftImageView.backgroundColor=[UIColor whiteColor];
        header.leftImageView.image=[UIImage imageNamed:@"火"];
        header.title.text=@"热门搜索";
        header.rightButton.hidden=YES;
        return header;

    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreen_Width, 44);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.historyArr.count>0) {
        return CGSizeMake(kScreen_Width, 1);
    }
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ResultsCollectionViewCell*cell=[[ResultsCollectionViewCell alloc]init];
    if (self.historyArr.count<=0) {
        ResultsModel*model=self.hotArr[indexPath.row];
        [cell cellModel:model];
        [cell layoutIfNeeded];
        CGRect frame = cell.frame;
        return frame.size;

    }else{
        
        if (indexPath.section==1) {
            ResultsModel*model=self.hotArr[indexPath.row];
            [cell cellModel:model];
            [cell layoutIfNeeded];
            CGRect frame = cell.frame;
            return frame.size;

        }else{
            ResultsModel*model=self.historyArr[indexPath.row];
            [cell cellModel:model];
            [cell layoutIfNeeded];
            CGRect frame = cell.frame;
            return frame.size;

        }
        
    }
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 30, 12, 30);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}



#pragma mark  -----  SearchBar

-(void)makeSearchBar{
//    SearchResultsViewController*vc=[[SearchResultsViewController alloc]init];
////    self.SearchResultsVC=vc;
//    vc.delegate=self;
    
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate=self;
//    self.searchController.searchResultsUpdater=self;
    self.searchController.delegate=self;
    self.searchController.dimsBackgroundDuringPresentation=NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.definesPresentationContext=YES;
    CGRect rect=CGRectMake(self.searchController.searchBar.x, self.searchController.searchBar.y, self.searchController.searchBar.width, self.searchController.searchBar.height);
    self.searchController.searchBar.frame=rect;
    self.navigationItem.titleView=self.searchController.searchBar;

  
}



- (void)WillPresentSearchController:(UISearchController *)searchController{
    
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    
    for (id searchbuttons in [[_searchController.searchBar subviews][0] subviews]){ //只需在此处修改即可
        
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            
            UIButton *cancelButton = (UIButton*)searchbuttons;
            
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            
        }
        
    }
    
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    [UIView animateWithDuration:0.1 animations:^{} completion:^(BOOL finished) {
        [self.searchController.searchBar becomeFirstResponder];
    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissVC];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

//键盘的搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    int a = 0 ;
    for (NSString * str  in self.hisTArr) {
        if ([str isEqualToString:searchBar.text]) {
             a = 1;
            //说明历史搜索已经有这个关键字了
        }
    }
    if (a != 1) {
        //吧这个存进去
        [self.hisTArr addObject:searchBar.text];
            if (self.hisTArr.count>hisTarrCount) {
//                [self.hisTArr removeObject:@0];
                [self.hisTArr removeObject:self.hisTArr[0]];
            }

        [self.hisTArr writeToFile:self.path atomically:YES];
    }
//   [self saveHistoryDatas:searchBar.text];
    //搜索结果 准备跳页
    [self getDatasFromSearch:searchBar.text];
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"1xxx");
}

-(void)dismissVC{

    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark  ----  CoreData
-(void)saveHistoryDatas:(NSString*)text{
    for (int i=0; i<self.hisTArr.count; i++) {
        if ([[self.hisTArr[i] valueForKey:@"title"] isEqual:text] == YES)
        {
            [self.hisTArr removeObject:self.hisTArr[i]];
        }
    }
    
    NSDictionary*dict=@{@"title":text};
    [self.hisTArr addObject:dict];
    
    NSString*str=[[YYCoreData shareCoreData] userResPath:SEARCHFILE];
    [self.hisTArr writeToFile:str atomically:YES];
    
    self.hisTArr=[NSMutableArray arrayWithContentsOfFile:str];
    if (!self.hisTArr) {
        self.hisTArr=[NSMutableArray array];
    }
    
    self.historyArr=[NSMutableArray array];

    
    for (NSDictionary*dict in self.hisTArr) {
        ResultsModel *model=[ResultsModel cellModel:dict];
        [self.historyArr addObject:model];
        
    }
    
    [self.collectionView reloadData];
}


#pragma mark  --- delegate

//-(void)DelegateForReturnRow:(NSString *)idd andText:(NSString *)text{
//    
//    //要储存搜索结果
//    [self saveHistoryDatas:text];
//    //搜索结果 准备跳页
//    [self getDatasFromSearch:text];
//
//
//
//}
//-(void)DelegateResignFirstRespon{
//     [self.searchController.searchBar resignFirstResponder];
//}



#pragma mark --- keyboard
//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
     [self.searchController.searchBar resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
     [self.searchController.searchBar resignFirstResponder];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

-(NSMutableArray *)hotArr{
    
    if (!_hotArr) {
        _hotArr=[NSMutableArray array];
    }
    return _hotArr;
}
-(NSMutableArray *)hisTArr{
    if (!_hisTArr) {
        _hisTArr = [NSMutableArray array ];
    }
    return _hisTArr;
}

@end
