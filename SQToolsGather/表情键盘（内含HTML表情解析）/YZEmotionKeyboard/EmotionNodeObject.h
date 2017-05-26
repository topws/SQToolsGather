//
//  EmotionNodeObject.h
//  YZEmotionKeyboardDemo
//
//  Created by qianwei on 17/1/5.
//  Copyright © 2017年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeAttributeObject.h"
#import "NodeAtObject.h"
#import "NodeImageObject.h"
@interface EmotionNodeObject : NSObject
@property (nonatomic, strong) NSArray *nodeAttributeArray;
@property (nonatomic, copy) NSString * raw;
@property (nonatomic,copy)NSString * nodeName;
@property (nonatomic,copy)NSString * nodeContent;
@property (nonatomic,strong)NSArray * nodeChildArray;
//添加 富文本所需 模型
@property (nonatomic, strong) NodeAttributeObject *attribute;
@property (nonatomic, strong) NodeAtObject * atObject;
@property (nonatomic, strong) NodeImageObject * imageObject;
@end
