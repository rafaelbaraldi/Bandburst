//
//  TelaCadastroFotoViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 17/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaCadastroFotoViewController.h"

#import <CoreGraphics/CoreGraphics.h>

#import "LocalStore.h"
#import "CadastroStore.h"
#import "CadastroConexao.h"

@interface TelaCadastroFotoViewController ()

@end

@implementation TelaCadastroFotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fotoSelecionada = [[UIImageView alloc] init];
        
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Carrega menu
    [self carregaMenu];
    
    //Deixa a borda dos boteos arredondados
    [self arredondaBordaBotoes];
    
    [self carregaControladorDeImagem];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self navigationItem] setTitle:@""];
}

-(void)arredondaBordaBotoes{
    
    [[_btnAdicionarFoto layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnContinuar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    [[_btnAdicionarFoto titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnContinuar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_lblMensagem setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self exibiFoto];
    
    [[self navigationItem] setTitle:@"Cadastro Foto"];
}

-(void)exibiFoto{
    
    if (_fotoSelecionada.image != nil) {
        [_imgView setImage:_fotoSelecionada.image];
        
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = _imgView.frame.size.width / 2;
    }
}

//Metodo para alterar dimensoes da imagem
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)btnAdicionarFotoClick:(id)sender {
    
    [_menu showInView:self.view];
}

- (IBAction)btnContinuarClick:(id)sender {
    
    //Verificar se carregou alguma foto
    if (_fotoSelecionada.image != nil) {
        UIImage *foto = _fotoSelecionada.image;
        foto = [self imageWithImage:foto scaledToSize:CGSizeMake(96, 128)];
        
        [CadastroConexao uploadFoto: foto];
    }
    
    //Limpa Imagem
    _fotoSelecionada.image = [UIImage imageNamed:@"placeholderFoto.png"];
    
    //Vai para tela de busca - inicio do APP
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaPerfil]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaBusca] animated:YES];
    }
}

-(void)carregaMenu{
    
    _menu = [[UIActionSheet alloc]  initWithTitle:@""
                                         delegate:self
                                cancelButtonTitle:@"Cancelar"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"Importar do Facebook", @"Tirar foto", @"Escolher na biblioteca", nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex){
        case 0:
            [self importarDoFacebook];
            break;
        case 1:
            [self tirarFoto];
            break;
        case 2:
            [self escolherNaBiblioteca];
            break;
    }
}

-(void)importarDoFacebook{
}

-(void)escolherNaBiblioteca{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)carregaControladorDeImagem{
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.editing = YES;
    _imagePickerController.delegate = (id)self;
    
    _fotoSelecionada = [[UIImageView alloc] init];
}

-(void)tirarFoto{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;

    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _fotoSelecionada.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
