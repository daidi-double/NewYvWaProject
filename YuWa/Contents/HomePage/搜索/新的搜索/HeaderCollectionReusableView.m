//
//  HeaderCollectionReusableView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView()

@end

@implementation HeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clearButton:(id)sender {
    if (self.cleanBlock) {
        self.cleanBlock();
    }
    
}

@end
