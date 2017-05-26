//
//  NodeAttributeObject.m
//  YZEmotionKeyboardDemo
//
//  Created by qianwei on 17/1/5.
//  Copyright © 2017年 yz. All rights reserved.
//

#import "NodeAttributeObject.h"

@implementation NodeAttributeObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"dataID" : @"data-id",
             @"dataUrl" : @"data-url",
             @"dataSize" : @"data-size",
             @"dataType" : @"data-type"
             };
}
@end
