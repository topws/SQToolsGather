//
//  AvatarImageModel.h
//  GuluGulu
//
//  Created by Huan on 16/5/16.
//  Copyright © 2016年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvatarImageModel : NSObject
@property (copy, nonatomic) NSString * requestId;
@property (copy, nonatomic) NSString * mediaId;
@property (copy, nonatomic) NSString * bucket;
@property (copy, nonatomic) NSString * directory;
@property (copy, nonatomic) NSString * filename;
@property (copy, nonatomic) NSString * filelink;
@property (copy, nonatomic) NSString * url;
@property (copy, nonatomic) NSString * mimeType;
@property (strong, nonatomic) NSArray * size;
@property (assign, nonatomic) NSInteger referenceCount;
@property (copy, nonatomic) NSString * updatedAt;
@property (copy, nonatomic) NSString * createdAt;

@property (copy, nonatomic) NSString * status;
@end

@interface AvatarImageJudgeSizeModel : NSObject

@property (copy, nonatomic) NSString * requestId;
@property (copy, nonatomic) NSString * mediaId;
@property (copy, nonatomic) NSString * bucket;
@property (copy, nonatomic) NSString * directory;
@property (copy, nonatomic) NSString * filename;
@property (copy, nonatomic) NSString * filelink;
@property (copy, nonatomic) NSString * url;
@property (copy, nonatomic) NSString * mimeType;
@property (strong, nonatomic) id  size;
@property (assign, nonatomic) NSInteger referenceCount;
@property (copy, nonatomic) NSString * updatedAt;
@property (copy, nonatomic) NSString * createdAt;

@property (copy, nonatomic) NSString * status;

@end
