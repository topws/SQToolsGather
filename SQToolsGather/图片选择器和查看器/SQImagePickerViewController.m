//
//  SQImagePickerViewController.m
//  SQToolsGather
//
//  Created by qianwei on 2017/5/24.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#define barH 134
#import "SQImagePickerViewController.h"

#import "YZEmotionKeyboard.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "GLSelectedAssetsModel.h"
#import "YZTextAttachment.h"

#import "TZImagePickerController.h"
#import <Photos/Photos.h>

@interface SQImagePickerViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//输入框
@property (nonatomic,strong)UITextView * contentView;

//图片选择器（支持拖动排序）
@property (nonatomic,strong)UICollectionView * photoCollectionView;
@property (nonatomic,strong)NSMutableArray * selectedAssetModels;
@property (nonatomic,strong)NSMutableArray * selectedAsset;
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;


@end

@implementation SQImagePickerViewController
#pragma mark - --------图文混排 相关属性 懒加载--------
-(NSMutableArray *)selectedAsset{
    if (_selectedAsset == nil) {
        _selectedAsset = [NSMutableArray array];
    }
    return _selectedAsset;
}

-(NSMutableArray<GLSelectedAssetsModel *> *)selectedAssetModels{
    if (_selectedAssetModels == nil) {
        _selectedAssetModels = [NSMutableArray array];
    }
    return _selectedAssetModels;
}
// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
    // 创建表情键盘
    if (_emotionKeyboard == nil) {
        
        YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
        
        emotionKeyboard.sendContent = ^(NSString *content){
            // 点击发送会调用，自动把文本框内容返回给你
        };
        
        _emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}
-(UITextView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - barH)];
        
        _contentView.delegate = self;
        _contentView.font = [UIFont systemFontOfSize:16];
    }
    return _contentView;
}
-(UICollectionView *)photoCollectionView{
    if (_photoCollectionView == nil) {
        
        LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
        
        CGFloat margin = 10;
        CGFloat itemWH = 100;
        
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScreenH - barH, ScreenW, barH) collectionViewLayout:layout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        
        [_photoCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        
        _photoCollectionView.alwaysBounceHorizontal = YES;
        CGFloat rgb = 244 / 255.0;
        _photoCollectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        
        _photoCollectionView.contentInset = UIEdgeInsetsMake(20, 10, 14, 10);
        _photoCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _photoCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.photoCollectionView];
}

#pragma mark -
#pragma mark   ==============打开图片选择器==============
-(void)openImagePicker{

    TZImagePickerController * imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePicker.selectedAssets = self.selectedAsset;
    
    [imagePicker setImagePickerControllerDidCancelHandle:^{
        NSLog(@"取消 选择图片");
    }];
    
    @weakify(self);
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto){
        @strongify(self);
        if (!self) return;
        
        [self.selectedAsset removeAllObjects];
        [self.selectedAsset addObjectsFromArray:assets];
        
        [self.selectedAssetModels removeAllObjects];
        //模拟 上传图片后的 mediaId
        int mediaId = 0;
        for (UIImage * pickerImage in photos) {
            GLSelectedAssetsModel * model = [[GLSelectedAssetsModel alloc]init];
            model.selectedImage = pickerImage;
            model.snapImage = [Utils snapshotScreenInView:pickerImage];
            model.mediaId = [NSString stringWithFormat:@"%d",mediaId];
            [self.selectedAssetModels addObject:model];
            
            mediaId ++;
        }
        
        [self.photoCollectionView reloadData];
    };
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}
#pragma mark -
#pragma mark   ============== UICollectionViewDelegate && DataSource ==============
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedAssetModels.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == self.selectedAssetModels.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        GLSelectedAssetsModel * model = self.selectedAssetModels[indexPath.row];
        cell.imageView.image = model.selectedImage;
        
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.selectedAssetModels.count) {
        [self openImagePicker];
    } else { // preview photos or video / 预览照片或者视频
//        if ([self.emotionKeyboard getImageNumberInTextView:self.contentView emoji:NO] > 19) {
//            //图片插入已达到最大值哦
//            return;
//        }
//        GLSelectedAssetsModel * model = self.selectedAssetModels[indexPath.row];
//        [self appendImageAttributeAtContentView:model];
        
        //预览 图片
        NSMutableArray * photos = [NSMutableArray array];
        for (GLSelectedAssetsModel *model in self.selectedAssetModels) {
            [photos addObject:model.selectedImage];
        }
        TZImagePickerController * imagePicker = [[TZImagePickerController alloc]initWithSelectedAssets:self.selectedAsset selectedPhotos:photos.copy index:indexPath.row];
        imagePicker.allowCrop = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.selectedAssetModels.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.selectedAssetModels.count && destinationIndexPath.item < self.selectedAssetModels.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    
    GLSelectedAssetsModel * model = self.selectedAssetModels[sourceIndexPath.item];
    [self.selectedAssetModels removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAssetModels insertObject:model atIndex:destinationIndexPath.item];
    
    PHAsset * asset = self.selectedAsset[sourceIndexPath.item];
    [self.selectedAsset removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAsset insertObject:asset atIndex:destinationIndexPath.item];
    
    [self.photoCollectionView reloadData];
}

