//
//  YZEmotionCell.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZEmotionCell.h"
#import "YZEmotionManager.h"
@interface YZEmotionCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BTNConsH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameConsW;

@end
@implementation YZEmotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.emotionName.font = [UIFont systemFontOfSize:14];
    
    self.nameConsW.constant = ScreenW * 0.25;
    
    self.BTNConsH.constant = [YZEmotionManager getCollectionCellW];
}

@end
