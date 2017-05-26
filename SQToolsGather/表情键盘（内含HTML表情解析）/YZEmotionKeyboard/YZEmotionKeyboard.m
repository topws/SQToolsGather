//
//  YZEmotionKeyboard.m
//  YZEmotionKeyboardDemo
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZEmotionKeyboard.h"
#import "YZTextAttachment.h"
#import "YZEmotionPageCell.h"
#import "YZEmotionManager.h"
#import "EmojiObject.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
static NSString * const ID = @"emotion";



@interface YZEmotionKeyboard ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConsH;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryEmotionView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) UITextView *yz_textView;

@property (nonatomic, weak) UIPageControl *emojiViewpageControl;

@property (nonatomic, assign)int currentEmotionIndex;
@end

@implementation YZEmotionKeyboard

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置collectionView
    [self setupCollectionView];

    self.currentEmotionIndex = 0;
    // 设置pageControl
    [self setupPageControl];
    
    [self setupBottonButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectEmotion:) name:@"didSelectEmotion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDelete) name:@"didClickDelete" object:nil];
    

    
    self.categoryEmotionView.showsVerticalScrollIndicator = FALSE;
    self.categoryEmotionView.showsHorizontalScrollIndicator = FALSE;
    self.collectionView.hidden = YES;
   
}
#pragma mark - 颜文字代理
- (void)emoticonView:(NSString *)emoText{

    NSRange range = _yz_textView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:_yz_textView.attributedText];
    
    NSAttributedString *imageAttr = [[NSMutableAttributedString alloc]initWithString:emoText];;
    
    [textAttr replaceCharactersInRange:_yz_textView.selectedRange withAttributedString:imageAttr];
    [textAttr addAttributes:@{NSFontAttributeName : _yz_textView.font} range:NSMakeRange(_yz_textView.selectedRange.location, imageAttr.length)];
    
    _yz_textView.attributedText = textAttr;
    [_yz_textView insertText:@""];
    // 设置光标位置
    _yz_textView.selectedRange = NSMakeRange(range.location + emoText.length, 0);
}
-(void)emoticonPageControl:(NSInteger)page
{
//    DLog(@"%s",__func__);
    _emojiViewpageControl.currentPage = page;
}

