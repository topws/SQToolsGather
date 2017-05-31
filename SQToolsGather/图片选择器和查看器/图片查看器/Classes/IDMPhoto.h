//
//  IDMPhoto.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPhotoProtocol.h"


// This class models a photo/image and it's caption
// If you want to handle photos, caching, decompression
// yourself then you can simply ensure your custom data model
// conforms to IDMPhotoProtocol
@interface IDMPhoto : NSObject <IDMPhoto>

// Progress download block, used to update the circularView
typedef void (^IDMProgressUpdateBlock)(CGFloat progress);

// Properties
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) IDMProgressUpdateBlock progressUpdateBlock;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic,assign)BOOL isWifi;

/* 判断是否是查看原图  默认为NO*/
@property (nonatomic ,assign) BOOL isCheckOriginalImage;

/* wifi环境下 ，在缩略图基础上加载原图 默认为NO*/
@property (nonatomic ,assign) BOOL isWifiLoadOriginalImage;


// Class
+ (IDMPhoto *)photoWithImage:(UIImage *)image;
+ (IDMPhoto *)photoWithFilePath:(NSString *)path;
+ (IDMPhoto *)photoWithURL:(NSURL *)url;

+ (NSArray *)photosWithImages:(NSArray *)imagesArray isWifi:(BOOL)isWifi;
+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray isWifi:(BOOL)isWifi;
+ (NSArray *)photosWithURLs:(NSArray *)urlsArray isWifi:(BOOL)isWifi;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;


@end

