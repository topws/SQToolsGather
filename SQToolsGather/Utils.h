//
//  Utils.h
//  SQAlert
//
//  Created by qianwei on 17/3/27.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIImage *) snapshotScreenInView:(UIImage *)oldImage;
@end
