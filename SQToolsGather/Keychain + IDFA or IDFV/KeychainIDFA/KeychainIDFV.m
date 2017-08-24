//
//  KeychainIDFV.m
//  SQToolsGather
//
//  Created by Avazu Holding on 2017/8/24.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "KeychainIDFV.h"
#import "KeychainHelper.h"
@import AdSupport;

#define kIsStringValid(text) (text && text!=NULL && text.length>0)
#define KeychainIdfv @"Keychain_idfv_avazu_shop"

@implementation KeychainIDFV

+ (NSString*)getkeychainIDFV
{
    //0.读取keychain的缓存
    NSString *deviceID = [KeychainIDFV getIdfvString];
    if (kIsStringValid(deviceID))
    {
        return deviceID;
    }
    else
    {
        //1.取idfv
        
        NSString * idfv = [KeychainIDFV getIDFV];
        
        if (!kIsStringValid(idfv)) {
            
            //2.如果取不到,就生成UUID,当成IDFV
            idfv = [KeychainIDFV getUUID];
        }
        
        //存储
        [self setIdfvString:idfv];
        
        return idfv;
        
    }
}

#pragma mark - Keychain
+ (NSString*)getIdfvString
{
    NSString *idfaStr = [KeychainHelper load:KeychainIdfv];
    if (kIsStringValid(idfaStr))
    {
        return idfaStr;
    }
    else
    {
        return nil;
    }
}

+ (BOOL)setIdfvString:(NSString *)secValue
{
    if (kIsStringValid(secValue))
    {
        [KeychainHelper save:KeychainIdfv data:secValue];
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - get IDFV
+ (NSString *)getIDFV
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark - UUID
+ (NSString*)getUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuid_string_ref= CFUUIDCreateString(kCFAllocatorDefault, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    if (!kIsStringValid(uuid))
    {
        uuid = @"";
    }
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end
