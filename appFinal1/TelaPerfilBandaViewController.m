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

#import "GravacaoStore.h"

#import "UIImageView+WebCache.h"

@interface TelaPerfilBandaViewController ()

@end

@implementation TelaPerfilBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _visualizandoMembros = YES;
        _tbMusicas.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    _banda = [BandaStore buscaBanda:[[BandaStore sharedStore] idBandaSelecionada]];
    
    [[self navigationItem] setTitle:_banda.nome];
    
    //Carrega dados da Banda
    [_tbMembros reloadData];
    [_tbMusicas reloadData];
 
    //Carrega nome da Banda
    _lblNome.text = _banda.nome;
    [_lblNome sizeToFit];
    
    //Navigation Controller
    [[self navigationItem] setTitle:_banda.nome];
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
}

-(void)carregaLayout{
    
    //Esconde linhas em branco da TableView
    _tbMembros.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMembros.separatorColor = [UIColor clearColor];
    
    _tbMusicas.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMusicas.separatorColor = [UIColor clearColor];
    
    [[_btnEditar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnEditar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    [_lblNome setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    [[_btnChat titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    NSDictionary* atributos = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16], NSFontAttributeName, nil];
    [_segTabela setTitleTextAttributes:atributos forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelulaDeMembros"];
        
        //URL Foto do Usuario
        NSString *urlFoto = [NSString stringWithFormat:@"http://54.187.203.61/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).identificador];
        NSURL *imageURL = [NSURL URLWithString:urlFoto];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CelulaDeMembros"];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UILabel* nome = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 240, 30)];
            nome.text = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome;
            
            nome.tag = 1;
            [nome setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
            [nome setTextColor:[[LocalStore sharedStore] FONTECOR]];
            
            [cell addSubview:nome];

            UIImageView* foto = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
            foto.layer.masksToBounds = YES;
            foto.layer.cornerRadius =  foto.frame.size.width / 2;
            foto.tag = 2;
            
            // Here we use the new provided setImageWithURL: method to load the web image
            [foto sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                                       }];
            
            [cell addSubview:foto];
        }
        else{
            UILabel* nome = (UILabel*)[cell viewWithTag:1];
            
            nome.text = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome;
            
            UIImageView* foto = (UIImageView*)[cell viewWithTag:2];
            
            // Here we use the new provided setImageWithURL: method to load the web image
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
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UIImageView* som = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 30)];
            [som setImage:[UIImage imageNamed:@"audio.png"]];
            [som setTag:1];
            [cell addSubview:som];
            
            UIImageView* play = [[UIImageView alloc] initWithFrame:CGRectMake(265, 12, 35, 35)];
            [play setImage:[UIImage imageNamed:@"playing.png"]];
            [play setTag:2];
            [cell addSubview:play];
            
            UILabel* musica = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
            [musica setText:[self carregaNomeMusica:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]).url]];
            [musica setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
            [musica setTextColor:[[LocalStore sharedStore] FONTECOR]];
            [musica setTag:3];
            [cell addSubview:musica];
        }
        else{
            UILabel* musica = (UILabel*)[cell viewWithTag:3];
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

- (IBAction)segTabelaChange:(id)sender {
    _visualizandoMembros = !_visualizandoMembros;
    
    if (_visualizandoMembros) {
        _tbMembros.hidden = NO;
        _tbMusicas.hidden = YES;
    }
    else{
        _tbMembros.hidden = YES;
        _tbMusicas.hidden = NO;
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
@end
