//
//  EmojiObject.h
//  GuluGulu
//
//  Created by qianwei on 17/1/9.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarImageModel.h"
@interface EmojiObject : NSObject

@property (nonatomic,copy)NSString * commonable;
@property (nonatomic,copy)NSString * ID;
@property (nonatomic, strong) AvatarImageModel *image;
@property (nonatomic,copy)NSString * text;
@property (nonatomic,copy)NSString * version;
@property (nonatomic, strong) NSArray *items;
@end
