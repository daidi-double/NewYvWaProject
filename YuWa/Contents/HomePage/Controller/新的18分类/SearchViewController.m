//
//  SearchViewController.m
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SearchViewController.h"
#import "CinemaModel.h"
#import "MovieResultViewController.h"


@interface SearchViewController ()<UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong)UISearchController * searchController;
@property (nonatomic,strong)NSMutableArray * theaterNameAry;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger pagen;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagen = 10;
    self.pages = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeSearchBar];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.searchController.active = true;
    
}



#pragma mark  -----  SearchBar

-(void)makeSearchBar{

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


    //搜索结果 准备跳页
    [self getDatasFromSearch:searchBar.text];
    
}
-(void)dismissVC{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}




//点击搜索
-(void)getDatasFromSearch:(NSString*)str{
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_HOME_CINEMALIST];
    
    NSDictionary * pragrams = @{@"area":self.cityCode,@"type":@"0",@"device_id":[JWTools getUUID],@"typeList":@"0",@"coordinatex":self.coordinatex,@"coordinatey":self.coordinatey,@"search":str};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragrams];
    if ([UserSession instance].isLogin) {
        [dic setValue:[UserSession instance].token forKey:@"toke"];
        [dic setValue:@([UserSession instance].uid) forKey:@"user_id"];
    }
    
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",dic);
        MyLog(@"搜索影院列表 %@",data);
        
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.theaterNameAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                CinemaModel * model = [CinemaModel yy_modelWithDictionary:dict];
                [self.theaterNameAry addObject:model];
            }
            MovieResultViewController * resultVC = [[MovieResultViewController alloc]init];
            [resultVC.dataAry removeAllObjects];
            resultVC.dataAry = self.theaterNameAry;
            [self.navigationController pushViewController:resultVC animated:YES];
            
        }else{
            [JRToast showWithText:@"网络异常,请检查网络" duration:1];
        }

    }];
    

    
    
}
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
- (NSMutableArray *)theaterNameAry{
    if (!_theaterNameAry) {
        _theaterNameAry = [NSMutableArray array];
    }
    return _theaterNameAry;
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
