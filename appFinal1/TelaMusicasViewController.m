//
//  TelaMusicasViewController.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 08/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaMusicasViewController.h"
#import "LocalStore.h"
#import "PerfilStore.h"
#import "Musica.h"
#import "TelaInfosBandaViewController.h"
#import "BandaStore.h"

@interface TelaMusicasViewController ()
@end

@implementation TelaMusicasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _musicas = [PerfilStore retornaListaDeMusicas];
        _categorias = [PerfilStore retornaListaDeCategorias:_musicas];
        _musicasPorCategoria = [PerfilStore retornaListaDeMusicasPorCategorias:_musicas];
        
        //Navigation Controller
        [[self navigationItem] setTitle:@"Selecionar gravação"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Esconde linhas em branco da TableView
    _tbMusicas.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMusicas.separatorColor = [UIColor clearColor];
    
    _lblGaleria.backgroundColor = [[LocalStore sharedStore] FONTECOR];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_categorias count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_musicasPorCategoria objectAtIndex:section] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_categorias objectAtIndex:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"MembrosCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MembrosCell"];
        
        UIImageView* som = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 30)];
        [som setImage:[UIImage imageNamed:@"audio.png"]];
        [som setTag:1];
        [celula addSubview:som];
        
//        UIImageView* play = [[UIImageView alloc] initWithFrame:CGRectMake(270, 5, 35, 35)];
//        [play setImage:[UIImage imageNamed:@"playing.png"]];
//        [play setTag:2];
//        [celula addSubview:play];
        
        UILabel* musica = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
        [musica setText:((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).nome];
        [musica setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
        [musica setTextColor:[[LocalStore sharedStore] FONTECOR]];
        [musica setTag:3];
        [celula addSubview:musica];
        
        if([_musicas indexOfObject:[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] % 2 == 0){
            [celula setBackgroundColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]];
        }
        else{
            [celula setBackgroundColor:[UIColor whiteColor]];
        }
    }
    else{
        UILabel* musica = (UILabel*)[celula viewWithTag:3];
        [musica setText:((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).nome];
        
        if([_musicas indexOfObject:[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] % 2 == 0){
            [celula setBackgroundColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]];        }
        else{
            [celula setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    return celula;
}

-(void)enviaMusicaServidor:(NSIndexPath*)indexPath{
    NSString* s = [BandaStore enviaMusica:((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).nome urlMusica:((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).url idBanda:[[BandaStore sharedStore] bandaSelecionada].identificador idUsuario:[[LocalStore sharedStore] usuarioAtual].identificador];
    
    if([s length] > 0){
        [BandaStore enviaMensagem:[NSString stringWithFormat:@"%@ enviou uma nova gravação! Consulte as músicas de sua banda.", [[LocalStore sharedStore] usuarioAtual].nome] idBanda:[[BandaStore sharedStore] bandaSelecionada].identificador idUsuario:[[LocalStore sharedStore] usuarioAtual].identificador];
    }
    
    //Recarrega banda com nova musica
    [[BandaStore sharedStore] setBandaSelecionada:[BandaStore buscaBanda:[[BandaStore sharedStore] idBandaSelecionada]]];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        [self enviaMusicaServidor:_indexMusica];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _indexMusica = indexPath;
    
    UIAlertView *alertMusica = [[UIAlertView alloc] initWithTitle:@"Musica" message:@"Tem certeza que deseja enviar essa gravação?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Sim", nil];
    
    [alertMusica show];
}

@end
