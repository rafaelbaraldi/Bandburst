//
//  TelaPerfilBandaViewController.m
//  Bandburst
//
//  Created by RAFAEL BARALDI on 21/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaPerfilBandaViewController.h"
#import "BandaStore.h"
#import "TPUsuario.h"
#import "TPMusica.h"
#import "LocalStore.h"
#import "TelaBandaViewController.h"
#import "TelaMusicasViewController.h"

#import "GravacaoStore.h"

#import "UIImageView+WebCache.h"

const int ALERTA_TROCAR_ADMINISTRADOR = 0;
const int ALERTA_SAIR = 1;
const int ALERTA_REMOVER_MEMBRO = 2;
const int ALERTA_REMOVER_MUSICA = 3;
const int ALERTA_EXCLUIR_BANDA = 4;

@interface TelaPerfilBandaViewController ()

@end

@implementation TelaPerfilBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _visualizandoMembros = YES;
        _tbMusicas.hidden = YES;
        _alertasEdicao = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    
    _banda = [[BandaStore sharedStore] bandaSelecionada];
    
    [[self navigationItem] setTitle:@"Banda"];
    
    //Alterando ADM
    [[BandaStore sharedStore] setAlterandoAdm:NO];
    
    //Carrega dados da Banda
    [_tbMembros reloadData];
    [_tbMusicas reloadData];
 
    //Carrega nome da Banda
    _lblNome.text = _banda.nome;
    [_lblNome sizeToFit];
    
    //Navigation Controller
    [[self navigationItem] setTitle:@"Banda"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
    
    //Arruma edtiando
    if([[BandaStore sharedStore] editando] && _addMembro == NO){
        [self btnEditarClick:nil];
    }
    
    //Gamb verifica se vai para tela de add membro
    _addMembro = NO;
    
    [_tbMembros reloadData];
    [_tbMusicas reloadData];
}

