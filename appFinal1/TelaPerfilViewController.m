//
//  TelaPerfilViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaPerfilViewController.h"

#import "LoginStore.h"
#import "LocalStore.h"
#import "BandaStore.h"

#import "Musica.h"
#import "PerfilStore.h"
#import "TPBanda.h"

#import <AVFoundation/AVAudioSession.h>
#import "UIImageView+WebCache.h"

@interface TelaPerfilViewController ()
@end

@implementation TelaPerfilViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Collection view
    [self carregaConfiguracaoCollectionMusica];
    
    //Botao opções
    [self carregaBotaoOpcoes];
    
    //BG
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self viewDidLoad];
    
    [self escondeBotaoDeVoltarSeUsuarioLogado];
    
    //Carrega dados do Usuario
    [self carregaDadosUsuario];
    
    //Carrega os audios
    [self carregaAudios];
    [_collectionV reloadData];
    
    //Carrega as Bandas
    [self carregaBandas];
    
    //Titulo navigation
    [[self navigationItem] setTitle:[[LocalStore sharedStore] usuarioAtual].nome];
    
    //Botao do NAvigationItem
    [_tabBar setSelectedItem:_perfilItem];
    [_tabBar setTintColor:[[LocalStore sharedStore] CORFONTE]];
}

-(void)escondeBotaoDeVoltarSeUsuarioLogado{
    if ([[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]) {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    else{
        [self carregaBotaoOpcoes];
    }
}

-(void) viewWillDisappear:(BOOL)animated{

    //Remove view da scroll Banda
    for (UIView* v in [_scrollBanda subviews]) {
        [v removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)carregaConfiguracaoCollectionMusica{
    
    _collectionV.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)carregaDadosUsuario{
    
    //Imagem
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.187.203.61/appMusica/FotosDePerfil/%@.png", [[LocalStore sharedStore] usuarioAtual].identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    _imagePerfil.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlFoto];
    
    if (_imagePerfil.image == nil) {
        [_imagePerfil sd_setImageWithURL:imageURL placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                              }];
    }
    _imagePerfil.layer.masksToBounds = YES;
    _imagePerfil.layer.cornerRadius = _imagePerfil.frame.size.width / 2;
    
    //Nome, cidade e Bairro
    _lblPerfilNome.text = [[LocalStore sharedStore] usuarioAtual].nome;
    _lblPerfilCidade.text = [[LocalStore sharedStore] usuarioAtual].cidade;
    _lblPerfilBairro.text = [[LocalStore sharedStore] usuarioAtual].bairro;
    
    //Botao Editar Perfil (Função em programação)
    [self botaoPerfilEditar];
    
    //Carrega Qtd de Amigos
    _lblPerfilAmigos.text = [NSString stringWithFormat:@"%@", [PerfilStore qtdDeAmigos]];
}

-(void)botaoPerfilEditar{
    
    _btnPerfilEditar.enabled = NO;

    [_btnPerfilEditar setBackgroundColor:[UIColor whiteColor]];
    [_btnPerfilEditar setTitleColor:[[LocalStore sharedStore] CORFONTE] forState:UIControlStateNormal];
    [[_btnPerfilEditar layer] setBorderWidth:2];
    [[_btnPerfilEditar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnPerfilEditar layer] setBorderColor:([[LocalStore sharedStore] CORFONTE].CGColor)];
}

-(void)carregaBotaoOpcoes{
    
    UIImage *imageOpcoes = [UIImage imageNamed:@"opcoes.png"];
    
    UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithImage:imageOpcoes style:UIBarButtonItemStylePlain target:self action:@selector(opcoes)];
    
    [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
}

-(void)opcoes{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaOpcoes] animated:YES];
}

- (IBAction)btnPerfilEditarClick:(id)sender {
}

-(void)carregaBandas{
    _bandas = [PerfilStore retornaListaDeBandas];
    
    int x = 0;
    
    for (TPBanda* b in _bandas) {
        
        //Imagem
        UIButton* icone = [[UIButton alloc] initWithFrame:CGRectMake(x, 15, 45, 45)];
        [icone setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%lu.png", (unsigned long)[_bandas indexOfObject:b]]] forState:UIControlStateNormal];
        [icone setTitle:b.identificador forState:UIControlStateNormal];
        [icone addTarget:self action:@selector(banda:) forControlEvents:UIControlEventTouchUpInside];
        
        //Nome
        UILabel* nome = [[UILabel alloc] initWithFrame:CGRectMake(x - 7, 45, 60, 45)];
        nome.text =  b.nome;
        nome.textColor = [UIColor blackColor];
        [nome setFont:[UIFont fontWithName:@"Verdana" size:8.0]];
        [nome setTextAlignment:NSTextAlignmentCenter];
        
        if([b.nome length] > 11){
            [nome setNumberOfLines:2];
        }
        
        [_scrollBanda addSubview:icone];
        [_scrollBanda addSubview:nome];
        
        //Posicao
        x += 65;
    }

    //Scroll
    [_scrollBanda setContentSize:CGSizeMake(x, 82)];
//    [[_scrollBanda layer] setCornerRadius:2.5f];
//    [[_scrollBanda layer] setBorderWidth:1];
//    [[_scrollBanda layer] setBorderColor:[[LocalStore sharedStore] CORFONTE].CGColor];
}

-(void)banda:(UIButton*)bt{
    
    [[BandaStore sharedStore] setIdBandaSelecionada:[bt titleLabel].text];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaBanda]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBanda] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBanda] animated:YES];
    }
}

-(void)carregaAudios{
    
    _musicas = [PerfilStore retornaListaDeMusicas];
    _categorias = [PerfilStore retornaListaDeCategorias:_musicas];
    _musicasPorCategoria = [PerfilStore retornaListaDeMusicasPorCategorias:_musicas];
    
    UINib *cellNib = [UINib nibWithNibName:@"CellMusica" bundle:nil];
    [_collectionV registerNib:cellNib forCellWithReuseIdentifier:@"FlickrCell"];

    UINib *cellTitulo = [UINib nibWithNibName:@"CellTituloMusica" bundle:nil];
    [_collectionV registerNib:cellTitulo forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //Opcoes CollectionView de Musicas
    [_collectionV setBackgroundColor:[UIColor clearColor]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_categorias count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[_musicasPorCategoria objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    
    UILabel* lblMusica = (UILabel*)[cell viewWithTag:1];
    lblMusica.text = ((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).nome;
    lblMusica.font = [lblMusica.font fontWithSize:10];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview == nil) {
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
        
        UILabel* label = (UILabel*)[reusableview viewWithTag:1];
        label.text = [_categorias objectAtIndex:indexPath.section];
        
        return reusableview;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).url];
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [player play];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    UIViewController* vc;
    
    switch (item.tag) {
        case 1:
            vc = [[LocalStore sharedStore] TelaGravacao];
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

- (IBAction)btnCriarBandaClick:(id)sender {
    if(![[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]){
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaNovaBanda] animated:YES];
    }
}
@end
