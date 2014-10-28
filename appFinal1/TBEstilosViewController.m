//
//  TBEstilosViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBEstilosViewController.h"

#import "CadastroStore.h"
#import "LocalStore.h"

@interface TBEstilosViewController ()

@end

@implementation TBEstilosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
    [[self navigationItem] setTitle:@"Estilos Musicais"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaTBEstilosQueToco] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[CadastroStore sharedStore] estilosFiltrados] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"EstilosPesquisaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EstilosPesquisaCell"];        
        celula.textLabel.textColor = [[LocalStore sharedStore] FONTECOR];
        celula.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
    }
    celula.textLabel.text = [[[CadastroStore sharedStore] estilosFiltrados] objectAtIndex:indexPath.row];
    
    return celula;
}

//Selecionar Celula
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[[CadastroStore sharedStore] estilosQueToca] containsObject:[[[CadastroStore sharedStore] estilosFiltrados] objectAtIndex:indexPath.row]]){
        [[[CadastroStore sharedStore] estilosQueToca] addObject:[[[CadastroStore sharedStore] estilosFiltrados] objectAtIndex:indexPath.row]];
    }
    
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaTBEstilosQueToco] animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [[[CadastroStore sharedStore] estilosFiltrados] removeAllObjects];
    
    if([searchText isEqual:@""]){
        [[[CadastroStore sharedStore] estilosFiltrados] addObjectsFromArray:[[CadastroStore sharedStore] estilos]];
    }
    
    for (NSString *s in [[CadastroStore sharedStore] estilos]) {
        if([s rangeOfString:searchText options: NSCaseInsensitiveSearch].location != NSNotFound){
            [[[CadastroStore sharedStore] estilosFiltrados] addObject:s];
        }
    }
    
    [_tbEstilosPesquisar reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

@end
