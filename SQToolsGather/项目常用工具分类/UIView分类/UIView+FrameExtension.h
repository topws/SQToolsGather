//
//  UIView+FrameExtension.h
//  SQToolsGather
//
//  Created by qianwei on 2017/5/26.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


- (UIViewController *)viewController;


/**
 *  添加边框:四边 颜色 圆角半径
 */
-(void)setBorder:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;

+(instancetype)viewFromXIB;

@end

