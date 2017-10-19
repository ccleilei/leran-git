//
//  coreAnimateViewController.m
//  Run loops
//
//  Created by 晓磊 on 2017/10/19.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "coreAnimateViewController.h"

@interface coreAnimateViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation coreAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 64,  [UIScreen mainScreen].bounds.size.width, 200)];
    head.backgroundColor = [UIColor redColor];
    [self.view addSubview:head];
    
    
    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 264, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-164) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
            
        default:
            break;
    }
    return cell;
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
