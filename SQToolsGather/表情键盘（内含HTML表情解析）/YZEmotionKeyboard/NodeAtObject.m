
//
//  NodeAtObject.m
//  YZEmotionKeyboardDemo
//
//  Created by qianwei on 17/1/6.
//  Copyright © 2017年 yz. All rights reserved.
//

#import "NodeAtObject.h"

@implementation NodeAtObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"atID" : @"data-id",
             };
}
@end
