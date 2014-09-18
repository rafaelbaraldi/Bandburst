//
//  TBFiltroInstrumento.m
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBFiltroInstrumento.h"

#import "LocalStore.h"

#import "BuscaStore.h"
#import "BuscaConexao.h"


@interface TBFiltroInstrumento ()

@end

@implementation TBFiltroInstrumento

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[self navigationItem] setTitle:@"Filtro Instrumento"];
    }
    return self;
}

-(void)retorna{
    
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Carrega lista de todos instrumentos musicais
    _todosInstrumentos = [BuscaStore retornaListaDe:@"instrumento"];
    
    //Remove lista de busca de instrumentos filtrados
    [[[BuscaStore sharedStore] instrumentosFiltrados] removeAllObjects];
    
    //BG
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[[BuscaStore sharedStore] instrumentosFiltrados] count] == 0){
        return [_todosInstrumentos  count];
    }
    else{
        return [[[BuscaStore sharedStore] instrumentosFiltrados]  count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"InstrumentosPesquisaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstrumentosPesquisaCell"];
    }
    if([[[BuscaStore sharedStore] instrumentosFiltrados] count] == 0){
        celula.textLabel.text = [_todosInstrumentos  objectAtIndex:indexPath.row];
    }
    else{
        celula.textLabel.text = [[[BuscaStore sharedStore] instrumentosFiltrados]  objectAtIndex:indexPath.row];
    }
    
    return celula;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[[BuscaStore sharedStore] instrumentosFiltrados] count] == 0){
        [[BuscaStore sharedStore] setInstrumento:[_todosInstrumentos objectAtIndex:indexPath.row]];
    }
    else{
        [[BuscaStore sharedStore] setInstrumento:[[[BuscaStore sharedStore] instrumentosFiltrados] objectAtIndex:indexPath.row]];
    }
        
    [self retorna];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [[[BuscaStore sharedStore] instrumentosFiltrados] removeAllObjects];
    
    if([searchText isEqual:@""]){
        [[[BuscaStore sharedStore] instrumentosFiltrados] addObjectsFromArray:_todosInstrumentos];
    }
    
    for (NSString *s in _todosInstrumentos){
        if([s rangeOfString:searchText options: NSCaseInsensitiveSearch].location != NSNotFound){
            [[[BuscaStore sharedStore] instrumentosFiltrados] addObject:s];
        }
    }
    
    [_tbInstrumentos reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
