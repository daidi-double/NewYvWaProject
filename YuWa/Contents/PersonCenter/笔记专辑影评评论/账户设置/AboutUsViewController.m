//
//  AboutUsViewController.m
//  YuWa
//
//  Created by double on 17/3/11.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UserAgreenmentViewController.h"
@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * aboutUsTableView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self makeUI];
}

- (void)makeUI{
    _aboutUsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-250) style:UITableViewStylePlain];
    _aboutUsTableView.delegate = self;
    _aboutUsTableView.dataSource = self;
    _aboutUsTableView.scrollEnabled = NO;
    _aboutUsTableView.backgroundColor = [UIColor whiteColor];
    _aboutUsTableView.backgroundColor = RGBCOLOR(250, 245, 253, 1);
    [self.view addSubview:_aboutUsTableView];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height * 0.4f)];
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width * 0.3f, kScreen_Width * 0.3f)];
    //    icon.backgroundColor = [UIColor lightGrayColor];
    icon.center = CGPointMake(kScreen_Width/2, BGView.height/2);
    icon.image = [UIImage imageNamed:@"app_logo"];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 5;
    [BGView addSubview:icon];
    
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    UILabel * appVersion = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    appVersion.centerX = icon.centerX;
    appVersion.centerY = icon.centerY * 1.6f;
    appVersion.textColor = [UIColor darkGrayColor];
    appVersion.font = [UIFont systemFontOfSize:14];
    appVersion.textAlignment = 1;

//    appVersion.text = @"雨娃宝 v1.6 ";
    appVersion.text = [NSString stringWithFormat:@"雨娃宝v%@",localVersion];
    [BGView addSubview:appVersion];
    return BGView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kScreen_Height * 0.4f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    UserAgreenmentViewController * agreeVC = [[UserAgreenmentViewController alloc]init];
        agreeVC.staus = 0;
    [self.navigationController pushViewController:agreeVC animated:YES];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            [alertController addAction:[UIAlertAction actionWithTitle:@"客服热线:4001505599" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIWebView* callWebview =[[UIWebView alloc] init];
                NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:4001505599"]];
                [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                [self.view addSubview:callWebview];
            }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aboutUsCell"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"用户协议";
    }else{
        cell.textLabel.text = @"客服电话";
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
