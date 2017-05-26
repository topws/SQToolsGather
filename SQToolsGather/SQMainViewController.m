//
//  SQMainViewController.m
//  SQGatherTools
//
//  Created by qianwei on 2017/5/24.
//  Copyright © 2017年 qianwei. All rights reserved.
//

#import "SQMainViewController.h"

@interface SQMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView  * tab;

@property (nonatomic,strong)NSArray * dataArr;
@end

@implementation SQMainViewController
-(UITableView *)tab{
    if (_tab == nil) {
        _tab = [[UITableView alloc]initWithFrame:self.view.bounds];
        
        _tab.delegate = self;
        _tab.dataSource = self;
        
        [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tab;
}
-(NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = @[@[@"图形绘制",@"SQDrawViewTools"],
                     @[@"图片选择器和查看器（输入框为表情键盘）",@"SQImagePickerViewController"]];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"主功能";
    self.tabBarItem.title = @"TabBarName";
    
    [self.view addSubview:self.tab];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.row < self.dataArr.count) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.dataArr[indexPath.row] firstObject]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = NSClassFromString([NSString stringWithFormat:@"%@", [self.dataArr[indexPath.row] lastObject]]);
    UIViewController * classVc = [[class alloc]init];;
    classVc.title = [NSString stringWithFormat:@"%@",[self.dataArr[indexPath.row] firstObject]];
    [self.navigationController pushViewController:classVc animated:YES];
    
}

@end
