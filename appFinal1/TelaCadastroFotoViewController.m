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

#import "UIImageView+WebCache.h"

@interface TelaCadastroFotoViewController ()

@end

@implementation TelaCadastroFotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fotoSelecionada = [[UIImageView alloc] init];
        [[self navigationItem] setTitle:@"Foto"];
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
    _trocouImagem = NO;
}

-(void)verificaCadastroOuAtualizacao{
    
    if([[CadastroStore sharedStore] cadastro] == YES){
        [self.navigationItem setHidesBackButton:YES];
        _lblMensagem.hidden = NO;
    }
    else{
        [self.navigationItem setHidesBackButton:NO];
        _lblMensagem.hidden = YES;
    }
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
    
    //Verifica se está cadastrando ao Alterando Foto
    [self verificaCadastroOuAtualizacao];
}

-(void)arredondaBordaBotoes{
    
    [[_btnAdicionarFoto layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnContinuar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    _btnAdicionarFoto.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    _btnContinuar.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    _lblMensagem.textColor = [[LocalStore sharedStore] FONTECOR];
    
    [[_btnAdicionarFoto titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnContinuar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_lblMensagem setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
}

-(void)exibiFoto{
    
    if (![[CadastroStore sharedStore] cadastro] && !_trocouImagem) {
        NSString *urlFoto = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", [[LocalStore sharedStore] usuarioAtual].identificador];
        
        _imgView.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlFoto];
    }
    
    if(_trocouImagem){
        _imgView.image = _fotoSelecionada.image;
    }
    
    if(_imgView.image == nil){
        _imgView.image = [UIImage imageNamed:@"placeholderFoto.png"];
    }

    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = _imgView.frame.size.width / 2;
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
    if (_fotoSelecionada.image != nil && _trocouImagem) {
        UIImage *foto = _fotoSelecionada.image;
        foto = [self imageWithImage:foto scaledToSize:CGSizeMake(96, 128)];
        
        //Salva imagem no servidor
        [CadastroConexao uploadFoto:foto];
        
        //Altera imagem no cache
        [[SDImageCache sharedImageCache] storeImage:foto forKey:[NSString stringWithFormat:@"http://54.207.112.185/appMusica/FotosDePerfil/%@.png", [[LocalStore sharedStore] usuarioAtual].identificador]];
        
        //Precisa trocar a foto na proxima vez para salvar
        _trocouImagem = NO;
    }
    
    //Limpa Imagem
    _fotoSelecionada.image = [UIImage imageNamed:@"placeholderFoto.png"];
    
    //Verifica para qual View deve seguir
    UIViewController *vc;
    if([[CadastroStore sharedStore] cadastro]){
        
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
    else{
        vc = [[LocalStore sharedStore] TelaPerfil];
    }
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
        [[self navigationController] popToViewController:vc animated:YES];
    }
    else{
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

-(void)carregaMenu{
    
    _menu = [[UIActionSheet alloc]  initWithTitle:@"Alterar foto do perfil"
                                         delegate:self
                                cancelButtonTitle:@"Cancelar"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"Tirar foto", @"Escolher na biblioteca", nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex){
        case 0:
            [self tirarFoto];
            break;
        case 1:
            [self escolherNaBiblioteca];
            break;
    }
}

-(void)carregaControladorDeImagem{
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.editing = YES;
    _imagePickerController.delegate = (id)self;
    
    _fotoSelecionada = [[UIImageView alloc] init];
}

//Troca imagem importando do face
-(void)importarDoFacebook{
    
    
}

//Troca imagem escolhendo a partir da biblioteca
-(void)escolherNaBiblioteca{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}


//Trocar imagem tirando nova foto
-(void)tirarFoto{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    
    //    _fotoSelecionada.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    

    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _fotoSelecionada.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//        _fotoSelecionada.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //Marca que a imagem foi trocada
    _trocouImagem = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
