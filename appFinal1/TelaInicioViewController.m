//
//  TelaInicioViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 15/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaInicioViewController.h"

#import "LocalStore.h"

@interface TelaInicioViewController ()

@end

@implementation TelaInicioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[self navigationItem] setTitle:@"Bandburst"];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

@end
