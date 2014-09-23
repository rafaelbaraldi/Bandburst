//
//  TelaBandaViewController.m
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 07/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaBandaViewController.h"

#import "BandaStore.h"
#import "LocalStore.h"
#import "TPMensagem.h"

#import "TelaInfosBandaViewController.h"

@interface TelaBandaViewController ()

@end

@implementation TelaBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //BG - Layout
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
}

-(void)dadosBanda{
    [[self navigationController] pushViewController:[[TelaInfosBandaViewController alloc] initWithNibName:@"TelaInfosBandaViewController" bundle:nil] animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega banda Atual
    _banda = [BandaStore buscaBanda:[[BandaStore sharedStore] idBandaSelecionada]];
    
    //Recarrega as Mensagens da tela
    [_tbMensagens reloadData];
    
    [self carregaTituloNavigationBarCustom];
}

-(void)carregaTituloNavigationBarCustom{
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:_banda.nome forState:UIControlStateNormal];
    [button setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dadosBanda) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    [[self navigationItem] setTitleView:button];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_banda.mensagens count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mensagemCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mensagemCell"];
    }
    
    NSString *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]).mensagem;
    
    cell.textLabel.text = msg;
    
    return cell;
}

- (IBAction)txtMensagemSend:(id)sender {
    [sender resignFirstResponder];
    
    NSLog(@"%@", [BandaStore enviaMensagem:[sender text] idBanda:_banda.identificador idUsuario:[[LocalStore sharedStore] usuarioAtual].identificador]);
    
    [sender setText:@""];
    
    [self recarregaMensagens];
}

-(void)recarregaMensagens{
    [_banda setMensagens:[BandaStore buscaMensagensBanda:_banda.identificador]];
    
    [_tbMensagens reloadData];
}


@end
