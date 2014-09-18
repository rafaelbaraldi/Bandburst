//
//  TelaUsuarioFiltrado.h
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 27/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPUsuario.h"

@interface TelaUsuarioFiltrado : UIViewController <UIScrollViewDelegate>

@property NSString *identificador;
@property TPUsuario *pessoa;

@property (strong, nonatomic) IBOutlet UILabel *lblNome;
@property (strong, nonatomic) IBOutlet UILabel *lblSexo;
@property (strong, nonatomic) IBOutlet UILabel *lblCidadeBairro;
@property (strong, nonatomic) IBOutlet UILabel *lblEstilo;
@property (weak, nonatomic) IBOutlet UILabel *lblAtribuicoes;
@property (strong, nonatomic) IBOutlet UILabel *lblTituloAtribuicoes;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageUsuario;

@property (weak, nonatomic) IBOutlet UILabel *lblInstrumentos;

@property (weak, nonatomic) IBOutlet UIButton *btnSeguir;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnSeguirClick:(id)sender;


-(id)initWithIdentificador:(NSString*)idUsuario;

@end
