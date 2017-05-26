//
//  YZEmotionPageCell.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZEmotionPageCell.h"
#import "YZEmotionCell.h"
#import "YZEmotionManager.h"
#import "YZTextAttachment.h"
#import "EmojiObject.h"

#import "PagingCollectionViewLayout.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width



static NSString * const ID = @"emojicell";

@interface YZEmotionPageCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@end


@implementation YZEmotionPageCell

- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {

        CGFloat emotionW = [YZEmotionManager getCollectionCellW];
        CGFloat margin = [YZEmotionManager getMargin];
        CGFloat padding = [YZEmotionManager getPadding];
    
        PagingCollectionViewLayout * horiztionLayout = [[PagingCollectionViewLayout alloc]init];
        horiztionLayout.itemSize = CGSizeMake(emotionW, emotionW + 24);
        horiztionLayout.minimumInteritemSpacing = margin;
        horiztionLayout.minimumLineSpacing = padding;
        horiztionLayout.sectionInset = UIEdgeInsetsMake(10, padding, 0, padding);
//        UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:horiztionLayout];
        
        
        [collectionView registerNib:[UINib nibWithNibName:@"YZEmotionCell" bundle:nil] forCellWithReuseIdentifier:ID];
        _collectionView = collectionView;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:collectionView];
    }
    
    return _collectionView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emotions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //[NSString stringWithFormat:@"%02d",(int)(indexPath.row + 1)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    EmojiObject * object = self.emotions[indexPath.row];
    [cell.emotionButton yy_setBackgroundImageWithURL:[NSURL URLWithString:object.image.url] forState:UIControlStateNormal options:YYWebImageOptionIgnoreFailedURL];
    cell.emotionName.text = object.text;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    YZEmotionCell *cell = (YZEmotionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    YZTextAttachment *attachment = [[YZTextAttachment alloc] init];
    attachment.image = [cell.emotionButton backgroundImageForState:UIControlStateNormal];
    EmojiObject * object = self.emotions[indexPath.row];
    //获取 图片对应的 文字描述
    attachment.emotionStr = [NSString stringWithFormat:@"<x-emoticon data-id=\"%@\">[%@]</x-emoticon>",object.ID,object.text];
    attachment.bounds = CGRectMake(0, 0, [YZEmotionManager getCollectionCellW], [YZEmotionManager getCollectionCellW]);
    
    
    // 点击表情
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectEmotion" object:attachment];
    
    
}

@end
