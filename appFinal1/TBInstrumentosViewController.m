//
//  TBInstrumentosViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBInstrumentosViewController.h"

#import "LocalStore.h"
#import "CadastroStore.h"

@interface TBInstrumentosViewController ()

@end

@implementation TBInstrumentosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
//    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
    
    [[self navigationItem] setTitle:@"Instrumentos Musicais"];
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaTBInstruementosQueToco] animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
        
    [[[CadastroStore sharedStore] instrumentosFiltrados] removeAllObjects];
    
    if([searchText isEqual:@""]){
        [[[CadastroStore sharedStore] instrumentosFiltrados] addObjectsFromArray:[[CadastroStore sharedStore] instrumentos]];
    }
    
    for (NSString *s in [[CadastroStore sharedStore] instrumentos]){
        if([s rangeOfString:searchText options: NSCaseInsensitiveSearch].location != NSNotFound){
            [[[CadastroStore sharedStore] instrumentosFiltrados] addObject:s];
        }
    }
    
    [_tbInstrumentos reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[CadastroStore sharedStore] instrumentosFiltrados] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"InstrumentosPesquisaCell"];
    
    if(celula == nil){
        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstrumentosPesquisaCell"];
    }
    celula.textLabel.text = [[[CadastroStore sharedStore] instrumentosFiltrados] objectAtIndex:indexPath.row];
    celula.textLabel.textColor = [[LocalStore sharedStore] FONTECOR];
    celula.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
    
    return celula;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![[[CadastroStore sharedStore] instrumentosQueToca] containsObject:[[[CadastroStore sharedStore] instrumentosFiltrados] objectAtIndex:indexPath.row]]){
        [[[CadastroStore sharedStore] instrumentosQueToca] addObject:[[[CadastroStore sharedStore] instrumentosFiltrados] objectAtIndex:indexPath.row]];
    }
    
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaTBInstruementosQueToco] animated:YES];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

@end
