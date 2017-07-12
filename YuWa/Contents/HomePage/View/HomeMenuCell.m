//
//  HomeMenuCell.m
//  meituan
//
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "HomeMenuCell.h"
#import "HPCategoryModel.h"


@interface HomeMenuCell ()<UIScrollViewDelegate>
{
    UIView *_backView1;
    UIView *_backView2;
    UIPageControl *_pageControl;
}

@property(nonatomic,strong)NSArray*menuArray;
@end

@implementation HomeMenuCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.menuArray=[menuArray copy];
        
        //
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 160)];
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, 160)];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 180)];
        scrollView.contentSize = CGSizeMake(2*kScreen_Width, 180);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:_backView1];
        [scrollView addSubview:_backView2];
        [self addSubview:scrollView];
        
        //创建20个
//        if (menuArray.count<20) {
//            return self;
//        }
        
        
        for (int i = 0; i < menuArray.count; i++) {
            if (i < 5) {
                HPCategoryModel*model=menuArray[i];
                NSString*title=model.class_name;
                NSString*imageStr=model.img;
                
                CGRect frame = CGRectMake(i*kScreen_Width/5, 0, kScreen_Width/5, 80);
//                NSString *title = [menuArray[i] objectForKey:@"title"];
//                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView1 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
                
            }else if(i<10){
                CGRect frame = CGRectMake((i-5)*kScreen_Width/5, 80, kScreen_Width/5, 80);
                HPCategoryModel*model=menuArray[i];
                NSString*title=model.class_name;
                NSString*imageStr=model.img;
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView1 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }else if(i < 15){
                CGRect frame = CGRectMake((i-10)*kScreen_Width/5, 0, kScreen_Width/5, 80);
                HPCategoryModel*model=menuArray[i];
                NSString*title=model.class_name;
                NSString*imageStr=model.img;
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView2 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }else{
                CGRect frame = CGRectMake((i-15)*kScreen_Width/5, 80, kScreen_Width/5, 80);
                HPCategoryModel*model=menuArray[i];
                NSString*title=model.class_name;
                NSString*imageStr=model.img;
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView2 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
        }
        
        //
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, kScreen_Width, 20)];
//        _pageControl.centerX=kScreen_Width/2;
//        [_pageControl setCenterX:kScreen_Width/2];
//        _pageControl.backgroundColor=[UIColor blueColor];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 2;
//        self.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:CNaviColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _pageControl.frame=CGRectMake(kScreen_Width/2-20, 160, 40,20);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
//    NSLog(@"tag:%ld",sender.view.tag);
    NSInteger number=sender.view.tag-10;
    
    HPCategoryModel*model=self.menuArray[number];
    
    if ([self.delegate respondsToSelector:@selector(DelegateToChooseCategory:andCategoryID:)]) {
        [self.delegate DelegateToChooseCategory:number andCategoryID:model.id];
        
    }
    
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}


@end
