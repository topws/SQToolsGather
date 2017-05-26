//
//  SQDrawViewTools.m
//  SQGatherTools
//
//  Created by qianwei on 2017/5/24.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "SQDrawViewTools.h"

@interface SQDrawViewTools ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tab;

@property (nonatomic,strong)NSArray * dataArr;
@end

@implementation SQDrawViewTools
-(UITableView *)tab{
    if (_tab == nil) {
        _tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tab.delegate = self;
        _tab.dataSource = self;
        
        [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tab;
}
-(NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@"绘制部分圆角",@"创建View绘制一张图片"];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tab];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect frame = CGRectMake(50, 300, 80, 80);
    
    if (indexPath.row == 0) {
        
        UIView *view2 = [[UIView alloc] initWithFrame:frame];
        view2.backgroundColor = [UIColor redColor];
        [self.view addSubview:view2];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view2.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view2.bounds;
        maskLayer.path = maskPath.CGPath;
        view2.layer.mask = maskLayer;
     
        //移除这个绘图
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view2 removeFromSuperview];
        });
    }
   
    if (indexPath.row == 1) {
        UILabel * nameLB = [[UILabel alloc]init];
        nameLB.text = @"View绘制图片";
        //    nameLB.textColor = textColor;
        nameLB.font = [UIFont systemFontOfSize:17];
        [nameLB sizeToFit];
        nameLB.textAlignment = NSTextAlignmentCenter;
        
        UIGraphicsBeginImageContextWithOptions(nameLB.bounds.size, NO, [UIScreen mainScreen].scale);
        CGRect rect = CGRectMake(0, 0, nameLB.bounds.size.width, nameLB.bounds.size.height);
        [nameLB drawViewHierarchyInRect:rect afterScreenUpdates:YES];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:image];
        imageV.backgroundColor = [UIColor redColor];
        imageV.frame = CGRectMake(50, 300, nameLB.bounds.size.width, nameLB.bounds.size.height);
        [self.view addSubview:imageV];
        
        //移除这个绘图
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageV removeFromSuperview];
        });
    }
}



@end
