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
    
    _gravarPerfil.image = [[UIImage imageNamed:@"gravarIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _gravarPerfil.selectedImage = [[UIImage imageNamed:@"gravarIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _buscarItem.image = [[UIImage imageNamed:@"buscador.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _buscarItem.selectedImage = [[UIImage imageNamed:@"buscador.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _perfilItem.image = [[UIImage imageNamed:@"perfilcone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _perfilItem.selectedImage = [[UIImage imageNamed:@"perfilcone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_tabBar setTintColor: [UIColor whiteColor]];
    
    //Collection view
    [self carregaConfiguracaoCollectionMusica];
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
    
    //layout
    [self carregaLayout];
}

-(void)carregaLayout{
    
    //Titulo navigation
    [[self navigationItem] setTitle:@"Perfil"];
    
    //Bota add banda
    [[_btnCriarBanda layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
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

-(void)carregaDadosUsuario{
    
    //Imagem
    [self carregaImagemPerfil];
    
    //Nome, cidade, Bairro e Atribuicoes
    _lblPerfilNome.text = [[LocalStore sharedStore] usuarioAtual].nome;
    _lblPerfilCidade.text = [[LocalStore sharedStore] usuarioAtual].cidade;
    _lblPerfilBairro.text = [[LocalStore sharedStore] usuarioAtual].bairro;
    
    _lblPerfilAtribuicoes.layer.borderWidth = 1.0f;
    _lblPerfilAtribuicoes.layer.borderColor = [UIColor grayColor].CGColor;
    _lblPerfilAtribuicoes.text = [[LocalStore sharedStore] usuarioAtual].atribuicoes;
    _lblPerfilAtribuicoes.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12.0f];
    
    if([_lblPerfilAtribuicoes.text length] == 0){
        _lblPerfilAtribuicoes.text = @" - ";
    }
    else{
        _lblPerfilAtribuicoes.textAlignment = NSTextAlignmentCenter;
    }
    
    //Botao Editar Perfil (Função em programação)
    [self botaoPerfilEditar];
    
    //Carrega Qtd de Amigos
    _lblPerfilAmigos.text = [NSString stringWithFormat:@"%@", [PerfilStore qtdDeAmigos]];
}

-(UIImage*)carregaImagemFake{
    
    UIImageView *fotoUsuario = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 80, 80)];
    fotoUsuario.image = [UIImage imageNamed:@"placeholderFoto.png"];
    fotoUsuario.layer.masksToBounds = YES;
    fotoUsuario.layer.cornerRadius = fotoUsuario.frame.size.width / 2;
    fotoUsuario.tag = 4;
    
    return fotoUsuario.image;
}

-(void)carregaImagemPerfil{
    
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.187.203.61/appMusica/FotosDePerfil/%@.png", [[LocalStore sharedStore] usuarioAtual].identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    _imagePerfil.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlFoto];
    
    if (_imagePerfil.image == nil) {
        [_imagePerfil sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                               }];
    }
    _imagePerfil.layer.masksToBounds = YES;
    _imagePerfil.layer.cornerRadius = _imagePerfil.frame.size.width / 2;

}

-(void)botaoPerfilEditar{
    
    _btnPerfilEditar.enabled = YES;

    [[_btnPerfilEditar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
}

-(void)carregaBotaoOpcoes{
    
    UIImage *imageOpcoes = [UIImage imageNamed:@"config.png"];
    
    UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithImage:imageOpcoes style:UIBarButtonItemStylePlain target:self action:@selector(opcoes)];
    
    [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
}

-(void)opcoes{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaOpcoes] animated:YES];
}

- (IBAction)btnPerfilEditarClick:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaEditarPerfil] animated:YES];
}

-(void)carregaBandas{
    _bandas = [PerfilStore retornaListaDeBandas];
    
    if([_bandas count] == 0){
        
        _lblInfo.hidden = NO;
    }
    else{
    
        int y = 15;
        
        for (TPBanda* b in _bandas) {
            
            //Imagem
            UIButton* icone = [[UIButton alloc] initWithFrame:CGRectMake(30, y, 50, 50)];
            [icone setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%lu.png", (unsigned long)[_bandas indexOfObject:b]]] forState:UIControlStateNormal];
            [icone setTitle:b.identificador forState:UIControlStateNormal];
            [icone addTarget:self action:@selector(banda:) forControlEvents:UIControlEventTouchUpInside];
            
            //Nome
            UILabel* nome = [[UILabel alloc] initWithFrame:CGRectMake(110, y + 5, 60, 45)];
            nome.text =  b.nome;
            nome.textColor = [UIColor blackColor];
            nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0];
            nome.textColor = [[LocalStore sharedStore] FONTECOR];
            [nome setTextAlignment:NSTextAlignmentCenter];
            
            if([b.nome length] > 11){
                [nome setNumberOfLines:2];
            }
            
            [_scrollBanda addSubview:icone];
            [_scrollBanda addSubview:nome];
            
            //Posicao
            y += 70;
        }

        //Scroll
        [_scrollBanda setContentSize:CGSizeMake(320, y)];
    }
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

- (IBAction)btnCriarBandaClick:(id)sender {
    if(![[[LocalStore sharedStore] usuarioAtual].identificador isEqualToString:@"0"]){
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaNovaBanda] animated:YES];
    }
}

//Collection das musicas
-(void)carregaConfiguracaoCollectionMusica{
    
    _collectionV.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
@end
