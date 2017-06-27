//
//  ViewController.m
//  tools
//
//  Created by chang on 2017/6/23.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Handle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIImage combinationImageWithbackgroundImage:[UIImage imageNamed:@"1.jpeg"] foregroundImage:[UIImage imageNamed:@"01.png"] size:CGSizeMake(40, 60) contentMode:UIViewContentModeTop complitionHandler:^(UIImage *combinationImage, NSError *error) {
        UIImageView *imv  = [[UIImageView alloc] initWithImage:combinationImage];
        [imv setFrame:CGRectMake(200, 200, 80, 120)];
        [self.view addSubview:imv];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
