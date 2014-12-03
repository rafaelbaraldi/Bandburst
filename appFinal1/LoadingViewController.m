//
//  LoadingViewController.m
//  Bandburst
//
//  Created by Rafael Cardoso on 19/11/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Load
    UIActivityIndicatorView *load = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [load setCenter:CGPointMake(self.view.center.x - 140, self.view.center.y)];
    [load startAnimating];
    
    
    [self.view addSubview:load];
    
    //Bloquea o acesso do usuario na View
    [self.view setUserInteractionEnabled:YES];
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
