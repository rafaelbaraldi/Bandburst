//
//  TelaUsuarioFiltrado.h
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 27/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPUsuario.h"

@interface TelaUsuarioFiltrado : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSString *identificador;
@property TPUsuario *pessoa;

@property (strong, nonatomic) IBOutlet UILabel *lblNome;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblCidade;
@property (weak, nonatomic) IBOutlet UILabel *lblBairro;


@property (weak, nonatomic) IBOutlet UITextView *lblAtribuicoes;

@property NSMutableArray *dadosUsuarios;
@property NSMutableArray *horarios;
@property (weak, nonatomic) IBOutlet UIImageView *estrela;

@property (weak, nonatomic) IBOutlet UIImageView *imageUsuario;

@property (weak, nonatomic) IBOutlet UIButton *btnSeguir;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tbDados;

- (IBAction)btnSeguirClick:(id)sender;

-(id)initWithIdentificador:(NSString*)idUsuario;

@end
