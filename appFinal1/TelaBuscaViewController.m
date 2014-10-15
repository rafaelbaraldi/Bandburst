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
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Seleciona a imagem da tab bar
//    [_tabBar setSelectedItem:_buscarItem];
//    [_tabBar setTintColor:[UIColor whiteColor]];

    [self escondeBotaoDeBoltarSeUsuarioLogado];
    
    //Verifica se há filtro de horarios preenchidos
    [self carregaFiltroDeHorario];
    
    //Carrega os usuarios buscado
    [self carregaUsuarioBuscado];
    
    [self atualizaTela];
    
    [[self navigationItem] setTitle:@"Encontrar Músico"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [[UITabBar appearance] setBarTintColor:[UIColor redColor]];
    
    return YES;
}

-(void)escondeBotaoDeBoltarSeUsuarioLogado{
    if (![[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]) {
        [[self navigationItem] setHidesBackButton:YES];
    }
    else{
        [[self navigationItem] setHidesBackButton:NO];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _gravarItem.image = [[UIImage imageNamed:@"gravarIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _gravarItem.selectedImage = [[UIImage imageNamed:@"gravarIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _buscarItem.image = [[UIImage imageNamed:@"buscador.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _buscarItem.selectedImage = [[UIImage imageNamed:@"buscador.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _usuarioItem.image = [[UIImage imageNamed:@"perfilcone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _usuarioItem.selectedImage = [[UIImage imageNamed:@"perfilcone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_tabBar setTintColor: [UIColor whiteColor]];
    
    //Metodo de Busca por cidade
    [_txtCidade addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    //Deixa a borda dos boteos arredondados
    [self arredondaBordaBotoes];
    
    [self carregaLayout];
}

-(void)carregaLayout{
    
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];

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
    [[_btnEstilo titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14]];
    
    //Botao instrumento
    [[_btnInstumento layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnInstumento titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14]];
    
    //Botao de Horarios
    [[_btnHorarios layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnHorarios titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14]];
    
    //Text Cidade
    [[_txtCidade layer] setBorderWidth:2.0f];
    [[_txtCidade layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtCidade layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
}

-(void)atualizaTela{
    
    //Filtro Instrumento
    if ([[[BuscaStore sharedStore] instrumento] length] > 0) {
        _btnInstumento.titleLabel.text = [[BuscaStore sharedStore] instrumento];
        _btnRemoverInstrumento.hidden = NO;
    }
    else{
        _btnRemoverInstrumento.hidden = YES;
    }
    
    //Filtro Estilo Musical
    if ([[[BuscaStore sharedStore] estilo] length] > 0) {        
        _btnEstilo.titleLabel.text = [[BuscaStore sharedStore] estilo];
        _btnRemoverEstilo.hidden = NO;
    }
    else{
        _btnRemoverEstilo.hidden = YES;
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
    TBFiltroInstrumento *tbInstrumentoVC = [[TBFiltroInstrumento alloc] init];
    [[self navigationController] pushViewController:tbInstrumentoVC animated:YES];
}

//Abre view de Estilo Musical para filtrar
- (IBAction)btnEstiloClick:(id)sender {
    TBFiltroEstilo *tbEstiloVC = [[TBFiltroEstilo alloc] init];
    [[self navigationController] pushViewController:tbEstiloVC animated:YES];
}

//Abre view de Horarios para filtrar
- (IBAction)btnHorariosClick:(id)sender {
    TBFiltroHorario *tbHorariosVC = [[TBFiltroHorario alloc] init];
    [[self navigationController] pushViewController:tbHorariosVC animated:YES];
}

- (IBAction)btnRemoverEstiloClick:(id)sender {
    [[BuscaStore sharedStore] setEstilo:@""];
    _btnEstilo.titleLabel.text = @"Estilo Musical";
    
    _usuarios = [BuscaStore atualizaBusca:_usuarios cidade:_txtCidade.text];
    [self atualizaTela];
    [self carregaUsuarioBuscado];
}

- (IBAction)btnRemoverInstrumentoClick:(id)sender {
    [[BuscaStore sharedStore] setInstrumento:@""];
    _btnInstumento.titleLabel.text = @"Instrumento";
    
    _usuarios = [BuscaStore atualizaBusca:_usuarios cidade:_txtCidade.text];
    [self atualizaTela];
    [self carregaUsuarioBuscado];
}

//Delegate TextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//Busca pela cidade
-(void)textFieldDidChange{
//    _usuarios = [BuscaStore atualizaBusca:_usuarios cidade:_txtCidade.text];
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
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.187.203.61/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    if(celula == nil){
        celula = [[celulaPerfilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsuarioPesquisaCell"];
        
        UILabel *nome = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 170, 20)];
        nome.text = ((TPUsuario*)[_usuarios objectAtIndex:indexPath.row]).nome;
        nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
        nome.textColor = [[LocalStore sharedStore] FONTECOR];
        nome.adjustsFontSizeToFitWidth = YES;
        nome.tag = 1;
        
        UILabel *cidade = [[UILabel alloc] initWithFrame:CGRectMake(120, 55, 170, 15)];
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
    
    // Here we use the new provided setImageWithURL: method to load the web image
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
