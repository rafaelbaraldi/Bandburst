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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Filtro Estilo Musical"];
    }
    return self;
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //Carrega Lista de todos estilos musicais
    _todosEstilos = [BuscaStore retornaListaDe:@"estilo"];

    //Remove lista de estilos pelo filtro de Busca 
    [[[BuscaStore sharedStore] estilosFiltrados] removeAllObjects];
    
    //BG
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
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
