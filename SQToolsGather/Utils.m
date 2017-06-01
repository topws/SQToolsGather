//
//  Utils.m
//  SQAlert
//
//  Created by qianwei on 17/3/27.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"
@implementation Utils
+ (void)getCodeRunTime{
    NSDate* tmpStartData = [NSDate date];
    //You code here...
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
}
//根据 16进制数字返回 UIColor
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}
//图片选择后，进行绘制一个150*150的正方形图片
+ (UIImage *)snapshotScreenInView:(UIImage *)oldImage {
    
    CGFloat imageH = 150;
    
    CGFloat imageW = 150;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:oldImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(0, 0, imageW, imageH);
    
    [backView addSubview:imageView];
    
    UIGraphicsBeginImageContextWithOptions(backView.size, NO, [UIScreen mainScreen].scale);
    CGRect rect = backView.frame;
    [backView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+(BOOL)isLandscape{
    //判断 是否是 横屏
    if ([[UIDevice currentDevice] orientation] ==UIDeviceOrientationLandscapeLeft ||[[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isWifi{
    return [Reachability isEnableWIFI];
}
@end
