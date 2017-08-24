//
//  KeychainIDFV.h
//  SQToolsGather
//
//  Created by Avazu Holding on 2017/8/24.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface KeychainIDFV : NSObject

/**
 *  获取 存储的 idfv
 */
+ (NSString *)getkeychainIDFV;

@end
