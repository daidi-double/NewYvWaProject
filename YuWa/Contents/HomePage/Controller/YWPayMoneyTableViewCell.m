//
//  YWPayMoneyTableViewCell.m
//  YuWa
//
//  Created by double on 17/4/25.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayMoneyTableViewCell.h"
@interface YWPayMoneyTableViewCell()<UITextViewDelegate>


@end
@implementation YWPayMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.moneyTF addTarget:self action:@selector(moneyChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [self.moneyTF addTarget:self action:@selector(moneyChangeAction2:) forControlEvents:UIControlEventEditingDidEnd];
    self.chooseBtn.enabled = NO;
}
- (IBAction)chooseDiscountAction:(UIButton *)sender {

}
- (void)moneyChangeAction:(UITextField *)sender {
    if (self.moneyChangeBlock) {
       
        self.moneyChangeBlock(sender.text);
    
    }
     [self.delegate changMoney:sender.text];
}

- (void)moneyChangeAction2:(UITextField *)sender {

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moneyTF endEditing:YES];
    [self endEditing:YES];
}

-(void)hideBoradKey{
   [self.moneyTF resignFirstResponder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
