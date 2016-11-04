//
//  ALiAlertView.m
//  ALiAlertView
//
//  Created by LeeWong on 2016/11/4.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#define lineColor [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
#define buttonTitleColor [UIColor colorWithRed:4./255.0 green:124./255.0 blue:255./255.0 alpha:1.0f]
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "ALiAlertView.h"
#import <CoreMotion/CoreMotion.h>

const static CGFloat kDefaultButtonHeight       = 44;
const static CGFloat kDefaultLineHeightOrWidth  = 1;
const static CGFloat kDefaultCornerRadius       = 13;
const static CGFloat kDefaultAlertWidth         = 270;
const static CGFloat kDefaultHeaderHeight       = 60;

@interface ALiAlertView ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;

@property (nonatomic, strong) UIView *containerView;
@end

@implementation ALiAlertView

#pragma mark - Public Method

- (void)show
{}

- (void)dismiss{}


#pragma mark - Load View

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.9;
        self.orientation = UIInterfaceOrientationPortrait;
        self.roattionEnable = YES;
        self.tapDismissEnable = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if([self.motionManager isAccelerometerAvailable] && self.roattionEnable){
        [self orientationChange];
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    if (self.motionManager) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - Private Method

- (CGSize)screenSize
{
    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
        
        return CGSizeMake(SCREEN_W,SCREEN_H);
    } else {
     return CGSizeMake(SCREEN_H,SCREEN_W);
    }
    return CGSizeZero;
}

- (CGSize)containerSize
{
    return CGSizeMake(kDefaultAlertWidth, kDefaultButtonHeight + kDefaultHeaderHeight);
}

#pragma mark - 键盘处理
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self screenSize];
    CGSize dialogSize = [self containerSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self screenSize];
    CGSize dialogSize = [self containerSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

#pragma mark - 点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.tapDismissEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[ALiAlertView class]]) {
        [self dismiss];
    }
}

#pragma mark - 屏幕方向旋转
- (void)orientationChange
{
    WEAKSELF(weakSelf);
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        __block UIInterfaceOrientation orientation;
        if (acceleration.x >= 0.75) {
            orientation = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientation = UIInterfaceOrientationLandscapeRight;
            
        }
        else if (acceleration.y <= -0.75) {
            orientation = UIInterfaceOrientationPortrait;
            
        }
        else if (acceleration.y >= 0.75) {
            orientation = UIInterfaceOrientationPortraitUpsideDown;
            return ;
        }
        else {
            // Consider same as last time
            return;
        }
        
        if (orientation != weakSelf.lastOrientation) {
            [weakSelf configHUDOrientation:orientation];
            weakSelf.lastOrientation = orientation;
            NSLog(@"%tu=-------%tu",orientation,weakSelf.lastOrientation);
        }
        
    }];
}

- (void)configHUDOrientation:(UIInterfaceOrientation )orientation
{
    CGFloat angle = [self calculateTransformAngle:orientation];
    self.transform = CGAffineTransformRotate(self.transform, angle);
}


- (CGFloat)calculateTransformAngle:(UIInterfaceOrientation )orientation
{
    CGFloat angle;
    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
        switch (orientation) {
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeRight) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = M_PI;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeLeft) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI;
                break;
            default:
                break;
        }
    }
    return angle;
}

#pragma mark - Lazy Load
- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1./15.;
        
    }
    return _motionManager;
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        CGSize screen = [self screenSize];
        CGSize container = [self containerSize];
        _containerView = [[UIView alloc] initWithFrame:CGRectMake((screen.width - container.width)/2., (screen.height - container.height)/2., container.width,container.height)];
    }
    return _containerView;
}

@end
