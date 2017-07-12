//
//  JRSegmentViewController.m
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import "JRSegmentViewController.h"

@interface JRSegmentViewController () <UIScrollViewDelegate, JRSegmentControlDelegate>
{
    CGFloat vcWidth;  // 每个子视图控制器的视图的宽
    CGFloat vcHeight; // 每个子视图控制器的视图的高
    
    JRSegmentControl *segment;
    
    BOOL _isDrag;
    
    NSInteger indexSelected;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JRSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indexSelected=0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupScrollView];
    [self setupViewControllers:0];
    [self setupSegmentControl];
    
//默认选中的是0
 
     [segment setSelectedIndex:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)itemWidth
{
    if (_itemWidth == 0) {
        _itemWidth = 60.0f;
    }
    return _itemWidth;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0) {
        _itemHeight = 30.0f;
    }
    return _itemHeight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/** 设置scrollView */
- (void)setupScrollView
{
 

    
    CGFloat Y = 0.0f;
    if (self.navigationController != nil && ![self.navigationController isNavigationBarHidden]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        Y = 64.0f;
    }
    
    vcWidth = self.view.frame.size.width;
    vcHeight = self.view.frame.size.height - Y;
    
    if (self.navigationController.tabBarController.tabBar!=nil&&self.navigationController.tabBarController.tabBar.hidden==NO) {
        vcHeight = vcHeight-49;
    }
    
  
       UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, Y, vcWidth, vcHeight)];
     scrollView.contentSize = CGSizeMake(vcWidth * self.viewControllers.count, vcHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    scrollView.bounces=NO;
    scrollView.scrollEnabled=self.enableScroll;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/** 设置子视图控制器，这个方法必须在viewDidLoad方法里执行，否则子视图控制器各项属性为空 */
- (void)setupViewControllers:(NSInteger)index
{
//    int cnt = (int)self.viewControllers.count;
//    for (int i = 0; i < cnt; i++) {
//        UIViewController *vc = self.viewControllers[i];
//        [self addChildViewController:vc];
//        
//        vc.view.frame = CGRectMake(vcWidth * i, 0, vcWidth, vcHeight);
//        [self.scrollView addSubview:vc.view];
//    }
    
    if (![self.childViewControllers containsObject:self.viewControllers[index]]) {
        UIViewController *vc = self.viewControllers[index];
        [self addChildViewController:vc];

        vc.view.frame = CGRectMake(vcWidth * index, 0, vcWidth, vcHeight);
        [self.scrollView addSubview:vc.view];
//        [self.viewControllers replaceObjectAtIndex:index withObject:@"11"];
        
        
        
        
    }
    
}

/** 设置segment */
- (void)setupSegmentControl
{
    _itemWidth = 60.0f;
    // 设置titleView
    segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth *self.viewControllers.count, 30.0f)];
    segment.titles = self.titles;
    segment.cornerRadius = 5.0f;
    segment.titleColor = self.titleColor;
    segment.indicatorViewColor = self.indicatorViewColor;
    segment.backgroundColor = self.segmentBgColor;
    //选中的颜色
    segment.selectedColor=self.selectedColor;
    
    
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}

/**    能否滚动     */
-(void)setEnableScroll:(BOOL)enableScroll{
    _enableScroll=enableScroll;
//    self.scrollView.scrollEnabled=_enableScroll;
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [segment selectedBegan];
    _isDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        
        [segment setIndicatorViewPercent:percent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [segment selectedEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    //懒加载视图
     [self setupViewControllers:index];
    
    [segment setSelectedIndex:index];
    _isDrag = NO;
    
   
    indexSelected=index;
    
    NSArray*vcs=self.childViewControllers;
    UIViewController*vc=vcs[index];
    [vc viewWillAppear:NO];
    //这句话的意义。   vc控制器可以直接写 self。navigationItem  而不是要self。parentController 虽然相等
    self.navigationItem.rightBarButtonItem=vc.navigationItem.rightBarButtonItem;
   
   
    
    
}

#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index {
    //懒加载视图
     [self setupViewControllers:index];
    
    CGFloat X = index * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(X, 0) animated:YES];
    
    
    indexSelected=index;
    
    NSArray*vcs=self.childViewControllers;
    UIViewController*vc=vcs[index];
    [vc viewWillAppear:NO];
     //这句话的意义。   vc控制器可以直接写 self。navigationItem  而不是要self。parentController 虽然相等
    self.navigationItem.rightBarButtonItem=vc.navigationItem.rightBarButtonItem;
   
   
}



@end
