//
//  TBEstilosQueTocaViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBEstilosQueTocaViewController.h"

#import "CadastroStore.h"
#import "LocalStore.h"

#import "TBEstilosViewController.h"

@interface TBEstilosQueTocaViewController ()

@end

@implementation TBEstilosQueTocaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Meus Estilos Musicas"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Adiconar Estilos
    [self addEstilos];
}

-(void) viewWillAppear:(BOOL)animated{
    [_tbEstilosQueToca reloadData];
}

-(void) addEstilos{
    
    UIBarButtonItem *addEstilo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoEstilo)];
    [[self navigationItem] setRightBarButtonItem:addEstilo];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaCadastro] animated:YES];
}

-(void)adicionarNovoEstilo{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaTBEstilos] animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[CadastroStore sharedStore] estilosQueToca] count];
}

//Conteudo das Celulas
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"EstilosQueTocaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EstilosQueTocaCell"];
    }
    celula.textLabel.text = [[[CadastroStore sharedStore] estilosQueToca] objectAtIndex:indexPath.row];
    
    return celula;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        [[[CadastroStore sharedStore]estilosQueToca]removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
