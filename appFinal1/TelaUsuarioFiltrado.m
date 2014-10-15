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
        [[self navigationItem] setTitle:@"Meu Perfil"];
    }
    return self;
}

- (id) initWithIdentificador:(NSString*)idUsuario{
    self = [super init];
    
    if (self){ 
        _identificador = idUsuario;
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
}

-(void)carregaLayout{

    _lblNome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:18.0f];
    _lblSexo.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
    _lblCidadeBairro.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
    _lblAtribuicoes.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
    
    [_lblNome adjustsFontSizeToFitWidth];
    
    
    //Esconde linhas da tabela
    _tbDados.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbDados.separatorColor = [UIColor clearColor];
}

-(void)carregaUsuarioFiltrado{
    _pessoa = [BuscaStore buscaPessoa:_identificador];
    
    //Nome e Sexo e email
    _lblNome.text = _pessoa.nome;
    _lblSexo.text = _pessoa.sexo;
//    _lblEmail.text = _pessoa.email;
    
    //Cidade e Bairro
    _lblCidadeBairro.lineBreakMode = NSLineBreakByCharWrapping;
    _lblCidadeBairro.numberOfLines = 2;
    _lblCidadeBairro.text = [NSString stringWithFormat:@"%@, %@", _pessoa.cidade, _pessoa.bairro];
    
    //Atribuicoes
    [self carregaAtribuicoes];
    
    //Carrega dados do usuario
    [self carregaDadosUsuarios];
    
    //Estilos
//    [self carregaEstilosUsuario];
    
    //Posicionamento das View
    [self carregaPosicaoView];
    
    //Foto
    [self carregaImagemUsuario];
    
    //Horario
//    [self carregaHorariosUsuario];
    
    //Instrumentos
//    [self carregaInstrumentosUsuario];
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
    
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.187.203.61/appMusica/FotosDePerfil/%@.png", [BuscaStore buscaPessoa:_identificador].identificador];
    
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
}

