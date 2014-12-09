//
//  TelaBandaViewController.h
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 07/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPBanda.h"

@interface TelaBandaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property TPBanda* banda;

@property (strong, nonatomic) IBOutlet UITableView *tbMensagens;

- (IBAction)btnEnviarClick:(id)sender;
- (IBAction)txtMensagemSend:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtMensagem;
@property (strong, nonatomic) IBOutlet UIButton *btnEnviar;

@end
