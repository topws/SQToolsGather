//
//  SQTabBarController.m
//  SQAlert
//
//  Created by qianwei on 17/3/27.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "SQTabBarController.h"

#import "SQBaseNavgationController.h"
#import "SQMainViewController.h"
#import "SQMeViewController.h"
@interface SQTabBarController ()

@end

@implementation SQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self addChildVc];

}
-(void)addChildVc{
    SQMainViewController * main = [[SQMainViewController alloc]init];
    [self addChildVc:main addTitle:@"主页" addNormarlImage:@"gray_home" addSelectImage:@"home"];
    SQMeViewController * me = [[SQMeViewController alloc]init];
    [self addChildVc:me addTitle:@"我的" addNormarlImage:@"gray_personal" addSelectImage:@"personal"];
    
}
-(void)addChildVc:(UIViewController *)vc addTitle:(NSString *)title addNormarlImage:(NSString *)normarlImageName addSelectImage:(NSString *)selectImageName{
    
    /*
     *  同时添加了 TabBar和NavigationItem的title
     */
    vc.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:normarlImageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary * titleAttributeDic = [NSMutableDictionary dictionary];
    
    [titleAttributeDic setValue:kMainGreenColor forKey:NSForegroundColorAttributeName];
    [vc.tabBarItem setTitleTextAttributes:titleAttributeDic forState:UIControlStateSelected];
    
    SQBaseNavgationController * nav = [[SQBaseNavgationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