- (IBAction)btnSeguirClick:(id)sender {
    if(![[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]){
        [BuscaConexao seguirAmigo:_pessoa.identificador acao:@"inserir"];
        [self carregaBotaoSeguirAmigo];
    }
}

-(void)botaoSeguirAmigo{
    [_btnSeguir setImage:[UIImage imageNamed:@"favoritar.png"] forState:UIControlStateNormal];
}

-(void)botaoSguindoAmigo{
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
            nRow = 0;
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
    viewSection.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0f];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    

    NSString *titulo;
    switch (section) {
        case 0:
            titulo = @"Estilo Musical";
        break;
        case 1:
            titulo = @"Instrumentos                          Tenho / Toco";
        break;
        case 2:
            titulo = @"Disponibilidade                            Horários";
        break;
    }
    
    return titulo;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:@"dadosCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dadosCell"];
        
    }
    else{

    }
    
    switch (indexPath.section) {
        case 0:
            celula.textLabel.text = [_pessoa.estilos objectAtIndex:indexPath.row];
            break;
            
        case 1:
            celula.textLabel.text = ((TPInstrumento*)[_pessoa.instrumentos objectAtIndex:indexPath.row]).nome;
            break;
            
        case 2:
            celula.textLabel.text = ((TPHorario*)[_pessoa.horarios objectAtIndex:indexPath.row]).dia;
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









-(void)carregaPosicaoView{
    
//    CGRect frame = _lblEstilo.frame;
//    frame.size.width = 299;
//    frame.size.height = ceilf((float)[_pessoa.estilos count] / 4) * 27;
//    [_lblEstilo setFrame:frame];
//    
//    frame = _lblInstrumentos.frame;
//    frame.origin.y = _lblEstilo.frame.origin.y + _lblEstilo.frame.size.height + 30;
//    frame.size.height = ([_pessoa.instrumentos count] + 1) * 27;
//    [_lblInstrumentos setFrame:frame];
    
//    frame = _lblTituloAtribuicoes.frame;
//    frame.origin.y = _lblInstrumentos.frame.origin.y + _lblInstrumentos.frame.size.height + 30;
//    [_lblTituloAtribuicoes setFrame:frame];
//    
//    frame = _lblAtribuicoes.frame;
//    frame.origin.y = _lblTituloAtribuicoes.frame.origin.y + _lblTituloAtribuicoes.frame.size.height + 10;
//    [_lblAtribuicoes setFrame:frame];
}


//-(void)carregaEstilosUsuario{
//    
//    _lblEstilo.numberOfLines = ceilf((float)[_pessoa.estilos count] / 4);
//    [_lblEstilo sizeToFit];
//    
//    //Estilo Musica
//    for (NSString* s in _pessoa.estilos) {
//        _lblEstilo.text = [NSString stringWithFormat:@"%@, %@", _lblEstilo.text, s];
//    }
//    _lblEstilo.text = [_lblEstilo.text substringFromIndex:2];
//    
//    [self espacoEntreLinhasLBL:_lblEstilo];
//}

//-(void)carregaHorariosUsuario{
//
//    
//    UILabel *lblTituloHorario = [[UILabel alloc] initWithFrame:CGRectMake(20, _lblAtribuicoes.frame.origin.y + _lblAtribuicoes.frame.size.height + 20, 300, 20)];
//    UILabel *lblHorarios = [[UILabel alloc] initWithFrame:CGRectMake(20, lblTituloHorario.frame.origin.y + lblTituloHorario.frame.size.height, 300, 20)];
//    
//    lblTituloHorario.text = @"Horarios para ensaio";
//    lblTituloHorario.textColor = [[LocalStore sharedStore] FONTECOR];
//    lblTituloHorario.font = [UIFont boldSystemFontOfSize:18];
//    
//    lblHorarios.text = [TPHorario horariosEmTexto:_pessoa.horarios];
//    
//    //Espaco entre as linhas
//    [self espacoEntreLinhasLBL:lblHorarios];
//    
//    lblHorarios.numberOfLines = [_pessoa.horarios count];
//    lblHorarios.textColor = [UIColor whiteColor];
//    [lblHorarios sizeToFit];
//    
//    [_scrollView addSubview:lblTituloHorario];
//    [_scrollView addSubview:lblHorarios];
//    
//    //Aumentar o scroll
//    _scrollView.frame = CGRectMake(0, 0, 320, 550 + (lblHorarios.frame.size.height / 2));
//    _scrollView.contentSize = CGSizeMake(320, lblHorarios.frame.origin.y + lblHorarios.frame.size.height + 20);
//}

//-(void)carregaInstrumentosUsuario{
//    
//    int i = 0;
//    for(TPInstrumento *tp in _pessoa.instrumentos){
//        _lblInstrumentos.text = [NSString stringWithFormat:@"%@\n%@", _lblInstrumentos.text, tp.nome];
//        
//        UIButton *btnPossui = [[UIButton alloc] initWithFrame:CGRectMake(240, 33+(i*27), 18, 18)];
//        if (tp.possui) {
//            [btnPossui addSubview:[self botaoInstrumentoPossui:YES]];
//        }
//        else{
//            [btnPossui addSubview:[self botaoInstrumentoPossui:NO]];
//        }
//        
//        [_lblInstrumentos addSubview:btnPossui];
//        i++;
//    }
//    
//    //Espaco entre as linhas
//    [self espacoEntreLinhasLBL:_lblInstrumentos];
//
//    _lblInstrumentos.numberOfLines = [_pessoa.instrumentos count] + 1;
//}

//-(UIImageView*)botaoInstrumentoPossui:(BOOL)possui{
//    
//    UIImageView *botao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
//    if(possui){
//        botao.image = [UIImage imageNamed:@"selecionado.png"];
//    }
//    else{
//        botao.image = [UIImage imageNamed:@"deselecionado.png"];
//    }
//    
//    return botao;
//}
//
//-(void)espacoEntreLinhasLBL:(UILabel*)label{
//    
//    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
//    style.minimumLineHeight = 27.f;
//    style.maximumLineHeight = 27.f;
//    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
//    label.attributedText = [[NSAttributedString alloc] initWithString:label.text
//                                                                      attributes:attributtes];
//    label.lineBreakMode = NSLineBreakByCharWrapping;
//}


@end
