//
//  TBFiltroHorario.m
//  appFinal1
//
//  Created by Rafael Cardoso on 24/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TBFiltroHorario.h"

#import "BuscaStore.h"
#import "LocalStore.h"

#import "LayoutCustom.h"

@interface TBFiltroHorario ()

@end

@implementation TBFiltroHorario

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Filtro de Disponibilidade"];
    }
    return self;
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaValoresHorarios];
    [self carregaLayout];
}

-(void)viewWillAppear:(BOOL)animated{

    if([[[BuscaStore sharedStore] horario] length] > 0){
        [self carregaRemoverFiltro];
    }
    else{
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    
    [_collectionHorario reloadData];
}

-(void) carregaLayout{
    [_collectionHorario setBackgroundColor:[UIColor clearColor]];
    
    _lblSegunda.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblTerca.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblQuarta.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblQuinta.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblSexta.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblSabado.textColor = [[LocalStore sharedStore] FONTECOR];
    _lblDomingo.textColor = [[LocalStore sharedStore] FONTECOR];
    
    _lblHorarios.textColor = [[LocalStore sharedStore] FONTECOR];
}

-(void)carregaRemoverFiltro{
    
    UIBarButtonItem *buttonItemOpcoes = [[UIBarButtonItem alloc] initWithTitle:@"Remover" style:UIBarButtonItemStylePlain target:self action:@selector(removerFiltro)];
    [[self navigationItem] setRightBarButtonItem:buttonItemOpcoes animated:YES];
}

-(void)removerFiltro{
    [[BuscaStore sharedStore] setHorario:@""];
    [[[BuscaStore sharedStore] horariosFiltrados] removeAllObjects];

    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_horarios count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray *data = [_horarios objectAtIndex:section];
    return [data count];
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *data = [_horarios objectAtIndex:indexPath.section];
    NSString *cellData = [data objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    NSMutableArray *horarios = [[BuscaStore sharedStore] horariosFiltrados];
    if ([horarios containsObject:cellData]){
        [cell addSubview:[LayoutCustom botaoCollectionViewCellSelecionado]];
    }
    else{
        [cell addSubview:[LayoutCustom botaoCollectionViewCellDefatult:cell]];
    }
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *data = [_horarios objectAtIndex:indexPath.section];
    NSString *cellData = [data objectAtIndex:indexPath.row];
    
    NSMutableArray *horarios = [[BuscaStore sharedStore] horariosFiltrados];
    if (![horarios containsObject:cellData] ){
        [horarios addObject:cellData];
        [cell addSubview:[LayoutCustom botaoCollectionViewCellSelecionado]];
    }
    else{
        [horarios removeObject:cellData];
        [cell addSubview:[LayoutCustom botaoCollectionViewCellDefatult:cell]];
    }
}

-(void)carregaValoresHorarios{
    
    //Carrega Cell
    UINib *nib = [UINib nibWithNibName:@"cellHorario" bundle:nil];
    [_collectionHorario registerNib:nib forCellWithReuseIdentifier:@"cvCell"];
    
    //Carrega Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(45, 25)];
    [layout setSectionInset:UIEdgeInsetsMake(10, 25, 10, 10)];
    [_collectionHorario setCollectionViewLayout:layout];
    
    [_collectionHorario setBackgroundColor:[UIColor whiteColor]];;

    
    //Carrega Valores
    NSMutableArray *secao1 = [[NSMutableArray alloc] init];
    NSMutableArray *secao2 = [[NSMutableArray alloc] init];
    NSMutableArray *secao3 = [[NSMutableArray alloc] init];
    NSMutableArray *secao4 = [[NSMutableArray alloc] init];
    NSMutableArray *secao5 = [[NSMutableArray alloc] init];
    NSMutableArray *secao6 = [[NSMutableArray alloc] init];
    NSMutableArray *secao7 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        [secao1 addObject:[NSString stringWithFormat:@"segunda%i", i]];
        [secao2 addObject:[NSString stringWithFormat:@"terca%i", i]];
        [secao3 addObject:[NSString stringWithFormat:@"quarta%i", i]];
        [secao4 addObject:[NSString stringWithFormat:@"quinta%i", i]];
        [secao5 addObject:[NSString stringWithFormat:@"sexta%i", i]];
        [secao6 addObject:[NSString stringWithFormat:@"sabado%i", i]];
        [secao7 addObject:[NSString stringWithFormat:@"domingo%i", i]];
    }
    
    _horarios = [[NSArray alloc] initWithObjects:secao1, secao2, secao3, secao4, secao5, secao6, secao7, nil];
}

@end
