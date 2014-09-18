//
//  TelaLoginViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtSenha;

- (IBAction)btnSenhaClick:(id)sender;
- (IBAction)btnContinuarClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnContinuar;

@end
