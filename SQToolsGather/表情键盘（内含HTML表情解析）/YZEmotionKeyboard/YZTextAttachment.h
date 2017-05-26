//
//  YZTextAttachment.h
//  Emoji
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZTextAttachment : NSTextAttachment<NSCoding>

@property (nonatomic, copy) NSString *emotionStr;//表情包
@property (nonatomic, copy) NSString *imageIdStr;//图片
@property (nonatomic, copy) NSString *mentionStr;//@
@end
