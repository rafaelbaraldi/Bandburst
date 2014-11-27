//
//  TelaBuscaViewController.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 20/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaBuscaViewController.h"
#import "TelaUsuarioFiltrado.h"

#import "LocalStore.h"

#import "TBFiltroEstilo.h"
#import "TBFiltroHorario.h"
#import "TBFiltroInstrumento.h"

#import "BuscaStore.h"
#import "BuscaConexao.h"

#import "LocalStore.h"

#import "TPUsuario.h"

//#import "ImgStore.h"

#import "UIImageView+WebCache.h"
#import "celulaPerfilTableViewCell.h"

@interface TelaBuscaViewController ()

@end

@implementation TelaBuscaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _usuarios = [[NSMutableArray alloc] init];
        
        [[self navigationItem] setTitle:@"Encontrar Músicos"];
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{

    [self escondeBotaoDeBoltarSeUsuarioLogado];
    
    //Verifica se há filtro de horarios preenchidos
    [self carregaFiltroDeHorario];

    //Carrega os usuarios buscado
    [self carregaUsuarioBuscado];

    [self atualizaTela];
    
    
//    self.navigationController.navigationBar.topItem.title = @"YourTitle";
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Metodo de Busca por cidade
    [_txtCidade addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    //Deixa a borda dos boteos arredondados
    [self arredondaBordaBotoes];
    
    //Favoritos
    [self carregaBotaoFavoritos];
    
    [self carregaLayout];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.adView setKeywords:searchBar.text];
    [self.adView refreshAd];
}

-(void)escondeBotaoDeBoltarSeUsuarioLogado{

    if ([[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]) {
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(voltarLogin)];
        
        [[self navigationItem] setLeftBarButtonItem:buttonItem animated:YES];
    }
    else{
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

-(void) voltarLogin{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)carregaBotaoFavoritos{
    
    UIImage *imageOpcoes = [UIImage imageNamed:@"estrela.png"];
    
    UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithImage:imageOpcoes style:UIBarButtonItemStylePlain target:self action:@selector(usuariosFavoritos)];
    
    [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
}

-(void)usuariosFavoritos{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaFavoritados] animated:YES];
}

-(void)carregaLayout{
    
    _tabBarSeta.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    _lblMsgBusca.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblMsgBusca.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];

    //Bag esconder Filtro
    _tbUsuarios.layer.zPosition = 3;
    _frameTbUsuarios = _tbUsuarios.frame;
    
    //Esconde linhas da tabela
    _tbUsuarios.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbUsuarios.separatorColor = [UIColor clearColor];
    
    //Cores do botao
    _btnInstumento.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnHorarios.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnEstilo.backgroundColor = [[LocalStore sharedStore] FONTECOR];
}

-(void)carregaUsuarioBuscado{
    
    //Verifica se possui algum filtro requisitado
    if([[[BuscaStore sharedStore] instrumento] length] > 0
       || [[[BuscaStore sharedStore] estilo] length] > 0
       || [[[BuscaStore sharedStore] horario] length] > 0
       || _txtCidade.text > 0){
        
        _usuarios = [BuscaStore atualizaBusca:_usuarios cidade:_txtCidade.text];
        
        if([_usuarios count] == 0){
            
            //Exibi label para pedir o instrumento
            [_lblMsgBusca setText:@"Nenhum resultado encontrado para a sua pesquisa"];
            [_lblMsgBusca setTextAlignment:NSTextAlignmentCenter];
            [_lblMsgBusca setNumberOfLines:2];
            [_lblMsgBusca setTintColor:[UIColor whiteColor]];
        }
        else{
            [_lblMsgBusca setText:@""];
        }
    }
    else{
        [_lblMsgBusca setText:@""];
        [_usuarios removeAllObjects];
    }
    
    
    [_tbUsuarios reloadData];
}

