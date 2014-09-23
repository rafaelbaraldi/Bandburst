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
        [[self navigationItem] setTitle:@"Redefinir Senha"];
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //bg
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];
    [self arredondaBordaBotoes];
}

-(void)arredondaBordaBotoes{
    [[_btnProcurar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega email temporario
    [_txtEmail setText:[[LoginStore sharedStore] emailTemporario]];
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
@end
