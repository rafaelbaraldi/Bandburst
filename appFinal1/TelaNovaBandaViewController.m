//
//  TelaNovaBandaViewController.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.

#import "TelaNovaBandaViewController.h"
#import "BandaStore.h"
#import "LocalStore.h"

#import "TPUsuario.h"

#import "UIImageView+WebCache.h"
#import "celulaPerfilTableViewCell.h"

@interface TelaNovaBandaViewController ()
@end

@implementation TelaNovaBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self carregaLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [_tbMembros reloadData];
    
    //Navigation Controller
    [[self navigationItem] setTitle:@"Nova banda"];
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) carregaLayout{
    
    //Criar banda
    [_btnCriarBanda setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    [[_btnCriarBanda layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
//    [[_btnCriarBanda titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14]];
    
    //Nome da banda
    [[_txtNomeDaBanda layer] setBorderWidth:2.0f];
    [[_txtNomeDaBanda layer] setCornerRadius:[[LocalStore sharedStore] RAIOTEXT]];
    [[_txtNomeDaBanda layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];

    //Mais membro
    [_btnMaisMembro setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    [[_btnMaisMembro layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnMaisMembro titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14]];
    
    //Esconde linhas em branco da TableView
    _tbMembros.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbMembros.separatorColor = [UIColor clearColor];
}

- (IBAction)btnMaisMembroClick:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaAmigos] animated:YES];
}

- (IBAction)btnCriarBandaClick:(id)sender {
    if ([_txtNomeDaBanda.text length] > 0 && [[[BandaStore sharedStore] membros] count] > 0) {
        NSString* idDosMembros = [[[LocalStore sharedStore] usuarioAtual] identificador];
        
        for (TPUsuario* s in [[BandaStore sharedStore] membros]) {
            idDosMembros = [NSString stringWithFormat:@"%@, %@", idDosMembros, s.identificador];
        }
        
        [BandaStore criarBanda:_txtNomeDaBanda.text membros:idDosMembros];
        
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaPerfil] animated:YES];
    }
}

- (IBAction)txtNomeDaBandaDone:(id)sender {
    [sender resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[BandaStore sharedStore] membros] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"MembrosCell"];
//    
//    if(celula == nil){
//        celula = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MembrosCell"];
//    }
//    celula.textLabel.text = ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).nome;
//    
//    return celula;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    celulaPerfilTableViewCell* celula = [tableView dequeueReusableCellWithIdentifier:@"UsuarioPesquisaCell"];
    
    //URL Foto do Usuario
    NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).identificador];
    NSURL *imageURL = [NSURL URLWithString:urlFoto];
    
    if(celula == nil){
        celula = [[celulaPerfilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsuarioPesquisaCell"];
        
        //Remove cor de seleção
        celula.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nome = [[UILabel alloc] initWithFrame:CGRectMake(120, 25, 170, 20)];
        nome.text = ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).nome;
        nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16];
        nome.textColor = [[LocalStore sharedStore] FONTECOR];
        nome.adjustsFontSizeToFitWidth = YES;
        nome.tag = 1;
        
        UILabel *cidade = [[UILabel alloc] initWithFrame:CGRectMake(120, 55, 170, 15)];
        cidade.text = ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).cidade;
        cidade.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12];
        cidade.textColor = [[LocalStore sharedStore] FONTECOR];
        cidade.adjustsFontSizeToFitWidth = YES;
        cidade.tag = 2;
        
        [celula addSubview:nome];
        [celula addSubview:cidade];
    }
    else{
        ((UILabel*)[celula viewWithTag:1]).text = ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).nome;
        ((UILabel*)[celula viewWithTag:2]).text = ((TPUsuario*)[[[BandaStore sharedStore] membros] objectAtIndex:indexPath.row]).cidade;
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [celula.imageView sd_setImageWithURL:imageURL placeholderImage:[self carregaImagemFake]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:urlFoto];
                               }];
    
    //Layout Celula
    UIView *bgColorCell = [[UIView alloc] init];
    [bgColorCell setBackgroundColor:[[LocalStore sharedStore] FONTECOR]];
    [celula setSelectedBackgroundView:bgColorCell];
    [celula setBackgroundColor:[UIColor clearColor]];
    
    return celula;
}

-(UIImage*)carregaImagemFake{
    
    UIImageView *fotoUsuario = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    fotoUsuario.image = [UIImage imageNamed:@"placeholderFoto.png"];
    fotoUsuario.layer.masksToBounds = YES;
    fotoUsuario.layer.cornerRadius = fotoUsuario.frame.size.width / 2;
    fotoUsuario.tag = 4;
    
    return fotoUsuario.image;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        [[[BandaStore sharedStore] membros] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
