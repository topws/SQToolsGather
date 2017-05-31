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
//截屏
+ (UIImage *) snapshotScreenInView:(UIImage *)oldImage;
//获取代码运行的时间
+ (void)getCodeRunTime;
//是否 WiFi
+(BOOL)isWifi;
@end