#pragma mark - 设置 底部按钮
- (void)setupBottonButton
{
    CGFloat emotionButtonW = 55;
    UIButton *emotionButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    emotionButton1.frame = CGRectMake(0, 0, emotionButtonW, 44);
    emotionButton1.tag = 1001;
    emotionButton1.titleLabel.font = [UIFont systemFontOfSize:(15)];
 
    [emotionButton1 setBackgroundImage:[UIImage yy_imageWithColor:[Utils colorWithHexString:@"f7f7f7"]] forState:UIControlStateSelected];
    [emotionButton1 setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [emotionButton1 setImage:[UIImage imageNamed:@"icon_moticons_gray"] forState:UIControlStateNormal];
    [emotionButton1 setImage:[UIImage imageNamed:@"icon_moticons_green"] forState:UIControlStateSelected];
//    [emotionButton1 setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
//    [emotionButton1 setTitle:@"颜文字" forState:UIControlStateNormal];
    [emotionButton1 addTarget:self action:@selector(didClickCategory:) forControlEvents:UIControlEventTouchUpInside];
    emotionButton1.selected = YES;
    
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(emotionButton1.bounds.size.width - 1, 0, 1, emotionButton1.bounds.size.height);
    lineView.backgroundColor = [Utils colorWithHexString:@"E3E3E3"];
    [emotionButton1 addSubview:lineView];
    [self.categoryEmotionView addSubview:emotionButton1];
    
    //循环创建多个 按钮
    for (int i = 0;  i < [YZEmotionManager sharedEmotionManager].emojiArr.count; i++) {
        
        UIButton *emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emotionButton.frame = CGRectMake(emotionButtonW + (i * 55), 0, 55, 44);
        emotionButton.tag = i;
        UIImageView * emotionImage = [[UIImageView alloc]init];
        [emotionImage yy_setImageWithURL:[NSURL URLWithString:[YZEmotionManager emojiTitleUrl:i]]  options:0];
        [emotionButton addSubview:emotionImage];
        [emotionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.center.equalTo(emotionButton);
        }];
        [emotionButton setBackgroundImage:[UIImage yy_imageWithColor:[Utils colorWithHexString:@"f7f7f7"]] forState:UIControlStateSelected];
        [emotionButton setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [emotionButton addTarget:self action:@selector(didClickCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryEmotionView addSubview:emotionButton];
        //添加 右边 分割线
        UIView * lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(emotionButton.frame.size.width -1 , 0, 1, emotionButton.frame.size.height);
        lineView.backgroundColor = [Utils colorWithHexString:@"E3E3E3"];
        [emotionButton addSubview:lineView];
        
    }
    
    self.categoryEmotionView.contentSize = CGSizeMake((67 + [YZEmotionManager sharedEmotionManager].emojiArr.count * 55), 0);
    
}
- (void)didClickCategory:(UIButton *)sender{
    int tag = (int)sender.tag;
    for (UIView * subView in self.categoryEmotionView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            if ([sender isEqual:subView]) {
                sender.selected = YES;
            }else{
                UIButton * btn = (UIButton *)subView;
                btn.selected = NO;
            }
        }
    }
    if (tag == 1001) {//颜文字
        
        self.collectionView.hidden = YES;
        self.pageControl.hidden = YES;
        
        self.emojiViewpageControl.hidden = NO;
    }else {//emotion
        self.currentEmotionIndex = (int)sender.tag;
        [self setupPageControl];
        
        
        //滑动到 置顶的位置
        if (self.currentEmotionIndex == 0) {
            [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        }else{
            int sum = 0;
            for (int i = 0; i < self.currentEmotionIndex; i++) {
                
                sum = (int)[YZEmotionManager emotionPage:i] + sum;
            }
            CGFloat offsetX = sum * ScreenW;
            [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        }
        
        
        
        self.collectionView.hidden = NO;
        self.pageControl.hidden = NO;
        
        self.emojiViewpageControl.hidden = YES;
    }
}
- (void)setupPageControl
{
    self.pageControl.numberOfPages = [YZEmotionManager emotionPage:self.currentEmotionIndex];
    self.pageControl.userInteractionEnabled = NO;
    
}

// 点击pageControl上小点
- (void)tapDotAction:(UITapGestureRecognizer *)tap
{
    CGFloat offsetX = [YZEmotionManager emotionPage:self.currentEmotionIndex] * self.bounds.size.width;
    
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


+ (instancetype)emotionKeyboard
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

// 点击删除按钮
- (IBAction)clickSend:(id)sender {
    
    [_yz_textView deleteBackward];
}

// 获取表情字符串
- (NSString *)emotionText:(UITextView *)textView
{
    
    NSMutableString *strM = [NSMutableString string];
    /*
     *  手动去掉 图片后插入的换行
     */
    __block BOOL lastAttrIsImage = NO;
    [textView.attributedText enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment && [attachment isKindOfClass:[YZTextAttachment class]]) { // 图文混排
            if (attachment.imageIdStr.length > 0) {//图片
                str = attachment.emotionStr;
                [strM appendString:str];
                
                lastAttrIsImage = YES;
            }else if(attachment.mentionStr.length > 0){//@
                
                str = attachment.mentionStr;
                [strM appendString:str];
                
                lastAttrIsImage = NO;
                
            }else{//表情包
                
                str = attachment.emotionStr;
                [strM appendString:str];
                
                lastAttrIsImage = NO;
            }
            
        } else { // 文字
            
            str = [textView.attributedText.string substringWithRange:range];
            if (lastAttrIsImage && [str isEqualToString:@"\n"]) {
                
            }else{
                [strM appendString:str];
            }
            
            lastAttrIsImage = NO;
        }
        
    }];

    return strM;
}
/*
 *  获取 图文混排中的 图片ID 数组（新版 发帖 增加方法）
 */
- (void)removeImageIdsFromTextView:(UITextView *)textView mediaId:(NSString *)mediaId
{

    NSMutableAttributedString * mutable = [[NSMutableAttributedString alloc]init];
    
    [textView.attributedText enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment && attachment.imageIdStr.length > 0 && [attachment.imageIdStr isEqualToString:mediaId]) {
            
        }else{
            NSAttributedString * str = [textView.attributedText attributedSubstringFromRange:range];
            [mutable appendAttributedString:str];
        }
       
    }];
    
    textView.attributedText = mutable.copy;
}
/*
 *  计算 textView 中一共有多少张图片
 */
