
//
//  EmojiObject.m
//  GuluGulu
//
//  Created by qianwei on 17/1/9.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import "EmojiObject.h"

@implementation EmojiObject

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items":@"EmojiObject"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID" : @"id",
             };
}

@end
