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

#import "IHKeyboardAvoiding.h"

#import "Reachability.h"

@interface TelaLoginViewController ()

@end

@implementation TelaLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [IHKeyboardAvoiding setAvoidingView:self.view withTarget:_target];
    
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];
    [self carregaLayout];
    
    [self verificaSeEstaLogado];
}

-(void) verificaSeEstaLogado{
    
    if([LoginStore verificaSeEstaLogado]){
        
        [self carregarTabBarInicial];
        [self presentViewController:_tabBar animated:YES completion:nil];
    }
}

-(void)carregaLayout{
    
    //Entrar
    _btnEntrar.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnEntrar.layer.cornerRadius = [[LocalStore sharedStore] RAIOBORDA];
//    [[_btnEntrar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Cadastrar
    _btnCadastrar.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnCadastrar.layer.cornerRadius = [[LocalStore sharedStore] RAIOBORDA];
//    [[_btnCadastrar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Login
    _btnContinuar.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnContinuar.layer.cornerRadius = [[LocalStore sharedStore] RAIOBORDA];
//    [[_btnContinuar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];

    //TXT Email
    [_txtSenha setSecureTextEntry:YES];
    [[_txtEmail layer]setBorderWidth:2.0f];
    [[_txtEmail layer] setCornerRadius:[[LocalStore sharedStore] RAIOTEXT]];
    [[_txtEmail layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
//    [_txtEmail setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //TXT Senha
    [[_txtSenha layer] setBorderWidth:2.0f];
    [[_txtSenha layer] setCornerRadius:[[LocalStore sharedStore] RAIOTEXT]];
    [[_txtSenha layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
//    [_txtSenha setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    //Esqueceu senha
    _lblEsqueceuSenha.tintColor = [[LocalStore sharedStore] FONTECOR];
//    [[_lblEsqueceuSenha titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
}

-(void)viewWillAppear:(BOOL)animated{

    //Navigation Controller
    [[self navigationItem] setTitle:@"Bandburst"];
    [[self navigationItem] setHidesBackButton:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];

    _txtSenha.text = @"";
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//    Verifica internet
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    if (networkStatus == NotReachable) {
//        NSLog(@"There IS NO internet connection");
//    } else {
//        NSLog(@"There IS internet connection");
//        if (networkStatus == ReachableViaWiFi) { NSLog(@"wifi"); }
//        else if (networkStatus == ReachableViaWWAN) { NSLog(@"carrier");}
//    }

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

            [self carregarTabBarInicial];
            
            [self presentViewController:_tabBar animated:YES completion:nil];
            
//            if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaBusca]]) {
//                [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
//            }
//            else{
//                [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
//            }
        }
        else{
            UIAlertView *alertDadosIncorretos = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"E-mail ou senha inválidos" delegate:self cancelButtonTitle:@"Rejeitar" otherButtonTitles:nil];
            [alertDadosIncorretos show];
        }
    }
}

- (IBAction)btnCadastrarClick:(id)sender {
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaCadastro]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaCadastro] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaCadastro] animated:YES];
    }
}

- (IBAction)btnEntrarClick:(id)sender {
    
    [LocalStore setParaUsuarioZero];
    
    [self carregarTabBarInicial];

    [self presentViewController:_tabBar animated:YES completion:nil];
    
    
//    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaBusca]]) {
//        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaGravacao] animated:YES];
//    }
//    else{
//        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
//    }
}

-(void)carregarTabBarInicial{
    
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[[LocalStore sharedStore] TelaGravacoes]];
    UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:[[LocalStore sharedStore] TelaBusca]];
    UINavigationController* nav5 = [[UINavigationController alloc] initWithRootViewController:[[LocalStore sharedStore] TelaPerfil]];
    
    [nav3.navigationBar setTintColor:[[LocalStore sharedStore] FONTECOR]];
    [nav4.navigationBar setTintColor:[[LocalStore sharedStore] FONTECOR]];
    [nav5.navigationBar setTintColor:[[LocalStore sharedStore] FONTECOR]];

    [nav3.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [[LocalStore sharedStore] FONTECOR]}];
    [nav4.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [[LocalStore sharedStore] FONTECOR]}];
    [nav5.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [[LocalStore sharedStore] FONTECOR]}];
    
    nav3.tabBarItem.image = [[UIImage imageNamed:@"gravarIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.image = [[UIImage imageNamed:@"buscador.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav5.tabBarItem.image = [[UIImage imageNamed:@"perfilcone.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _tabBar = [[UITabBarController alloc] init];
    
    [_tabBar.tabBar setFrame:CGRectMake(0, 530, 320, 49)];
    [_tabBar.tabBar setClipsToBounds:YES];
    [_tabBar.tabBar setBarTintColor:[[LocalStore sharedStore] FONTECOR]];
    [_tabBar.tabBar setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    
    [_tabBar setViewControllers:@[nav3, nav4, nav5]];
    [_tabBar setSelectedViewController:nav4];
}

@end
