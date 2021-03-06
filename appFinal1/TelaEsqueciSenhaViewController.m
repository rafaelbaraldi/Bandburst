//
//  TelaEsqueciSenhaViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 11/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaEsqueciSenhaViewController.h"

#import "LoginStore.h"
#import "LoginConexao.h"
#import "LocalStore.h"

@interface TelaEsqueciSenhaViewController ()

@end

@implementation TelaEsqueciSenhaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaLayout];
}

-(void)carregaLayout{
    
    //PROCURAR
    _btnProcurar.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnProcurar.layer.cornerRadius =[[LocalStore sharedStore] RAIOBORDA];
    _btnProcurar.titleLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:18];
    
    //TXT EMAIL
    [[_txtEmail layer]setBorderWidth:2.0f];
    [[_txtEmail layer] setCornerRadius:[[LocalStore sharedStore] RAIOTEXT]];
    [[_txtEmail layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [_txtEmail setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    _lblEcontrarConta.textColor = [[LocalStore sharedStore] FONTECOR];
    [_lblEcontrarConta setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Info
    [_txtInfo setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:18]];
    
    //Msg
    _lblMsg.textColor = [[LocalStore sharedStore] FONTECOR];
    [_lblMsg setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega email temporario
    [_txtEmail setText:[[LoginStore sharedStore] emailTemporario]];
    
    [[self navigationItem] setTitle:@"Redefinir senha"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    _btnProcurar.hidden = NO;
    _lblMsg.hidden = YES;
}

-(void)retorna{
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

//Return Text Field
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnProcurarClick:(id)sender {
    
    NSString *email = _txtEmail.text;
    
    if (![email isEqualToString:@""]) {
    
        NSDictionary *retorno = [LoginConexao esqueciSenha:email];
        NSString *resultado = [retorno valueForKeyPath:@"resultado"];

        if([resultado isEqualToString:@"sucesso"]){
            [_lblMsg setHidden:NO];
            [_btnProcurar setHidden:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nenhuma conta encontrada" message:@"Não foi possível encontrar nenhuma conta correspondente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
    
@end
