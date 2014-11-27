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

#import "GravacaoStore.h"

@interface TelaGravacoesViewController ()

@end

@implementation TelaGravacoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setHidesBackButton:YES];
        
        //Navigation Controller
        [[self navigationItem] setTitle:@"Gravações"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Arredonda views
    [self arredondaBordaBotoes];

    //Adiciona Editar para remover gravações
    [self addEditToRemoveRecords];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self carregaAudios];
    [_tbMusicas reloadData];
}

-(void)addEditToRemoveRecords{
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"Editar" style:UIBarButtonItemStylePlain target:self action:@selector(editRecords)];
    [self.navigationItem setRightBarButtonItem:editItem];
}

-(void)editRecords{
    
    //Começa editar
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Editar"]){
        [self.navigationItem.rightBarButtonItem setTitle:@"Concluído"];
        
        _tbMusicas.editing = YES;
        [self ordenaViewDaTabela:YES];
    }
    else{
        //Finaliza edição
        [self.navigationItem.rightBarButtonItem setTitle:@"Editar"];
        
        _tbMusicas.editing = NO;
        [self ordenaViewDaTabela:NO];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Salvar a musica que vai remover
    _removerMusica = ((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);

    //Action
    UIActionSheet *alerta = [[UIActionSheet alloc] initWithTitle:@"Tem certeza que desja deletar essa gravação?" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Sim, remover gravação", nil];
    [alerta showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0 ){
        [GravacaoStore removerGravacao:_removerMusica];
        
        [self carregaAudios];
        [_tbMusicas reloadData];
    }
}

-(void)ordenaViewDaTabela:(BOOL)edicao{

    CGRect musicaFrame;
    CGRect imagemFrame;
    
    if(edicao){
        musicaFrame = CGRectMake(100, 10, 200, 30);
        imagemFrame = CGRectMake(55, 10, 40, 30);
    }
    else{
        musicaFrame = CGRectMake(60, 10, 200, 30);
        imagemFrame = CGRectMake(15, 10, 40, 30);
    }
    
    
    for (int j = 0; j < [_tbMusicas numberOfSections]; j++){
    
        for (int i = 0; i < [_tbMusicas numberOfRowsInSection:j]; i++){
            
            UITableViewCell *c = [_tbMusicas cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            
            UILabel* musica = (UILabel*)[c viewWithTag:3];
            musica.frame = musicaFrame;
            
            UIImageView *image = (UIImageView*)[c viewWithTag:1];
            image.frame = imagemFrame;
        }
    }
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
    
    //Cor botao
    _btnNovaGravacao.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    //Galeria
    _lblGaleria.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    //seta TabBar
    _tabBarSeta.backgroundColor = [[LocalStore sharedStore] FONTECOR];
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
        
        UIImageView* som = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 30)];
        [som setImage:[UIImage imageNamed:@"audio.png"]];
        [som setTag:1];
        [celula addSubview:som];
        
        UIImageView* play = [[UIImageView alloc] initWithFrame:CGRectMake(270, 5, 35, 35)];
        [play setImage:[UIImage imageNamed:@"playing.png"]];
        [play setTag:2];
        [celula addSubview:play];
        
        UILabel* musica = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
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
    
    //Set gravação para Tocar
    [[GravacaoStore sharedStore] setGravacao: ((Musica*)[[_musicasPorCategoria objectAtIndex:indexPath.section] objectAtIndex:indexPath.row])];
    [[GravacaoStore sharedStore] setStreaming:NO];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaPlayer]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
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
