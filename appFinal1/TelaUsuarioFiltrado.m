//
//  TelaUsuarioFiltrado.m
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 27/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaUsuarioFiltrado.h"
#import "BuscaConexao.h"
#import "TPInstrumento.h"
#import "TPHorario.h"
#import "BuscaStore.h"
//#import "ImgStore.h"
#import "LocalStore.h"

#import "UIImageView+WebCache.h"

@interface TelaUsuarioFiltrado ()

@end

@implementation TelaUsuarioFiltrado

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id) initWithIdentificador:(NSString*)idUsuario{
    self = [super init];
    
    if (self){ 
        _identificador = idUsuario;
        _horarios = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaUsuarioFiltrado];
    
    //Carrega opcoes Scrool View
    [self carregaOpcoesScrool];
    
    [self carregaLayout];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[[self navigationItem] setTitle:@""];
}

-(void)carregaOpcoesScrool{
    
    _scrollView.pagingEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)retorna{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self carregaBotaoSeguirAmigo];
    
    //Navigation Controller
    [[self navigationItem] setTitle:@"Perfil"];
}

-(void)carregaLayout{

//    _lblNome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:18.0f];
//    _lblSexo.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
//    _lblCidadeBairro.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
//    _lblAtribuicoes.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
    
    //Arruma Cor
    _lblNome.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblCidadeBairro.textColor = [[LocalStore sharedStore] FONTECOR];
    
    [_lblNome adjustsFontSizeToFitWidth];

    //Esconde linhas da tabela
    _tbDados.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbDados.separatorColor = [UIColor clearColor];
    
    //Scroll Table
    if([_pessoa.estilos count] + [_pessoa.instrumentos count] +[_horarios count] <= 7){
         _tbDados.scrollEnabled = NO;
    }
    else{
         _tbDados.scrollEnabled = YES;
    }
}

-(void)carregaUsuarioFiltrado{
    _pessoa = [BuscaStore buscaPessoa:_identificador];
    
    //Nome e Sexo e email
    _lblNome.text = _pessoa.nome;
    _lblSexo.text = _pessoa.sexo;
//    _lblEmail.text = _pessoa.email;
    
    //Carrega Horarios
    _horarios = [TPHorario getHorarios:_pessoa.horarios];
    
    //Cidade e Bairro
    _lblCidadeBairro.lineBreakMode = NSLineBreakByCharWrapping;
    _lblCidadeBairro.numberOfLines = 2;
    _lblCidadeBairro.text = [NSString stringWithFormat:@"%@\n%@", _pessoa.cidade, _pessoa.bairro];
    
    //Atribuicoes
    [self carregaAtribuicoes];
    
    //Carrega dados do usuario
    [self carregaDadosUsuarios];
    
    //Foto
    [self carregaImagemUsuario];
}


-(void)carregaAtribuicoes{
    
    if([_pessoa.atribuicoes length] == 0){
        _lblAtribuicoes.text = @" - ";
        _lblAtribuicoes.textAlignment = NSTextAlignmentCenter;
    }
    else{
        _lblAtribuicoes.text = _pessoa.atribuicoes;
    }
    
    _lblAtribuicoes.layer.borderWidth = 1.0f;
    _lblAtribuicoes.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)carregaImagemUsuario{
    
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", [BuscaStore buscaPessoa:_identificador].identificador];
    
    UIImage* foto = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlFoto];
    if(foto == nil){
        foto = [UIImage imageNamed:@"placeholderFoto.png"];
    }
    
    _imageUsuario.layer.masksToBounds = YES;
    _imageUsuario.layer.cornerRadius = _imageUsuario.frame.size.width / 2;
    _imageUsuario.image = foto;
    _imageUsuario.tag = 3;
}

-(void)carregaBotaoSeguirAmigo{
    
    NSString *result = [BuscaConexao seguirAmigo:_pessoa.identificador acao:@"consultar"];
    
    if ([result isEqualToString:@"1\n"]) {
        [self botaoSguindoAmigo];
    }
    else{
        [self botaoSeguirAmigo];
    }
    
    if ([_pessoa.identificador isEqualToString:[[LocalStore sharedStore] usuarioAtual].identificador]) {
        _btnSeguir.hidden = YES;
    }
    else{
        _btnSeguir.hidden = NO;
    }
}

