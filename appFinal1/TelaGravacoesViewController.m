//
//  TelaGravacoesViewController.m
//  Bandburst
//
//  Created by RAFAEL BARALDI on 30/09/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaGravacoesViewController.h"
#import "LocalStore.h"
#import "PerfilStore.h"
#import "Musica.h"

#import <MediaPlayer/MediaPlayer.h>

@interface TelaGravacoesViewController ()

@end

@implementation TelaGravacoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[self navigationItem] setTitle:@"Gravar"];
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Arredonda views
    [self arredondaBordaBotoes];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self carregaAudios];
    [_tbMusicas reloadData];
}

-(void)carregaAudios{
    _musicas = [PerfilStore retornaListaDeMusicas];
    _categorias = [PerfilStore retornaListaDeCategorias:_musicas];
    _musicasPorCategoria = [PerfilStore retornaListaDeMusicasPorCategorias:_musicas];
}

-(void)arredondaBordaBotoes{
    
    [[_btnNovaGravacao layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnNovaGravacao titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Esconde linhas em branco da TableView
    _tbMusicas.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMusicas.separatorColor = [UIColor clearColor];
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
        
        UIImageView* play = [[UIImageView alloc] initWithFrame:CGRectMake(270, 5, 35, 35)];
        [play setImage:[UIImage imageNamed:@"playing.png"]];
        [play setTag:2];
        [celula addSubview:play];
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Musica* musica = ((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    NSLog(@"%@", musica.url);
    NSString *thePath = [NSString stringWithFormat:@"%@.mp3", musica.url];
    NSURL *url=[NSURL URLWithString:thePath];
    
    MPMoviePlayerController* musicPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    musicPlayer.shouldAutoplay=NO;
    musicPlayer.repeatMode = NO;
    [self.view addSubview:musicPlayer.view];
    
    [musicPlayer setFullscreen:YES animated:YES];
    [musicPlayer play];
    musicPlayer.backgroundView.backgroundColor = [[LocalStore sharedStore] FONTECOR];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNovaGravacaoClick:(id)sender {
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaGravacao]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaGravacao] animated:NO];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaGravacao] animated:NO];
    }
}
@end
