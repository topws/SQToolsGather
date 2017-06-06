//
//  SystemShareDemoViewController.m
//  SQToolsGather
//
//  Created by qianwei on 2017/6/6.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "SystemShareDemoViewController.h"
#import "TSShareHelper.h"
@interface SystemShareDemoViewController ()

@end

@implementation SystemShareDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"advices"];
    [TSShareHelper shareWithType:TSShareHelperShareTypeWeChat andController:self andItems:@[img]];
}

@end
