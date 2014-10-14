//
//  TelaEsqueciSenhaViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 11/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaEsqueciSenhaViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView *lblMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnProcurar;
@property (strong, nonatomic) IBOutlet UITextView *txtInfo;

- (IBAction)btnProcurarClick:(id)sender;

@end
