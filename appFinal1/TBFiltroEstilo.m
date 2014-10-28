//
//  TBFiltroEstilo.m
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBFiltroEstilo.h"
#import "BuscaStore.h"
#import "BuscaConexao.h"

#import "LocalStore.h"

@interface TBFiltroEstilo ()

@end

@implementation TBFiltroEstilo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];

    //Carrega Lista de todos estilos musicais
    _todosEstilos = [BuscaStore retornaListaDe:@"estilo"];

    //Remove lista de estilos pelo filtro de Busca 
    [[[BuscaStore sharedStore] estilosFiltrados] removeAllObjects];
    
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([[[BuscaStore sharedStore] estilo] length] > 0){
        [self carregaRemoverFiltro];
    }
    else{
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    
    //Navigation Controller
    [[self navigationItem] setTitle:@"Filtro estilo musical"];
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
}

-(void)carregaRemoverFiltro{
    
    UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithTitle:@"Remover" style:UIBarButtonItemStyleBordered target:self action:@selector(removerFiltro)];
    [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
}

-(void)removerFiltro{
    [[BuscaStore sharedStore] setEstilo:@""];
    
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[[BuscaStore sharedStore] estilosFiltrados] count] == 0){
        return [_todosEstilos  count];
    }
    else{
        return [[[BuscaStore sharedStore] estilosFiltrados]  count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"EstilosPesquisaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EstilosPesquisaCell"];
    }
    if([[[BuscaStore sharedStore] estilosFiltrados] count] == 0){
        celula.textLabel.text = [_todosEstilos  objectAtIndex:indexPath.row];
    }
    else{
        celula.textLabel.text = [[[BuscaStore sharedStore] estilosFiltrados]  objectAtIndex:indexPath.row];
    }
    
    celula.textLabel.textColor = [[LocalStore sharedStore] FONTECOR];
    celula.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
    
    return celula;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[BuscaStore sharedStore] estilosFiltrados] count] == 0){
        [[BuscaStore sharedStore] setEstilo:[_todosEstilos objectAtIndex:indexPath.row]];
    }
    else{
        [[BuscaStore sharedStore] setEstilo:[[[BuscaStore sharedStore] estilosFiltrados] objectAtIndex:indexPath.row]];
    }
    
    [self retorna];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [[[BuscaStore sharedStore] estilosFiltrados] removeAllObjects];
    
    if([searchText isEqual:@""]){
        [[[BuscaStore sharedStore] estilosFiltrados] addObjectsFromArray:_todosEstilos];
    }
    
    for (NSString *s in _todosEstilos){
        if([s rangeOfString:searchText options: NSCaseInsensitiveSearch].location != NSNotFound){
            [[[BuscaStore sharedStore] estilosFiltrados] addObject:s];
        }
    }
    
    [_tbEstilos reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
