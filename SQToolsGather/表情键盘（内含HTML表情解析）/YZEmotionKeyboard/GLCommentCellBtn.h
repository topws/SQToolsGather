//
//  GLCommentCellBtn.h
//  GuluGulu
//
//  Created by qianwei on 17/3/10.
//  Copyright © 2017年 morningtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLCommentCellBtn : UIButton

@property (nonatomic,copy)NSString * userID;

@property (nonatomic,copy)void (^btnClickBlock)(NSString *);
@end