-(int)getImageNumberInTextView:(UITextView *)textView emoji:(BOOL)isEmoji{
    
    __block int number = 0;
    [textView.attributedText enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment && [attachment isKindOfClass:[YZTextAttachment class]]) {
            if (attachment.imageIdStr.length > 0) {
                if (!isEmoji) {
                    number++;
                }
            }else{
                if (isEmoji) {
                    number++;
                }
            }
            
        }
        
    }];
    return number;
}
// 点击删除按钮
- (void)didClickDelete
{
    [_yz_textView deleteBackward];
}

#pragma mark - 点击表情
- (void)didSelectEmotion:(NSNotification *)note
{
    YZTextAttachment *attachment = note.object;
    if (_yz_textView == nil) {
        return;
    }
    /*
     *  判断当前是否超过十个
     */
    int num = [self getImageNumberInTextView:_yz_textView emoji:YES];
    if (num+1 > 10) {
        
        
        return;
    }
    NSRange range = _yz_textView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:_yz_textView.attributedText];
    
    NSAttributedString *imageAttr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    
    [textAttr replaceCharactersInRange:_yz_textView.selectedRange withAttributedString:imageAttr];
    [textAttr addAttributes:@{NSFontAttributeName : _yz_textView.font} range:NSMakeRange(_yz_textView.selectedRange.location, 1)];
    
    _yz_textView.attributedText = textAttr;
    
    // 会在textView后面插入空的,触发textView文字改变
    //这里仅用于改变 textView的高度变化
    [_yz_textView insertText:@""];
    
    // 设置光标位置
    _yz_textView.selectedRange = NSMakeRange(range.location + 1, 0);
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextView:(UITextView *)textView
{
    _textView  = textView;
    if (!([textView isKindOfClass:[UITextField class]] || [textView isKindOfClass:[UITextView class]])) {
        @throw [NSException exceptionWithName:@"Error" reason:@"传入UITextField或者UITextView" userInfo:nil];
    }
    _yz_textView = textView;
   // _yz_textView.inputView = self;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGFloat H = [YZEmotionManager getCollectionViewH];
    self.collectionViewConsH.constant = H;
    layout.itemSize = CGSizeMake(ScreenW, H - 3);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    

    
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerClass:[YZEmotionPageCell class] forCellWithReuseIdentifier:ID];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.contentSize = CGSizeMake(ScreenW, 0);
}

#pragma mark - UICollectionViewDataSource
// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [YZEmotionManager sharedEmotionManager].emojiArr.count;
}

// 返回每组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [YZEmotionManager emotionPage:(int)section];
}

// 返回cell外观
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZEmotionPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.emotions = [YZEmotionManager emotionsOfPage:indexPath.row :(int)indexPath.section];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个 section 的个数
    int number = (int)[YZEmotionManager emotionPage:(int)indexPath.section];
    self.pageControl.numberOfPages = number;
    
    self.pageControl.currentPage = indexPath.row;
    self.currentEmotionIndex = (int)indexPath.section;
    
    //判断 当前展示的颜文字还是 表情包
    
    if (self.collectionView.hidden == NO) {
        
        for (UIView * subView in self.categoryEmotionView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                if (subView.tag == indexPath.section) {
                    UIButton * btn = (UIButton *)subView;
                    btn.selected = YES;
                }else{
                    UIButton * btn = (UIButton *)subView;
                    btn.selected = NO;
                }
            }
        }
    }
    
    
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

@end
