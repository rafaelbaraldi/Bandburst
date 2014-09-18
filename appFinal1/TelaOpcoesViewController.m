//
//  TelaOpcoesViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 01/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaOpcoesViewController.h"

#import "LocalStore.h"
#import "LoginStore.h"

@interface TelaOpcoesViewController ()

@end

@implementation TelaOpcoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Opções"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnAlterarFoto:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaCadastroFoto] animated:YES];
}

- (IBAction)btnEcontrarAmigos:(id)sender {
}

- (IBAction)btnSair:(id)sender {
    [LoginStore deslogar];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaInicio]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaInicio] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaInicio] animated:YES];
    }
}
@end