- (void)deleteBtnClik:(UIButton *)sender {
    /*
     *  根据存储的已选择的图片model ，进行操作
     */
//    GLSelectedAssetsModel * assetModel = self.selectedAssetModels[sender.tag];
//    NSString * mediaId = assetModel.mediaId;
    
    [self deleteSelectImage:sender];

}
/*
 *  选中备选框中的 图片 删除按钮
 */
-(void)deleteSelectImage:(UIButton *)sender{
    
    GLSelectedAssetsModel * assetModel = self.selectedAssetModels[sender.tag];
    NSString * mediaId = assetModel.mediaId;
    
    [self.selectedAssetModels removeObjectAtIndex:sender.tag];
    [self.selectedAsset removeObjectAtIndex:sender.tag];
    
    [self.photoCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.photoCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.photoCollectionView reloadData];
    }];
    
    
    [self deleteSelectedImage:mediaId];
}
#pragma mark - 删除备选框的某张图片后 同步删除文本内的图片
-(void)deleteSelectedImage:(NSString *)mediaId{
    
    [self.emotionKeyboard removeImageIdsFromTextView:self.contentView mediaId:mediaId];

}

#pragma mark - contentView 追加图片
-(void)appendImageAttributeAtContentView:(GLSelectedAssetsModel *)selectedAssetModel{
    UIImage * photo = selectedAssetModel.selectedImage;
    
    CGSize imageSize = CGSizeMake(150, 150);
    
    /*
     *  绘制一张 占满全屏的 图片
     */
    photo = selectedAssetModel.snapImage;
    NSRange range = self.contentView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentView.attributedText];
    
    YZTextAttachment * attachment = [[YZTextAttachment alloc]init];
    attachment.image = photo;
    attachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    attachment.emotionStr = [NSString stringWithFormat:@"<img data-id=\"%@\">",selectedAssetModel.mediaId];
    attachment.imageIdStr = selectedAssetModel.mediaId;
    
    NSMutableAttributedString * mutaleAttr = [[NSMutableAttributedString alloc]init];
    
    //    [mutaleAttr appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
    
    NSAttributedString *imageAttr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    [mutaleAttr appendAttributedString:imageAttr];
    
    __block int appentAttrLength = 1;
    
    //取光标前的最后一个富文本，确定是否 需要添加空格
    if (textAttr.length > 0 && (range.location) < (textAttr.length)) {
        
        NSAttributedString * lastAttr = [textAttr attributedSubstringFromRange:NSMakeRange(range.location-1, 1)];
        if (lastAttr.length > 0) {
            [lastAttr enumerateAttributesInRange:NSMakeRange(0, lastAttr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                
                YZTextAttachment *attachment = attrs[@"NSAttachment"];
                if (attachment && attachment.imageIdStr.length > 0) {
                    appentAttrLength = 1;
                }else{
                    appentAttrLength = 2;
                }
            }];
        }else{
            appentAttrLength = 2;
        }
    }else{
        appentAttrLength = 2;
    }
    
    if (appentAttrLength == 2) {
        [mutaleAttr appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
    }
    [textAttr replaceCharactersInRange:self.contentView.selectedRange withAttributedString:mutaleAttr.copy];
    
    [textAttr addAttributes:@{NSFontAttributeName : self.contentView.font} range:NSMakeRange(self.contentView.selectedRange.location, appentAttrLength)];
    
    self.contentView.attributedText = textAttr;
    
    // 会在textView后面插入空的,触发textView文字改变
    //这里仅用于改变 textView的高度变化
    [self.contentView insertText:@""];
    // 设置光标位置
    self.contentView.selectedRange = NSMakeRange(range.location + appentAttrLength, 0);
    
}
/*
 *  判断 备选框 中的图片是否全部使用了
 */
-(BOOL)AllSelectedImageUsed{
    
    if (self.selectedAssetModels.count == 0) {
        return YES;
    }
    NSMutableArray * backSelectedModels = [NSMutableArray arrayWithArray:self.selectedAssetModels];
    [self.contentView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.contentView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment && attachment.imageIdStr.length > 0) {
            
            for (GLSelectedAssetsModel * model in self.selectedAssetModels) {
                if ([model.mediaId isEqualToString:attachment.imageIdStr]) {
                    
                    if ([backSelectedModels containsObject:model]) {
                        [backSelectedModels removeObject:model];
                    }
                    break;
                }
            }
            
            
        }else {
            
        }
        
    }];
    
    return backSelectedModels.count > 0 ? NO : YES;
}

-(void)dealloc{
    NSLog(@"图片选择器页面释放");
}
@end
