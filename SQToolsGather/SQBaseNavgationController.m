//
//  SQBaseNavgationController.m
//  SQAlert
//
//  Created by qianwei on 17/3/28.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "SQBaseNavgationController.h"

@interface SQBaseNavgationController ()

@end

@implementation SQBaseNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        //替换所有的 Nav 的返回按钮
        viewController.navigationItem.leftBarButtonItem = [SQBaseNavgationController itemWithTarget:self action:@selector(pop) image:@"guluback" highImage:@"guluback"];
    }
    
    [super pushViewController:viewController animated:animated];
}
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.frame = CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)pop {
    [self popViewControllerAnimated:YES];
}




@end
