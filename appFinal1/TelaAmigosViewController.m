//
//  TelaAmigosViewController.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaAmigosViewController.h"
#import "BandaStore.h"
#import "BandaConexao.h"
#import "TPUsuario.h"
#import "LocalStore.h"

#import "UIImageView+WebCache.h"
#import "celulaPerfilTableViewCell.h"

@interface TelaAmigosViewController ()

@end

@implementation TelaAmigosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _amigos = [[NSMutableArray alloc] init];
        _amigosFiltrados = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega Lista de favoritos
    _amigos = [BandaStore retornaListaDeAmigos];
    
    //Recarrega lista da tabela
    [_amigosFiltrados removeAllObjects];
    [_amigosFiltrados addObjectsFromArray:_amigos];
    [_tbAmigos reloadData];
    
    //Navigation Controller
    [[self navigationItem] setTitle:@"Favoritos"];
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
}

-(void)carregaLayout{
    
    //Esconde linhas em branco da TableView
    _tbAmigos.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbAmigos.separatorColor = [UIColor clearColor];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_amigosFiltrados count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[[BandaStore sharedStore] membros] containsObject:[_amigosFiltrados objectAtIndex:indexPath.row]]){
        [[[BandaStore sharedStore] membros] addObject:[_amigosFiltrados objectAtIndex:indexPath.row]];
    }
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaNovaBanda] animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [_amigosFiltrados removeAllObjects];
    
    if([searchText isEqual:@""]){
        [_amigosFiltrados addObjectsFromArray:_amigos];
    }
    
    for (TPUsuario* u in _amigos) {
        if([u.nome rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound){
            [_amigosFiltrados addObject:u];
        }
    }
    
    [_tbAmigos reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    celulaPerfilTableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"UsuarioPesquisaCell"];
    
    //URL Foto do Usuario
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    if(celula == nil){
        celula = [[celulaPerfilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsuarioPesquisaCell"];
        
        //Remove cor de seleção
        celula.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nome = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 170, 20)];
        nome.text = ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).nome;
        nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
        nome.textColor = [[LocalStore sharedStore] FONTECOR];
        nome.adjustsFontSizeToFitWidth = YES;
        nome.tag = 1;
        
        UILabel *cidade = [[UILabel alloc] initWithFrame:CGRectMake(120, 55, 170, 15)];
        cidade.text = ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).cidade;
        cidade.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12];
        cidade.textColor = [[LocalStore sharedStore] FONTECOR];
        cidade.adjustsFontSizeToFitWidth = YES;
        cidade.tag = 2;
        
        [celula addSubview:nome];
        [celula addSubview:cidade];
    }
    else{
        ((UILabel*)[celula viewWithTag:1]).text = ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).nome;
        ((UILabel*)[celula viewWithTag:2]).text = ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).cidade;
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [celula.imageView sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                               }];
    
    //Layout Celula
    UIView *bgColorCell = [[UIView alloc] init];
    [bgColorCell setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    [celula setSelectedBackgroundView:bgColorCell];
    [celula setBackgroundColor:[UIColor clearColor]];
    
    //Background
    if(indexPath.row % 2 != 0){
        [celula setBackgroundColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]];
    }
    else{
        [celula setBackgroundColor:[UIColor whiteColor]];
    }
    
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

@end
