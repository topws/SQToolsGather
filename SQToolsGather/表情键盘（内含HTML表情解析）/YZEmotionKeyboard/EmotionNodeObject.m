//
//  EmotionNodeObject.m
//  YZEmotionKeyboardDemo
//
//  Created by qianwei on 17/1/5.
//  Copyright © 2017年 yz. All rights reserved.
//

#import "EmotionNodeObject.h"
#import "MJExtension.h"

@implementation EmotionNodeObject

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"nodeChildArray":@"EmotionNodeObject"
             };
}
@end
