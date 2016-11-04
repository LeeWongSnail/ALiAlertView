//
//  ALiAlertView.h
//  ALiAlertView
//
//  Created by LeeWong on 2016/11/4.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiAlertView : UIView


/**
 是否允许根据重力感应调整弹窗的方向
 */
@property (nonatomic, assign) BOOL roattionEnable;


/**
 是否允许点击弹窗之外的区域让弹窗消失
 */
@property (nonatomic, assign) BOOL tapDismissEnable;


/**
 设置弹窗的方向
 注意这个属性不可以和roattionEnable同时使用，如果同时设置默认使用重力感应
 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;


/**
 显示AlertView
 */
- (void)show;


/**
 隐藏AlertView
 */
- (void)dismiss;

@end
