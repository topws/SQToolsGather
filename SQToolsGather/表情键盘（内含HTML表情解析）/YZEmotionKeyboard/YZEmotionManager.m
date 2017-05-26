//
//  YZEmotionManager.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#define padding 16
#define margin  20
#define emotionNums 4
#define ScreenW [UIScreen mainScreen].bounds.size.width

#import "YZEmotionManager.h"

#import "EmojiObject.h"


@interface YZEmotionManager()

@end
@implementation YZEmotionManager
-(NSArray *)emojiArr{
    if (_emojiArr ==nil) {
        
        _emojiArr = [NSArray array];
    }
    
    return _emojiArr;
}
+(instancetype)sharedEmotionManager{
    static YZEmotionManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YZEmotionManager alloc]init];
    });
    return manager;
    
}
+ (CGFloat)getKeyboardH{
    
    CGFloat H = [self getCollectionViewH] + 20 + 9 + 10 + 45;
    return H;
}
+ (CGFloat)getMargin{
    return margin;
}
+ (CGFloat)getPadding{
    return padding;
}
+ (CGFloat)getCollectionViewH{
    // 计算间距
   
    CGFloat H = ([self getCollectionCellW] + 24) * 2 + padding * 2;
    return H;
}
+ (CGFloat)getCollectionCellW{
    CGFloat emotionW = (ScreenW - (emotionNums - 1)*margin - padding *2)/emotionNums;
    return emotionW;
}
+ (NSArray *)emotions:(int)index
{
    YZEmotionManager * manager = [self sharedEmotionManager];
    EmojiObject * object = manager.emojiArr[index];
    return object.items;
}

// 某一页的总页数
+ (NSInteger)emotionPage:(int)index
{
    YZEmotionManager * manager = [self sharedEmotionManager];
    
    if (manager.emojiArr.count == 0) {
        return 0;
    }
    
    EmojiObject * object = manager.emojiArr[index];
    
    return ceilf((CGFloat)object.items.count / 8);
}
//获取表情键盘 某一页 的 表情名称
+ (NSArray *)emotionsOfPage:(NSInteger)page :(int)index
{
    YZEmotionManager * manager = [self sharedEmotionManager];
    EmojiObject * object = manager.emojiArr[index];
    
    int location = (int)page * 8;
    int width = 8;
    if ((width + location) > object.items.count) {
        width = (int)(object.items.count - location);
    }
    
    NSArray * subArr = [object.items subarrayWithRange:NSMakeRange(location, width)];
    
    return subArr;
    
}
+(NSString *)emojiTitleUrl:(int)index{
    YZEmotionManager * manager = [self sharedEmotionManager];
    EmojiObject * object = manager.emojiArr[index];
    
    return object.image.url;
}
@end
