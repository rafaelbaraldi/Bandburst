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

@interface TelaAmigosViewController ()

@end

@implementation TelaAmigosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _amigos = [[NSMutableArray alloc] init];
        _amigosFiltrados = [[NSMutableArray alloc] init];
        
        [[self navigationItem] setTitle:@"Amigos"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _amigos = [BandaStore retornaListaDeAmigos] ;
    
    [_amigosFiltrados addObjectsFromArray:_amigos];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_amigosFiltrados count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"MembrosCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MembrosCell"];
    }
    celula.textLabel.text = ((TPUsuario*)[_amigosFiltrados objectAtIndex:indexPath.row]).nome;
    return celula;
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

@end
