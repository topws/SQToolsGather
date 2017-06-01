//
//  Utils.h
//  SQAlert
//
//  Created by qianwei on 17/3/27.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject

//16进制 颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;


#pragma mark -
#pragma mark   ==============屏幕相关==============
//截屏
+ (UIImage *) snapshotScreenInView:(UIImage *)oldImage;
//是否是横屏
+ (BOOL) isLandscape;

//获取代码运行的时间
+ (void)getCodeRunTime;

//是否 WiFi
+(BOOL)isWifi;
@end
