//
//  GLSelectedAssetsModel.h
//  GuluGulu
//
//  Created by qianwei on 2017/4/24.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSelectedAssetsModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString * mediaId;
/*
 *  选中的图片
 */
@property (nonatomic, strong) UIImage * selectedImage;
/*
 *  处理后 放在textView里面的图片（如需要）
 */
@property (nonatomic, strong) UIImage * snapImage;
@end
