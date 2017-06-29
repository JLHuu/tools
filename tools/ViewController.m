//
//  ViewController.m
//  tools
//
//  Created by chang on 2017/6/23.
//  Copyright © 2017年 HJL. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Handle.h"
#import "NSString+DES.h"

@interface ViewController ()
@property(nonatomic,strong)UIImageView *imv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imv = [[UIImageView alloc] init];
    [self.view addSubview:self.imv];
    NSDate *date = [NSDate date];
    [[UIImage imageNamed:@"1.jpeg"] changeImageColorWithColor:[UIColor purpleColor] finished:^(UIImage *newImg, NSError *error) {
        if (!error) {
            [UIImage combinationImageWithbackgroundImage:newImg foregroundImage:[[UIImage imageNamed:@"01.png"] changeImageColorWithColor:[UIColor whiteColor] error:NULL] size:CGSizeMake(40, 60) contentMode:UIViewContentModeTop complitionHandler:^(UIImage *combinationImage, NSError *error) {
                printf("耗时:%f",[[NSDate date] timeIntervalSinceDate:date]);
                [self.imv setImage:combinationImage];
                [self.imv setFrame:CGRectMake(30, 100, combinationImage.size.width, combinationImage.size.height)];
            }];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
