//
//  TelaCadastroViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 15/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaCadastroViewController : UIViewController <UITextFieldDelegate>

//Views
@property (strong, nonatomic) IBOutlet UILabel *lblCabecalho;
@property (strong, nonatomic) IBOutlet UILabel *lblInstrumentos;
@property (strong, nonatomic) IBOutlet UILabel *lblEstilos;

@property (strong, nonatomic) IBOutlet UITextField *txtNome;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtSenha;
@property (strong, nonatomic) IBOutlet UITextField *txtCidade;
@property (strong, nonatomic) IBOutlet UITextField *txtBairro;
@property (strong, nonatomic) IBOutlet UITextField *txtObservacoes;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segGenero;

@property (strong, nonatomic) IBOutlet UIButton *btnInstrumentos;
@property (strong, nonatomic) IBOutlet UIButton *btnEstilos;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirmar;
@property (weak, nonatomic) IBOutlet UIButton *btnHorarios;

@property BOOL ehEdicao;

//Actions View Principal
- (IBAction)btnInstrumentosClick:(id)sender;
- (IBAction)btnEstilosClik:(id)sender;
- (IBAction)btnConfirmarClick:(id)sender;
- (IBAction)btnHorariosClick:(id)sender;
- (IBAction)txtEmailDidEnd:(id)sender;

@end
