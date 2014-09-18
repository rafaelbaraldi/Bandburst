//
//  TelaInicioViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 15/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaInicioViewController : UIViewController

- (IBAction)btnCadastrarClick:(id)sender;
- (IBAction)btnEntrarClick:(id)sender;
- (IBAction)btnLoginClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnCadastrar;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnEntrar;

@end
