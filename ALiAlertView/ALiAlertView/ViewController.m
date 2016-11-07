//
//  ViewController.m
//  ALiAlertView
//
//  Created by LeeWong on 2016/11/4.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "ALiAlertView.h"

@interface ViewController ()
@property (nonatomic, strong) ALiAlertView *alert;
@end

@implementation ViewController
- (IBAction)dismiss:(UIButton *)sender {
    [self.alert dismiss];
    [self.alert removeFromSuperview];
    self.alert = nil;

}
- (IBAction)show:(UIButton *)sender {
    self.alert = [[ALiAlertView alloc] initWithTitle:@"是否确认执行此操作,是否确认执行此操作是否确认执行此操作是否确认执行此操作是否确认执行此操作"];
    [self.alert show];
}
- (IBAction)customView:(UIButton *)sender {
    self.alert = [[ALiAlertView alloc] init];
    self.alert.contentView = [self tableView];
    [self.alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
}


- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.image = [UIImage imageNamed:@"1"];
    [view addSubview:imageView];
    return view;
}

- (UITableView *)tableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor greenColor];
    return table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
