//
//  TableBGView.m
//  YuWa
//
//  Created by double on 17/2/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "TableBGView.h"
#import "CityCodeModel.h"
@interface TableBGView ()<UITableViewDelegate,UITableViewDataSource>
{
   UIView * line;
    NSInteger markTag;
    UIButton * markBtn;
    NSString * markTitle;
}
@property (nonatomic,strong) UITableView * placeTableView;//商圈tableview
@property (nonatomic,strong) UITableView * rightTableView;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,strong)NSMutableArray * cityCodeAry;
@property (nonatomic,assign)NSInteger index;

@end
@implementation TableBGView
- (instancetype)initWithFrame:(CGRect)frame andTag:(NSInteger)tag andTitle:(NSString *)title andIndex:(NSInteger)index andFilmCode:(NSString *)filmCode andCityCode:(NSString *)cityCode{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityCode = @"350500";
        _index = index;
        _staus = tag;
        markTitle = title;
        self.type = @"0";
//        self.cityCode = cityCode;
        self.filmCode = filmCode;
        [self setPlaceBtn];
        [self makeTableView];
        [self getlocatCityCode];
    }
    return self;
}
- (void)setPlaceBtn{
    CGFloat btnWidth = (kScreen_Width - 80 - 100)/2;
    NSArray * title;
    if (self.staus == 1111) {
        title = @[markTitle,@"离我最近"];

    }else{
      title = @[@"全部地区",markTitle];
    }
    for (int i = 0; i<2; i ++) {
        UIButton * placeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        placeBtn.frame = CGRectMake(40 + (100 + btnWidth)*i, 0,btnWidth ,30);
        [placeBtn setTitle:title[i] forState:UIControlStateNormal];
        [placeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        placeBtn.tag = 1111+i;
        [placeBtn setImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        [placeBtn setImage:[UIImage imageNamed:@"dropdown_sel"] forState:UIControlStateSelected];
        [placeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        [placeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
        
        [placeBtn setTitleColor:CNaviColor forState:UIControlStateSelected];
        placeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [placeBtn addTarget:self action:@selector(choosePlace:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:placeBtn];
    }
    line = [[UIView alloc]initWithFrame:CGRectMake(40, 25, btnWidth + 30, 1)];
    if (self.staus == 1111) {
        line.centerX = 40 + btnWidth/2;
        for (UIButton * placeBtn in self.subviews) {
            if (placeBtn.tag == 1111) {
                placeBtn.selected = YES;
                markTitle = placeBtn.titleLabel.text;
            }else{
                placeBtn.selected = NO;
            }
        }
    }else{
        for (UIButton * placeBtn in self.subviews) {
            if (placeBtn.tag == 1112) {
                placeBtn.selected = YES;
                markTitle = placeBtn.titleLabel.text;
            }else{
                placeBtn.selected = NO;
            }
        }
        line.centerX = 40 +btnWidth+100+btnWidth/2;
    }
    line.backgroundColor = CNaviColor;
    
    [self addSubview:line];
}
- (void)makeTableView{
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 1)];
    grayView.backgroundColor = RGBCOLOR(222, 220, 223, 1);
    [self addSubview:grayView];//分割线
    _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30 , kScreen_Width, self.height) style:UITableViewStyleGrouped];
    _placeTableView.delegate = self;
    _placeTableView.dataSource = self;
    
    [self addSubview:_placeTableView];
    self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30 , kScreen_Width, self.height-30) style:UITableViewStyleGrouped];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    [self addSubview:self.rightTableView];

    if (_staus == 1111) {
        self.rightTableView.hidden = YES;

    }else {
        self.placeTableView.hidden = YES;
    }
}

-(void)choosePlace:(UIButton*)sender{
    
    line.centerX = sender.centerX;
    switch (sender.tag) {
        case 1111:
            self.rightTableView.hidden = YES;
            [self.delegate creatPlaceView:sender.tag andTitle:@"全部地区"];
            break;
            
        default:
            
            self.placeTableView.hidden = YES;
            [self.delegate creatPlaceView:sender.tag andTitle:@"离我最近"];
            break;
    }
    
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _placeTableView) {
        return self.cityCodeAry.count;
    }else{
        return 3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _placeTableView) {
        if (self.titleBlock) {
            CityCodeModel * model = self.cityCodeAry[indexPath.row];
            for (UIButton *btn in self.subviews) {
                if (btn.tag == 1111) {
                    [btn setTitle:model.name forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                }
            }
            self.titleBlock(model.name,model.code);
        }
    }else{
        if (self.titleBlockT) {
            NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];;
            for (UIButton *btn in self.subviews) {
                if (btn.tag == 1112) {
                    [btn setTitle:titleArr[indexPath.row] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                }
            }
            NSString * listCode = [NSString stringWithFormat:@"%ld",indexPath.row];
            self.titleBlockT(titleArr[indexPath.row],listCode);
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"placeCell"];
    }

    if (tableView == _placeTableView) {
        cell.backgroundColor = RGBCOLOR(249, 249, 249, 1);
        CityCodeModel * model = self.cityCodeAry[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.name,model.cinema_count];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor= [UIColor colorWithHexString:@"#333333"];
        if ([cell.textLabel.text containsString:markTitle]) {
            cell.textLabel.textColor = CNaviColor;
        }
    }else{
        NSArray *  titleArr = @[@"离我最近",@"价格最低",@"好评优先"];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.centerY = cell.height/2;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor= [UIColor colorWithHexString:@"#333333"];
        if ([cell.textLabel.text containsString:markTitle]) {
            cell.textLabel.textColor = CNaviColor;
        }
        return cell;
    }
    return cell;
}


//获取地区编码
- (void)getlocatCityCode{
    NSString * urlStr;
    NSDictionary * pragrams;
    if (self.index == 0) {
          urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODE];

        pragrams = @{@"area":self.cityCode};
    }else{
         urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MOVIE_CITYCODENEW];
        pragrams = @{@"area":self.cityCode,@"filmCode":self.filmCode};

    }
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"地区编码参数 %@",pragrams);
        MyLog(@"地区编码 %@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.cityCodeAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                CityCodeModel * model = [CityCodeModel yy_modelWithDictionary:dict];
                [self.cityCodeAry addObject:model];
            }
        }else{
            [JRToast showWithText:@"网络超时,请检查网络" duration:1];
        }
        [self.placeTableView reloadData];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (NSMutableArray*)cityCodeAry{
    if (!_cityCodeAry) {
        _cityCodeAry = [NSMutableArray array];
    }
    return _cityCodeAry;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
