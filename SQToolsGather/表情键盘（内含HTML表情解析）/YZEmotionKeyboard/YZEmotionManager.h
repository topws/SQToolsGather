//
//  YZEmotionManager.h
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YZEmotionManager : NSObject
@property (nonatomic, strong) NSArray *emojiArr;
+(instancetype)sharedEmotionManager;
//布局所需
+ (CGFloat)getKeyboardH;
+ (CGFloat)getCollectionViewH;
+ (CGFloat)getCollectionCellW;
+ (CGFloat)getMargin;
+ (CGFloat)getPadding;
/** 所有表情 */
+ (NSArray *)emotions:(int)index;

+(NSString *)emojiTitleUrl:(int)index;
// 某一页的总页数，暂时 只有一个表情包
+ (NSInteger)emotionPage:(int)index;

/**
 *  指定页码，返回当前页的表情
 *
 *  @param page 页码
 *
 *  @return 当前页的标签
 */
+ (NSArray *)emotionsOfPage:(NSInteger)page :(int)index;

@end
