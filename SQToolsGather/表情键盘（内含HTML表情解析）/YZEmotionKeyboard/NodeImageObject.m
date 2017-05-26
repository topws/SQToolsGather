//
//  NodeImageObject.m
//  GuluGulu
//
//  Created by qianwei on 2017/4/18.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import "NodeImageObject.h"

@implementation NodeImageObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"mediaId" : @"data-id",
             @"imageWidth" : @"data-width",
             @"imageHeight" : @"data-height",
             @"dataSize" : @" data-size",
             @"dataType" : @"data-type"
             };
}
@end
