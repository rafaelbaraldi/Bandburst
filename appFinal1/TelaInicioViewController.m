//
//  TelaInicioViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 15/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaInicioViewController.h"

#import "LocalStore.h"

@interface TelaInicioViewController ()

@end

@implementation TelaInicioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[self navigationItem] setTitle:@"AppMusica"];
        [[self navigationItem] setHidesBackButton:YES];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //bg
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self arredondaBordaBotoes];
    
    //teste nome fontes
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
}

-(void)arredondaBordaBotoes{
    
    [[_btnCadastrar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnEntrar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnLogin layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    [[_btnCadastrar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnEntrar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnLogin titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaBusca]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
    }
}

- (IBAction)btnLoginClick:(id)sender {
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaLogin]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaLogin] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaLogin] animated:YES];
    }
}
@end
