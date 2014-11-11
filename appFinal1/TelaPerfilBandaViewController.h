//
//  TelaPerfilBandaViewController.h
//  Bandburst
//
//  Created by RAFAEL BARALDI on 21/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPBanda.h"

@interface TelaPerfilBandaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property BOOL visualizandoMembros;

@property TPBanda* banda;

@property int xImage;
@property int xLbl;

@property UIActionSheet *alerta;

@property NSMutableArray* removerMembro;

@property (strong, nonatomic) IBOutlet UITableView *tbMembros;
@property (strong, nonatomic) IBOutlet UITableView *tbMusicas;

@property (strong, nonatomic) IBOutlet UIButton *btnEditar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segTabela;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;
@property (strong, nonatomic) IBOutlet UITextField *lblNome;
@property (strong, nonatomic) IBOutlet UIButton *btnAdicionarGravacao;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMembro;
@property (weak, nonatomic) IBOutlet UIButton *btnAlterarAdm;

- (IBAction)segTabelaChange:(id)sender;
- (IBAction)btnCharClick:(id)sender;
- (IBAction)btnAdicionarGravacaoClick:(id)sender;
- (IBAction)btnEditarClick:(id)sender;
- (IBAction)btnAddMembro:(id)sender;
- (IBAction)btnAlterarAdm:(id)sender;

@end
