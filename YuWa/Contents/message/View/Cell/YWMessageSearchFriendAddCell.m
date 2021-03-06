//
//  YWMessageSearchFriendAddCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageSearchFriendAddCell.h"


@implementation YWMessageSearchFriendAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 17.f;
    self.iconImageView.layer.masksToBounds = 4;
    self.addFriends.layer.cornerRadius =4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(YWMessageSearchFriendAddModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.nickName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.header_img] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
}
- (IBAction)addFriends:(UIButton *)sender {
//    EMError *error = [[EMClient sharedClient].contactManager addContact:self.HXName message:@"我想加您为好友"];
//    if (!error) {
//        MyLog(@"添加成功");
//        [JRToast showWithText:@"等待回复" duration:2];
//        [sender setTitle:@"等待回复" forState:0];
//        
//    }
      [self.delegate addFriendAction];
}

@end
