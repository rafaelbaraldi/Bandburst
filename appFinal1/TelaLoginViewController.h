//
//  TelaLoginViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaLoginViewController : UIViewController <UITextFieldDelegate>

@property UITabBarController* tabBar;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;
@property (strong, nonatomic) IBOutlet UIButton *lblEsqueceuSenha;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *target;

- (IBAction)btnSenhaClick:(id)sender;
- (IBAction)btnContinuarClick:(id)sender;
- (IBAction)btnCadastrarClick:(id)sender;
- (IBAction)btnEntrarClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnContinuar;
@property (strong, nonatomic) IBOutlet UIButton *btnCadastrar;
@property (strong, nonatomic) IBOutlet UIButton *btnEntrar;

@end