-(void)carregaLayout{
    //Editar Banda
    [[BandaStore sharedStore] setEditando:NO];
    
    //Alerta
    _banda = [[BandaStore sharedStore] bandaSelecionada];
    [self carregaAlertaDeEdicao];
    
    //Esconde linhas em branco da TableView
    _tbMembros.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMembros.separatorColor = [UIColor clearColor];
    
    //Muscias
    _tbMusicas.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMusicas.separatorColor = [UIColor clearColor];
    
    //Add membro
    _btnAddMembro.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnAddMembro.layer.cornerRadius = [[LocalStore sharedStore] RAIOBORDA];
    
    //Add Musica
    _btnAdicionarGravacao.layer.cornerRadius = [[LocalStore sharedStore] RAIOBORDA];
    _btnAdicionarGravacao.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    //Alterar membro
    _btnAlterarAdm.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnAlterarAdm.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAlterarAdm setTitle: @"Trocar\nadministrador" forState: UIControlStateNormal];
    
    //Nome da banda
    [_lblNome setUserInteractionEnabled:NO];
    _lblNome.layer.borderWidth = 2.0f;
    _lblNome.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblNome.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblNome.layer.cornerRadius = [[LocalStore sharedStore] RAIOTEXT];
    
    //Editar
    [_btnEditar setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    [[_btnEditar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    //Chat
    [[_btnChat titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    NSDictionary* atributos = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16], NSFontAttributeName, nil];
    [_segTabela setTitleTextAttributes:atributos forState:UIControlStateNormal];
    _segTabela.tintColor = [[LocalStore sharedStore] FONTECOR];
}

-(void)carregaAlertaDeEdicao{
    
    UIActionSheet* alertaTrocaAdm = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Tem certeza que deseja trocar o administrador da banda %@?", _banda.nome] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, trocar adminsitrador", nil];
    
    UIActionSheet* alertaRemoverMembro = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, remover membro", nil];
    
    UIActionSheet* alertaRemoverMusica = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, remover música", nil];
    
    UIActionSheet* alertaSair = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, sair da banda", nil];
    
    UIActionSheet* alertaExcluirBanda = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, excluir banda", nil];
    
    [_alertasEdicao addObject:alertaTrocaAdm];
    [_alertasEdicao addObject:alertaSair];
    [_alertasEdicao addObject:alertaRemoverMembro];
    [_alertasEdicao addObject:alertaRemoverMusica];
    [_alertasEdicao addObject:alertaExcluirBanda];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelulaDeMembros"];
        
        //URL Foto do Usuario
        NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador];
        NSURL *imageURL = [NSURL URLWithString:urlFoto];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CelulaDeMembros"];
            
            //Carrega Posição das view
            [self carregaPosicaoViewsTabela];
            if([((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador isEqualToString:_banda.idAdm]){
                _xImage = 5;
                _xLbl = 50;
            }
            
            //Nome
            UILabel* nome = [[UILabel alloc] initWithFrame:CGRectMake(_xLbl, 0, 165, 60)];
            nome.text = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome;
            nome.tag = 1;
            nome.numberOfLines = 2;
            nome.lineBreakMode = YES;
            nome.font = [nome.font fontWithSize:14];
            [nome setTextColor:[[LocalStore sharedStore] FONTECOR]];
            
            [cell addSubview:nome];

            //Administrador
            UILabel* adm = [[UILabel alloc] initWithFrame:CGRectMake(225, 15, 80, 30)];
            adm.textColor = [UIColor colorWithRed:1 green:0.231 blue:0.188 alpha:1];
            adm.font = [adm.font fontWithSize:11];
            adm.tag = 3;
            
            if([((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador isEqualToString:_banda.idAdm]){
                adm.text = @"Administrador";
            }
            else{
                adm.text = @"";
            }
            [cell addSubview:adm];
            
            //Foto
            UIImageView* foto = [[UIImageView alloc] initWithFrame:CGRectMake(_xImage, 10, 40, 40)];
            foto.layer.masksToBounds = YES;
            foto.layer.cornerRadius =  foto.frame.size.width / 2;
            foto.tag = 2;
            
            //Carrega foto com THREAD
            [foto sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                                       }];
            
            [cell addSubview:foto];
        }
        else{
            UILabel* adm = (UILabel*)[cell viewWithTag:3];
            if([((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador isEqualToString:_banda.idAdm]){
                adm.text = @"Administrador";
            }else{
                adm.text = @"";
            }
            
            //Poisicoes
            [self carregaPosicaoViewsTabela];
            if([((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador isEqualToString:_banda.idAdm]){
                _xImage = 5;
                _xLbl = 50;
            }

            //Nome
            UILabel* nome = (UILabel*)[cell viewWithTag:1];
            nome.text = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome;
            nome.frame = CGRectMake(_xLbl, 0, 165, 60);
            
            //Carrega foto com THREAD
            UIImageView* foto = (UIImageView*)[cell viewWithTag:2];
            foto.frame = CGRectMake(_xImage, 10, 40, 40);
            [foto sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                           }];
        }
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelulaDeMusicas"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CelulaDeMembros"];
            
            //Carrega Posição das view
            [self carregaPosicaoViewsTabela];
            
            UILabel* musica = [[UILabel alloc] initWithFrame:CGRectMake(_xLbl, 15, 200, 30)];
            [musica setText:[self carregaNomeMusica:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]).url]];
            [musica setFont:[musica.font fontWithSize:14]];
            [musica setTextColor:[[LocalStore sharedStore] FONTECOR]];
            [musica setTag:1];
            [cell addSubview:musica];
            
            UIImageView* som = [[UIImageView alloc] initWithFrame:CGRectMake(_xImage, 15, 40, 30)];
            [som setImage:[UIImage imageNamed:@"audio.png"]];
            [som setTag:2];
            [cell addSubview:som];
            
            UIImageView* play = [[UIImageView alloc] initWithFrame:CGRectMake(265, 12, 35, 35)];
            [play setImage:[UIImage imageNamed:@"playing.png"]];
            [play setTag:3];
            [cell addSubview:play];
        }
        else{
            UILabel* musica = (UILabel*)[cell viewWithTag:1];
            [musica setText:[self carregaNomeMusica:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]).url]];
        }
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
}

-(UIImage*)carregaImagemFake{
    
    UIImageView *fotoUsuario = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 80, 80)];
    fotoUsuario.image = [UIImage imageNamed:@"placeholderFoto.png"];
    fotoUsuario.layer.masksToBounds = YES;
    fotoUsuario.layer.cornerRadius = fotoUsuario.frame.size.width / 2;
    fotoUsuario.tag = 4;
    
    return fotoUsuario.image;
}

-(NSString*)carregaNomeMusica:(NSString*)url{
    
    NSString* nomeMusica =  url;
    
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    
    nomeMusica = [nomeMusica substringToIndex:nomeMusica.length-4];
    
    return nomeMusica;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return _banda.membros.count;
    }
    else{
        return _banda.musicas.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TAG 1 -> INTEGRANTES DA BANDA
    if (tableView.tag == 1) {
        TelaUsuarioFiltrado* vc = [[TelaUsuarioFiltrado alloc] initWithIdentificador:((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador];
        
        if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
            [[self navigationController] popToViewController:vc animated:NO];
        }
        else{
            [[self navigationController] pushViewController:vc animated:NO];
        }
    }
    else{        
        //Sets GravacaoStore
        [[GravacaoStore sharedStore] setGravacaoStreaming:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row])];
        [[GravacaoStore sharedStore] setStreaming:YES];
        
        if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaPlayer]]) {
            [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
        }
        else{
            [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
        }
    }
}

