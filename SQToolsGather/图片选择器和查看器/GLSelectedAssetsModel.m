//
//  GLSelectedAssetsModel.m
//  GuluGulu
//
//  Created by qianwei on 2017/4/24.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import "GLSelectedAssetsModel.h"

@implementation GLSelectedAssetsModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.mediaId forKey:@"mediaId"];
    [aCoder encodeObject:self.selectedImage forKey:@"selectedImage"];
    [aCoder encodeObject:self.snapImage forKey:@"snapImage"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self= [super init]) {
        self.mediaId = [aDecoder decodeObjectForKey:@"mediaId"];
        self.selectedImage = [aDecoder decodeObjectForKey:@"selectedImage"];
        self.snapImage = [aDecoder decodeObjectForKey:@"snapImage"];
    }
    return self;
}
@end