- (IBAction)btnSeguirClick:(id)sender {
    if(![[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]){
        [BuscaConexao seguirAmigo:_pessoa.identificador acao:@"inserir"];
        [self carregaBotaoSeguirAmigo];
    }
}

-(void)botaoSeguirAmigo{
//    _estrela.hidden = YES;
    [_btnSeguir setImage:[UIImage imageNamed:@"favoritar.png"] forState:UIControlStateNormal];
}

-(void)botaoSguindoAmigo{
//    _estrela.hidden = NO;
    [_btnSeguir setImage:[UIImage imageNamed:@"favoritado.png"] forState:UIControlStateNormal];
}

-(void)carregaDadosUsuarios{
    
    for (NSString *s in _pessoa.estilos) {
        [_dadosUsuarios addObject:s];
    }
    for (TPInstrumento *i in _pessoa.instrumentos){
        [_dadosUsuarios addObject:i];
    }
    for (TPHorario *h in _pessoa.horarios){
        [_dadosUsuarios addObject:h];
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        tableView.contentSize = CGSizeMake(320, ([_pessoa.estilos count] + [_pessoa.instrumentos count] +[_horarios count] + 3) * 33);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger nRow = 0;
    
    switch (section) {
        case 0:
            nRow = [_pessoa.estilos count];
            break;
        case 1:
            nRow = [_pessoa.instrumentos count];
            break;
        case 2:
            nRow = [_horarios count];
            break;
    }

    return nRow;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *viewSection = (UITableViewHeaderFooterView *)view;
    viewSection.contentView.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    viewSection.textLabel.textColor = [UIColor whiteColor];
    viewSection.textLabel.font = [UIFont systemFontOfSize:14.0f];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString *titulo;
    switch (section) {
        case 0:
            titulo = @"Estilo Musical";
        break;
        case 1:
            titulo = @"Instrumentos                             Tenho / Toco";
        break;
        case 2:
            titulo = @"Disponibilidade                                Horários";
        break;
    }
    
    return titulo;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:@"dadosCell"];
    
    NSString *nomeHorario;
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dadosCell"];
        
        //Adicionar Periodo Horario
        UILabel *periodo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 298, 30)];
        periodo.text = @"";
        periodo.textAlignment = NSTextAlignmentRight;
        periodo.numberOfLines = 0;
        periodo.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
        periodo.textColor = [[LocalStore sharedStore] FONTECOR];
        periodo.tag = 3;
        [celula addSubview:periodo];
        
        //Imagem Tenho Instrumento
        UIImageView* imgTenho = [[UIImageView alloc] initWithFrame:CGRectMake(225, 3, 23, 23)];
        [imgTenho setTag:1];
        [celula addSubview:imgTenho];
        
        //Imagem Toco Instrumento
        UIImageView* imgToco = [[UIImageView alloc] initWithFrame:CGRectMake(272, 3, 23, 23)];
        [imgToco setTag:2];
        [celula addSubview:imgToco];
        
        //Instrumento
        if (indexPath.section == 1) {
            //Possui
            BOOL possui = ((TPInstrumento*)[_pessoa.instrumentos objectAtIndex:indexPath.row]).possui;
           
            if (possui) {
                imgTenho.image = [UIImage imageNamed:@"check.png"];
            }
            else{
                imgTenho.image = [UIImage imageNamed:@"uncheck.png"];
            }
            
            //Toco
            [imgToco setImage:[UIImage imageNamed:@"check.png"]];
        }
        
        //Horario
        if(indexPath.section == 2){
            
            nomeHorario = [[[_horarios objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] firstObject];
            
            //Adciona o periodo Horario
            periodo.text = [[_horarios objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:nomeHorario withString:@" "];
        }
    }
    else{
        
        //Instrumento
        UIImageView *imgTenho = (UIImageView*)[celula viewWithTag:1];
        UIImageView *imgToco = (UIImageView*)[celula viewWithTag:2];
        if(indexPath.section == 1){
            
            //Toco
            [imgToco setImage:[UIImage imageNamed:@"check.png"]];
            
            //Possui
            BOOL possui = ((TPInstrumento*)[_pessoa.instrumentos objectAtIndex:indexPath.row]).possui;
            if (possui) {
                imgTenho.image = [UIImage imageNamed:@"check.png"];
            }
            else{
                imgTenho.image = [UIImage imageNamed:@"uncheck.png"];
            }
        }
        else{
            imgTenho.image = nil;
            imgToco.image = nil;
        }
        
        //Horario
        UILabel *periodo = (UILabel*)[celula viewWithTag:3];
        if(indexPath.section == 2){
            nomeHorario = [[[_horarios objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] firstObject];
            periodo.text = [[_horarios objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:nomeHorario withString:@""];
        }
        else{
            periodo.text = @"";
        }
    }
    
    switch (indexPath.section) {
        //Estilo Musical
        case 0:
            celula.textLabel.text = [_pessoa.estilos objectAtIndex:indexPath.row];
        break;
        
        //Instrumentos
        case 1:
            celula.textLabel.text = ((TPInstrumento*)[_pessoa.instrumentos objectAtIndex:indexPath.row]).nome;
        break;
        
        //Horarios Disponiveis
        case 2:
            nomeHorario = [[[_horarios objectAtIndex:indexPath.row] componentsSeparatedByString:@" "] firstObject];
            celula.textLabel.text = nomeHorario;
        break;
    }
    
    //Fonte da Label
    celula.textLabel.textColor = [[LocalStore sharedStore] FONTECOR];
    celula.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
    
    //Background da Label
    if(indexPath.row % 2 != 0){
        [celula setBackgroundColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]];
    }
    else{
        [celula setBackgroundColor:[UIColor whiteColor]];
    }
    
    return celula;
}

@end