//Não habilitar edição para o Administrador
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //TAG 1 -> INTEGRANTES DA BANDA
    if (tableView.tag == 1) {
        if(![((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador isEqualToString:_banda.idAdm]){
            return UITableViewCellEditingStyleDelete;
        }
        else{
            return UITableViewCellEditingStyleNone;
        }
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (IBAction)segTabelaChange:(id)sender {
    _visualizandoMembros = !_visualizandoMembros;
    
    if (_visualizandoMembros) {
        _tbMembros.hidden = NO;
        
        if([[BandaStore sharedStore] editando] && [self verificaSeAdmBanda]){
             _btnAddMembro.hidden = NO;
        }
        
        _tbMusicas.hidden = YES;
        _btnAdicionarGravacao.hidden = YES;
    }
    else{
        //Visualizando Músicas
        _tbMembros.hidden = YES;
        _btnAddMembro.hidden = YES;
        
        _tbMusicas.hidden = NO;
        _btnAdicionarGravacao.hidden = NO;
    }
}

- (IBAction)btnCharClick:(id)sender {
    TelaBandaViewController* vc = [[LocalStore sharedStore] TelaBanda];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
        [[self navigationController] popToViewController:vc animated:NO];
    }
    else{
        [[self navigationController] pushViewController:vc animated:NO];
    }
}

- (IBAction)btnAdicionarGravacaoClick:(id)sender {
    
    TelaMusicasViewController *vc = [[TelaMusicasViewController alloc] initWithNibName:@"TelaMusicasViewController" bundle:nil];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
        [[self navigationController] popToViewController:vc animated:NO];
    }
    else{
        [[self navigationController] pushViewController:vc animated:NO];
    }
}

-(BOOL)verificaSeAdmBanda{
    
    if([_banda.idAdm isEqualToString:[[LocalStore sharedStore] usuarioAtual].identificador]){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)carregaPosicaoViewsTabela{
    
    if(_tbMembros.isEditing && _tbMusicas.isEditing){
        _xImage = 50;
        _xLbl = 95;
    }
    else{
        _xImage = 5;
        _xLbl = 50;
    }
}

-(void)posicionaViewTable :(UITableView*)table{
    
    _tbMembros.tag = 1;
    
    for (int i = 0; i < [table numberOfRowsInSection:0]; i++){
        
        [self carregaPosicaoViewsTabela];
        
        if(table.tag == 1){
            if([((TPUsuario*)[_banda.membros objectAtIndex:i]).identificador isEqualToString:_banda.idAdm ]){
                _xImage = 5;
                _xLbl = 50;
            }
        }
        
        UITableViewCell *c = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImageView *image = (UIImageView*)[c viewWithTag:2];
        image.frame = CGRectMake(_xImage, image.frame.origin.y , image.frame.size.width , image.frame.size.height);
        
        UILabel *lbl = (UILabel*)[c viewWithTag:1];
        lbl.frame = CGRectMake(_xLbl, lbl.frame.origin.y , lbl.frame.size.width , lbl.frame.size.height);
    }
}

- (IBAction)btnEditarClick:(id)sender {
    
    BOOL admBanda = [self verificaSeAdmBanda];
    
    //Em editação
    if ([[BandaStore sharedStore] editando]) {
        [[BandaStore sharedStore] setEditando:NO];
    }
    else{
        [[BandaStore sharedStore] setEditando:YES];
    }
    
    if(admBanda){
        if([[BandaStore sharedStore] editando]){
            
            //Alterar nome
            [_lblNome setUserInteractionEnabled:YES];
            _lblNome.layer.borderColor = [[LocalStore sharedStore] FONTECOR].CGColor;
            
            //Saida banda adm
            UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(saidaBanda)];
            [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
            
            //Remover Musicas e Membros
            _tbMembros.editing = YES;
            _tbMusicas.editing = YES;
            [self posicionaViewTable:_tbMembros];
            [self posicionaViewTable:_tbMusicas];
            
            //Add Membro
            if(_tbMusicas.hidden){
                 _btnAddMembro.hidden = NO;
            }
            
            //Alterar adm
            _btnAlterarAdm.hidden = NO;
        }
    }
    else{
        //Sair da banda
        UIImage *imgSaida = [UIImage imageNamed:@"sair.png"];
        UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithImage:imgSaida style:UIBarButtonItemStylePlain target:self action:@selector(saidaBanda)];
        [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
    }
    
    //Editando ou não
    if(![[BandaStore sharedStore] editando]){
        
        //Alterar nome
        [_lblNome setUserInteractionEnabled:NO];
        _lblNome.layer.borderColor = [UIColor whiteColor].CGColor;
        
        //Remover Musicas e Membros
        _tbMembros.editing = NO;
        _tbMusicas.editing = NO;
        [self posicionaViewTable:_tbMembros];
        [self posicionaViewTable:_tbMusicas];
    
        //Saida banda - remove da tela
        [self.navigationItem setRightBarButtonItem:nil];
        
        //Add Membro
        _btnAddMembro.hidden = YES;
        
        //Alterar adm
        _btnAlterarAdm.hidden = YES;
        
        //Botao editar
        [_btnEditar setTitle:@"Editar" forState:UIControlStateNormal];
        
        //Confirmar alteraçao do Nome
        if (![_banda.nome isEqualToString:_lblNome.text]) {
            [BandaStore  alterarDados:@"alterar_nome" dado:_lblNome.text idBanda:_banda.identificador];
        }
    }
    else{
        //Botao Editar
        [_btnEditar setTitle:@"Concluído" forState:UIControlStateNormal];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIActionSheet *alert;
    
    //TAG 1 -> INTEGRANTES DA BANDA
    if (tableView.tag == 1) {
        //Alert
        alert = [_alertasEdicao objectAtIndex:ALERTA_REMOVER_MEMBRO];
        alert.title = [NSString stringWithFormat:@"Tem certeza que deseja remover %@ da banda %@?", ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome, _banda.nome];
        
        //Salva membro se for remover
        _usuarioRemover = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]);
    }
    else{
        //Alert
        alert = [_alertasEdicao objectAtIndex:ALERTA_REMOVER_MUSICA];
        alert.title = [NSString stringWithFormat:@"Tem certeza que deseja remover %@ da banda %@?", [self carregaNomeMusica:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]).url], _banda.nome];
        
        //Salva musica se for remover
        _musicaRemover = ((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]);
    }
    
    [alert showInView:self.view];
}