-(void)arredondaBordaBotoes{
    
    //Botao Estilo
    [[_btnEstilo layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnEstilo titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Botao instrumento
    [[_btnInstumento layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnInstumento titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Botao de Horarios
    [[_btnHorarios layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnHorarios titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Text Cidade
    [[_txtCidade layer] setBorderWidth:2.0f];
    [[_txtCidade layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtCidade layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    
    [_txtCidade setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
}

-(void)atualizaTela{    
    
    //Filtro Instrumento
    if ([[[BuscaStore sharedStore] instrumento] length] > 0) {
        _btnInstumento.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnInstumento setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnInstumento setTitle:[NSString stringWithFormat:@"%@", [[BuscaStore sharedStore] instrumento]] forState:UIControlStateNormal];
    }
    else{
        [_btnInstumento setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnInstumento setTitle:@"Instrumento" forState:UIControlStateNormal];
    }
    
    //Filtro Estilo Musical
    if ([[[BuscaStore sharedStore] estilo] length] > 0) {
        _btnEstilo.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnEstilo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnEstilo setTitle:[NSString stringWithFormat:@"%@", [[BuscaStore sharedStore] estilo]] forState:UIControlStateNormal];
    }
    else{
        [_btnEstilo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnEstilo setTitle:@"Estilo musical" forState:UIControlStateNormal];
    }

    //Filtro Estilo Musical
    if ([[[BuscaStore sharedStore] horario] length] > 0) {
        _btnHorarios.titleLabel.textColor = [UIColor blackColor];
    }
    else{
        _btnHorarios.titleLabel.textColor = [UIColor whiteColor];
    }
}

//Carrega String do filtro de Horario
-(void)carregaFiltroDeHorario{
    
    NSString *h = @"";
    for (NSString* s in [[BuscaStore sharedStore] horariosFiltrados]) {
        h = [NSString stringWithFormat:@"%@,%%20%@", h, s];
    }
    if([h length] > 0){
        h = [h substringFromIndex:4];
    }
    
    [[BuscaStore sharedStore] setHorario:h];
}

//Botoes
- (IBAction)btnInstrumentoClick:(id)sender {
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TBFiltroInstrumento]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TBFiltroInstrumento] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TBFiltroInstrumento] animated:YES];
    }
}

//Abre view de Estilo Musical para filtrar
- (IBAction)btnEstiloClick:(id)sender {
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TBFiltroEstilo]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TBFiltroEstilo] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TBFiltroEstilo] animated:YES];
    }
}

//Abre view de Horarios para filtrar
- (IBAction)btnHorariosClick:(id)sender {
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TBFiltroHorario]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TBFiltroHorario] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TBFiltroHorario] animated:YES];
    }
}

//Delegate TextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//Busca pela cidade
-(void)textFieldDidChange{
    [self carregaUsuarioBuscado];
}

//Delegate TableView - Numero de linhas da tabela
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_usuarios count];
}

//Numero de sessoes
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//Quando seleciona a linha, entra na tela de perfil do usuario
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TelaUsuarioFiltrado *tuVC = [[TelaUsuarioFiltrado alloc] initWithIdentificador:((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).identificador];
    [[self navigationController] pushViewController:tuVC animated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    celulaPerfilTableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"UsuarioPesquisaCell"];
    
    //URL Foto do Usuario
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    if(celula == nil){
        celula = [[celulaPerfilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsuarioPesquisaCell"];
        
        UILabel *nome = [[UILabel alloc] initWithFrame:CGRectMake(120, 22, 170, 20)];
        nome.text = ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).nome;
        nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
        nome.textColor = [[LocalStore sharedStore] FONTECOR];
        nome.adjustsFontSizeToFitWidth = YES;
        nome.tag = 1;
        
        UILabel *cidade = [[UILabel alloc] initWithFrame:CGRectMake(120, 52, 170, 15)];
        cidade.text = ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).cidade;
        cidade.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12];
        cidade.textColor = [[LocalStore sharedStore] FONTECOR];
        cidade.adjustsFontSizeToFitWidth = YES;
        cidade.tag = 2;
        
        [celula addSubview:nome];
        [celula addSubview:cidade];
    }
    else{
        ((UILabel*)[celula viewWithTag:1]).text = ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).nome;
        ((UILabel*)[celula viewWithTag:2]).text = ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).cidade;
    }
    
    [celula.imageView sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
    }];
    
    return celula;
}

-(UIImage*)carregaImagemFake{
    
    UIImageView *fotoUsuario = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 80, 80)];
    fotoUsuario.image = [UIImage imageNamed:@"placeholderFoto.png"];
    fotoUsuario.layer.masksToBounds = YES;
    fotoUsuario.layer.cornerRadius = fotoUsuario.frame.size.width / 2;
    fotoUsuario.tag = 4;
    
    return fotoUsuario.image;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    UIViewController* vc;
    
    switch (item.tag) {
        case 1:
            vc = [[LocalStore sharedStore] TelaGravacoes];
            break;
            
        case 2:
            vc = [[LocalStore sharedStore] TelaBusca];
            break;
            
        case 3:
            vc = [[LocalStore sharedStore] TelaPerfil];
            break;
    }
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
        [[self navigationController] popToViewController:vc animated:NO];
    }
    else{
        [[self navigationController] pushViewController:vc animated:NO];
    }
}

@end
