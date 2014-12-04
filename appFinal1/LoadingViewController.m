//
//  LoadingViewController.m
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 04/12/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Bloquea o acesso do usuario na View
    [self.view setUserInteractionEnabled:YES];
    
    UIImage *image1 = [UIImage imageNamed:@"loading0001.png"];
    UIImage *image2 = [UIImage imageNamed:@"loading0002.png"];
    UIImage *image3 = [UIImage imageNamed:@"loading0003.png"];
    UIImage *image4 = [UIImage imageNamed:@"loading0004.png"];
    UIImage *image5 = [UIImage imageNamed:@"loading0005.png"];
    UIImage *image6 = [UIImage imageNamed:@"loading0006.png"];
    UIImage *image7 = [UIImage imageNamed:@"loading0007.png"];
    UIImage *image8 = [UIImage imageNamed:@"loading0008.png"];
    UIImage *image9 = [UIImage imageNamed:@"loading0009.png"];
    UIImage *image10 = [UIImage imageNamed:@"loading0010.png"];
    NSArray *imageArray = [NSArray arrayWithObjects:image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, nil];
    
    UIImageView *loading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640/2, 1136/2)];
    
    [self.view setAlpha:1.0];
    
    [self.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    
    [self.view addSubview:loading];
    
    [self animacaoSprite:loading :imageArray :2 :100 :YES :YES :0];
}

-(void)animacaoSprite:(UIImageView*)view :(NSArray*)imagensSprite :(float)duracao :(float)repeticao :(BOOL)autoReverso :(BOOL)voltarAoEstadoInicial :(float)tempoDelayComecar{
    
    view.animationImages = imagensSprite;
    
    CAKeyframeAnimation *animacao = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
    animacao.calculationMode = kCAAnimationDiscrete;
    animacao.duration = duracao;
    animacao.repeatCount = INFINITY;
    //    animacao.autoreverses = autoReverso;
    animacao.beginTime = CACurrentMediaTime() + tempoDelayComecar;
    animacao.fillMode = kCAFillModeForwards;
    animacao.removedOnCompletion = voltarAoEstadoInicial;
    animacao.additive = NO;
    animacao.values = [self animationCGImagesArray:view];
    [view.layer addAnimation: animacao forKey:@"animacaoSprite"];
}


//Aux que converte para CGImage, unico jeito para dar certo
-(NSArray*)animationCGImagesArray:(UIImageView*)imgAddAnimacao {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[imgAddAnimacao.animationImages count]];
    for (UIImage *image in imgAddAnimacao.animationImages) {
        [array addObject:(id)[image CGImage]];
    }
    return [NSArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