- (IBAction)btnAddMembro:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaAmigos] animated:YES];
    _addMembro = YES;
}

- (IBAction)btnAlterarAdm:(id)sender {
    
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaAmigos] animated:YES];
    [[BandaStore sharedStore] setAlterandoAdm:YES];
    
//    UIActionSheet *alert = [_alertasEdicao objectAtIndex:ALERTA_TROCAR_ADMINISTRADOR];
//    [alert showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *action = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    //Excluir banda
    if([action isEqualToString:@"Sim, excluir banda"]){
    }
    
    //Sair da banda
    if([action isEqualToString:@"Sim, sair da banda"]){
        [BandaStore  alterarDados:@"remover_membro" dado:[[LocalStore sharedStore] usuarioAtual].identificador idBanda:_banda.identificador];
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaPerfil] animated:YES];
    }
    
    //Trocar admnistrador da banda
    if([action isEqualToString:@"Sim, trocar adminsitrador"]){
    }
    
    //Remover membro
    if([action isEqualToString:@"Sim, remover membro"]){

        [BandaStore  alterarDados:@"remover_membro" dado:_usuarioRemover.identificador idBanda:_banda.identificador];

        //Remove da tabela
        [_banda.membros removeObject:_usuarioRemover];
        [_tbMembros reloadData];
    }
    
    //Remover musica
    if([action isEqualToString:@"Sim, remover música"]){

        [BandaStore alterarDados:@"remover_musica" dado:_musicaRemover.url idBanda:_banda.identificador];
        
        [_banda.musicas removeObject:_musicaRemover];
        [_tbMusicas reloadData];
    }
}

-(void)saidaBanda{
    
    UIActionSheet *alert;
    
    if([self verificaSeAdmBanda]){
        
        alert = [_alertasEdicao objectAtIndex:ALERTA_EXCLUIR_BANDA];
        alert.title = [NSString stringWithFormat:@"Tem certeza que deseja excluir a banda %@?", _banda.nome];
    }
    else{
        alert = [_alertasEdicao objectAtIndex:ALERTA_SAIR];
        alert.title = [NSString stringWithFormat:@"Tem certeza que deseja sair da banda %@?", _banda.nome];
    }
    
    [alert showInView:self.view];
}

@end
