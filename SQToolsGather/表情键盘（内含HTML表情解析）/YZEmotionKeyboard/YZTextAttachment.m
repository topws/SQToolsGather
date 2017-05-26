//
//  YZTextAttachment.m
//  Emoji
//
//  Created by yz on 16/8/6.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZTextAttachment.h"

@implementation YZTextAttachment
-(void)encodeWithCoder:(NSCoder *)aCoder
{
 
    [aCoder encodeObject:self.emotionStr forKey:@"emotionStr"];
    [aCoder encodeObject:self.imageIdStr forKey:@"imageIdStr"];
    [aCoder encodeObject:self.imageIdStr forKey:@"imageIdStr"];
    [aCoder encodeObject:self.image forKey:@"mentionStr"];
    [aCoder encodeObject:self.contents forKey:@"contents"];
//    [aCoder encodeObject:self.fileType forKey:@"fileType"];
//    [aCoder encodeObject:self.bounds forKey:@"bounds"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.emotionStr = [aDecoder decodeObjectForKey:@"emotionStr"];
        self.imageIdStr = [aDecoder decodeObjectForKey:@"imageIdStr"];
        self.mentionStr = [aDecoder decodeObjectForKey:@"mentionStr"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.contents = [aDecoder decodeObjectForKey:@"contents"];
//        self.fileType = [aDecoder decodeObjectForKey:@"fileType"];
//        self.bounds =
    }
    return self;
}
@end
