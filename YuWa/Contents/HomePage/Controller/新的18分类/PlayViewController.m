//
//  PlayViewController.m
//  YuWa
//
//  Created by double on 17/2/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayMovieCell.h"
//#import <AVKit/AVKit.h>
//#import <AVFoundation/AVFoundation.h>
@interface PlayViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic,strong)UITableView * playTableView;
@property (nonatomic,strong)NSMutableArray * tableViewDataArr;

@end

@implementation PlayViewController
- (NSMutableArray*)tableViewDataArr{
    if (!_tableViewDataArr) {
        _tableViewDataArr = [NSMutableArray array];
        //

        NSArray * ary = @[@"终极",@"时长",@"极限特工",@"100人想看"];
        [_tableViewDataArr addObjectsFromArray:ary];
        //
    }
    return _tableViewDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //播放界面
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    _playTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _playTableView.delegate = self;
    _playTableView.dataSource = self;
    
    [self.view addSubview:_playTableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIWebView *myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height/3)];
//
    if (section == 0) {
        
//        NSURL *url = [NSURL URLWithString:@""];
        
        UIWebView *myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height/3)];
        
        NSURL *url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XMjUxNjg2MjEyNA==.html?spm=a2h1n.8261147.reload_41.1~3!7~A"];
        // http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8//这里也可以是 mp4
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [myWeb setDelegate:self];
        
        [myWeb loadRequest:request];
        
        return myWeb;
        
        
        
//        AVPlayerViewController * playVC = [[AVPlayerViewController alloc]init];
//        playVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Width * 0.25f);
//        AVPlayer * play = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"]]];
//        playVC.allowsPictureInPicturePlayback  = YES;
//        
//        playVC.videoGravity =AVLayerVideoGravityResizeAspect;
//        playVC.player = play;
//        [self addChildViewController:playVC];
//        [playVC didMoveToParentViewController:self];
//        
//        [playVC player];
//        return playVC.view;
        
    }else{
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kScreen_Height/3;
        
    }else{
        return 0.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moviePlayCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"moviePlayCell"];
    }
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell.textLabel.text = self.tableViewDataArr[1];
        cell.detailTextLabel.text = self.tableViewDataArr[2];
        
    }else if (indexPath.section == 2){
        if ( indexPath.row == 0) {
            cell.textLabel.text = @"共50部";
        }else{
        PlayMovieCell * cell = [[PlayMovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playMovieCell"];
        return cell;
    
        }
    }
    return cell;
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
