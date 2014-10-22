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
    
    [_tbInstrumentosQueToca setAlpha:1];
    
    [self carregaFonte];
    
    //Esconde linhas da tabela
    _tbInstrumentosQueToca.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

-(void)carregaFonte{
    [_lblInstrumento setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_lblToco setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_lblTenho setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated{
    [_tbInstrumentosQueToca reloadData];
}

-(BOOL)automaticallyAdjustsScrollViewInsets{
    return NO;
}

-(void)retorna{
    [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaCadastro] animated:YES];
}

//-(void) addInstrumentos{
//    
//    UIBarButtonItem *addInstrumento = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarNovoInstrumento)];
//    [[self navigationItem] setRightBarButtonItem:addInstrumento];
//}

-(void)adicionarNovoInstrumento{
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaTBInstrumentos] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[CadastroStore sharedStore] instrumentosQueToca] count] + 1;
}

//Conteudo das Celulas
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"InstrumentosQueTocaCell"];
    
    
    if (indexPath.row == [[[CadastroStore sharedStore] instrumentosQueToca] count]){
        
        if(celula == nil){
            celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstrumentosQueTocaCell"];
            
            CGRect frame = CGRectMake(15, 2, 250, 40);
            
            UILabel* nome = [[UILabel alloc] initWithFrame:frame];
            [nome setText:@"  Adicionar Instrumento..."];
            [nome setTextColor:[[LocalStore sharedStore] FONTECOR]];
            celula.selectionStyle = UITableViewCellSelectionStyleNone;
            [nome setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
            [nome setAdjustsFontSizeToFitWidth:YES];
            [nome setTag:1];
            [celula addSubview:nome];
            
            UIImageView* imgToco = [[UIImageView alloc] init];
            [imgToco setFrame:CGRectMake(180, 8, 23, 23)];
            [imgToco setTag:2];
            [celula addSubview:imgToco];
            
            UIImageView* imgTenho = [[UIImageView alloc] init];
            [imgTenho setFrame:CGRectMake(250, 8, 23, 23)];
            [imgTenho setTag:3];
            [celula addSubview:imgTenho];
        }
        else{
            UILabel* nome = (UILabel*)[celula viewWithTag:1];
            [nome setText:@"  Adicionar Instrumento..."];
            
            CGRect frame = CGRectMake(15, 2, 250, 40);
            [nome setFrame:frame];
            
            UIImageView* imgToco = (UIImageView*)[celula viewWithTag:2];
            [imgToco setImage:nil];
            
            UIImageView* imgTenho = (UIImageView*)[celula viewWithTag:3];
            [imgTenho setImage:nil];
        }
    }
    else{
        
        NSString *instrumento = [[[CadastroStore sharedStore] instrumentosQueToca] objectAtIndex:indexPath.row];
        instrumento = [instrumento stringByReplacingOccurrencesOfString:@"1" withString:@""];
        
        UIImageView* imgToco;
        UIImageView* imgTenho;
        
        if(celula == nil){
            celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstrumentosQueTocaCell"];
            
            CGRect frame = CGRectMake(15, 2, 140, 40);
            
            UILabel* nome = [[UILabel alloc] initWithFrame:frame];
            [nome setText:instrumento];
            [nome setTextColor:[[LocalStore sharedStore] FONTECOR]];
            celula.selectionStyle = UITableViewCellSelectionStyleNone;
            [nome setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
            [nome setAdjustsFontSizeToFitWidth:YES];
            [nome setTag:1];
            [celula addSubview:nome];
            
            imgToco = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
            [imgToco setFrame:CGRectMake(180, 8, 23, 23)];
            [imgToco setTag:2];
            [celula addSubview:imgToco];
            
            imgTenho = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck.png"]];
            [imgTenho setFrame:CGRectMake(250, 8, 23, 23)];
            [imgTenho setTag:3];
            [celula addSubview:imgTenho];
        }
        else{
            UILabel* nome = (UILabel*)[celula viewWithTag:1];
            [nome setText:instrumento];
            
            CGRect frame = CGRectMake(15, 2, 140, 40);
            [nome setFrame:frame];

            
            imgToco = (UIImageView*)[celula viewWithTag:2];
            [imgToco setImage:[UIImage imageNamed:@"check.png"]];
            
            imgTenho = (UIImageView*)[celula viewWithTag:3];
        }
        
        NSString *condicao = [[[CadastroStore sharedStore] instrumentosQueToca] objectAtIndex:indexPath.row];
        if ([condicao rangeOfString:@"1"].location != NSNotFound) {
            //nao tem 1
            [imgTenho setImage:[UIImage imageNamed:@"check.png"]];
        }
        else{
            //tem 1
            [imgTenho setImage:[UIImage imageNamed:@"uncheck.png"]];
        }
        
    }
    
    return celula;
}

//Selecionar Celula
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row == [[[CadastroStore sharedStore] instrumentosQueToca] count])) {
        [self adicionarNovoInstrumento];
    }
    else{
        UIImageView* imgTenho = (UIImageView*)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];

        NSMutableArray *instrumentos = [[CadastroStore sharedStore] instrumentosQueToca];
        
        NSString *instrumento = [instrumentos objectAtIndex:indexPath.row];
        
        if([instrumento rangeOfString:@"1"].location != NSNotFound){
            instrumento = [instrumento stringByReplacingOccurrencesOfString:@"1" withString:@""];
            [instrumentos replaceObjectAtIndex:indexPath.row withObject:instrumento];
            
            
            [imgTenho setImage:[UIImage imageNamed:@"uncheck.png"]];
        }
        else{
            
            instrumento = [NSString stringWithFormat:@"%@1", instrumento];
            [instrumentos replaceObjectAtIndex:indexPath.row withObject:instrumento];
            
            
            [imgTenho setImage:[UIImage imageNamed:@"check.png"]];
        }
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        [[[CadastroStore sharedStore]instrumentosQueToca] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [[[CadastroStore sharedStore] instrumentosQueToca] count]) {
        return NO;
    }
    else{
        return YES;
    }
}

@end
