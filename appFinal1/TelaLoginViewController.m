//
//  TelaLoginViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaLoginViewController.h"
#import "TelaBuscaViewController.h"
#import "TelaEsqueciSenhaViewController.h"

#import "LoginStore.h"
#import "LocalStore.h"

#import "Reachability.h"

@interface TelaLoginViewController ()

@end

@implementation TelaLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [[self navigationItem] setTitle:@"Login"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //bg
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] CORFONTE]];
    [self arredondaBordaBotoes];
    [_txtSenha setSecureTextEntry:YES];

//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    if (networkStatus == NotReachable) {
//        NSLog(@"There IS NO internet connection");
//    } else {
//        NSLog(@"There IS internet connection");
//        if (networkStatus == ReachableViaWiFi) { NSLog(@"wifi"); }
//        else if (networkStatus == ReachableViaWWAN) { NSLog(@"carrier");}
//    }
}

-(void)arredondaBordaBotoes{
    
    [[_btnContinuar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
}

-(void)viewWillDisappear:(BOOL)animated{
    _txtSenha.text = @"";
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//Return Text Field
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnSenhaClick:(id)sender {
    
    //Salva email temporario
    [[LoginStore sharedStore] setEmailTemporario:_txtEmail.text];
    
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaEsqueciSenha] animated:YES];
}

- (IBAction)btnContinuarClick:(id)sender {
    
    NSString *email = _txtEmail.text;
    NSString *senha = _txtSenha.text;
    
    if([email length] > 0 && [senha length] > 0){
        if([LoginStore login:email senha:senha]){
            
            if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaBusca]]) {
                [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
            }
            else{
                [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
            }
        }
        else{
            UIAlertView *alertDadosIncorretos = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"E-mail ou senha inválidos" delegate:self cancelButtonTitle:@"Rejeitar" otherButtonTitles:nil];
            [alertDadosIncorretos show];
        }
    }
}
@end
