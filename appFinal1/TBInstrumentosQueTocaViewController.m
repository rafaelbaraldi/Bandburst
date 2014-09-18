//
//  TBInstrumentosQueTocaViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBInstrumentosQueTocaViewController.h"

#import "LocalStore.h"
#import "CadastroStore.h"

@interface TBInstrumentosQueTocaViewController ()

@end

@implementation TBInstrumentosQueTocaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Meus Instrumentos"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Adiconar Estilos
    [self addInstrumentos];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated{
    [_tbInstrumentosQueToca reloadData];
    
    //Adicionar texto
    if([[[CadastroStore sharedStore] instrumentosQueToca] count] > 0){
        [_lblInstrumentos setHidden:NO];
    }
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaCadastro] animated:YES];
}

-(void) addInstrumentos{
    
    UIBarButtonItem *addInstrumento = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoInstrumento)];
    [[self navigationItem] setRightBarButtonItem:addInstrumento];
}

-(void)adicionarNovoInstrumento{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaTBInstrumentos] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[CadastroStore sharedStore] instrumentosQueToca] count];
}

//Conteudo das Celulas
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"InstrumentosQueTocaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstrumentosQueTocaCell"];
    }
    NSString *instrumento = [[[CadastroStore sharedStore] instrumentosQueToca] objectAtIndex:indexPath.row];
    instrumento = [instrumento stringByReplacingOccurrencesOfString:@"1" withString:@""];
    celula.textLabel.text = instrumento;
    
    return celula;
}

//Selecionar Celula
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        
        //Remove gambi para saber que tem instrumento
        NSMutableArray *instrumentos = [[CadastroStore sharedStore] instrumentosQueToca];
        
        NSString *instrumento = [instrumentos objectAtIndex:indexPath.row];
        
        if([instrumento rangeOfString:@"1"].location != NSNotFound){
            instrumento = [instrumento stringByReplacingOccurrencesOfString:@"1" withString:@""];
            [instrumentos replaceObjectAtIndex:indexPath.row withObject:instrumento];
        }
    }
    else{
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        //Adiciona gambi para saber que tem instrumento
        NSMutableArray *instrumentos = [[CadastroStore sharedStore] instrumentosQueToca];
        
        NSString *instrumento = [instrumentos objectAtIndex:indexPath.row];
        
        instrumento = [NSString stringWithFormat:@"%@1", instrumento];
        [instrumentos replaceObjectAtIndex:indexPath.row withObject:instrumento];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        [[[CadastroStore sharedStore]instrumentosQueToca] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
