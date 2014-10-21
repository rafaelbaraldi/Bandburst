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

@interface TelaPerfilBandaViewController ()

@end

@implementation TelaPerfilBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _visualizandoMembros = YES;
        _tbMusicas.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    _banda = [BandaStore buscaBanda:[[BandaStore sharedStore] idBandaSelecionada]];
    
    [[self navigationItem] setTitle:_banda.nome];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelulaDeMembros"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CelulaDeMembros"];
        }
        
        cell.textLabel.text = ((TPUsuario*)[_banda.membros objectAtIndex:indexPath.row]).nome;
        
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelulaDeMusicas"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CelulaDeMusicas"];
        }
        
        cell.textLabel.text = [self carregaNomeMusica:((TPMusica*)[_banda.musicas objectAtIndex:indexPath.row]).url];
        
        return cell;
    }
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
@end
