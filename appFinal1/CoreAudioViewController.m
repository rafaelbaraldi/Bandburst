//
//  CoreAudioViewController.m
//  AudioPlayer
//
//  Created by RAFAEL CARDOSO DA SILVA on 14/02/14.
//  Copyright (c) 2014 RAFAEL CARDOSO DA SILVA. All rights reserved.
//

#import "CoreAudioViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Musica.h"
#import "LocalStore.h"

@interface CoreAudioViewController ()
@end

@implementation CoreAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gravando = false;
        
        [[self navigationItem] setTitle:@"Gravar"];
        [[self navigationItem] setHidesBackButton:YES];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Imagem do tab bar selecionada
    [_tabBar setSelectedItem:_gravarItem];
    [_tabBar setTintColor:[[LocalStore sharedStore] CORFONTE]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //bg - Layout
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self arredondaBordaBotoes];
    
    //Carrega todas as músicas do CoreData
    _musicas = [[NSMutableArray alloc]initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Musica"] error:nil]];
}

-(void)arredondaBordaBotoes{
    
    [[_btnGravar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnTocar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
}

-(void)carregaGravador{
    
    //Set configuração da Gravação
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //URL da música a gravar
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%@.%@", 0, _txtCategoria.text, _txtNome.text]]];
    
    urlPlay = url;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

//Registar gravação no CoreData
-(void)registrarGravacao{
    
    Musica *m = [NSEntityDescription insertNewObjectForEntityForName:@"Musica" inManagedObjectContext:[[LocalStore sharedStore] context]];
    
    m.nome = _txtNome.text;
    m.categoria = _txtCategoria.text;
    m.url = urlPlay.path;
    m.idUsuario = [NSNumber numberWithInt:[[[LocalStore sharedStore] usuarioAtual].identificador intValue]];
    [[[LocalStore sharedStore] context] save:nil];
}

-(BOOL)musicaComEsseNomeJaExisteNessaCategoria{
    for (Musica* m in _musicas) {
        if ([m.categoria isEqualToString:_txtCategoria.text] && [m.nome isEqualToString:_txtNome.text]) {
            return YES;
        }
    }
    return NO;
}

//Vamos gravar um som galera!
- (IBAction)gravar:(id)sender {
    
    UIAlertView *alertGravacao = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    if([_txtCategoria.text length] > 0 && [_txtNome.text length] > 0){
        if(![self musicaComEsseNomeJaExisteNessaCategoria]){
            if(_gravando){
                //Para gravação
                [recorder stop];
                
                //Altera botao da gravação
                [_btnGravar setTitle:@"Gravar" forState:UIControlStateNormal];
                _gravando = false;
            }
            else{
                //Preparava gravador
                [self carregaGravador];
                [recorder prepareToRecord];
                
                //Alterar botao da gravação
                [_btnGravar setTitle:@"Gravando" forState:UIControlStateNormal];
                _gravando = true;
                
                //Salva no CoreData a gravacao
                [self registrarGravacao];
                
                //Inicia gravação
                [recorder record];
            }
        }
        else{
            [alertGravacao setMessage:@"Música com esse nome jé existe nessa categoria. Digite outro nome."];
            [alertGravacao show];
        }
    }
    else{
        [alertGravacao setMessage:@"Campos em branco. Preencha corretamente."];
        [alertGravacao show];
    }
}

//PLay Audio da gravação
- (IBAction)playGravacao:(id)sender {
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    [player play];
}

//Delegate RETURN - UITextField Nome da categoria
- (IBAction)txtCategoriaSair:(id)sender {
    [sender resignFirstResponder];
}

//Delegate RETURN - UITextField Nome da musica
- (IBAction)txtNomeSair:(id)sender {
    [sender resignFirstResponder];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    UIViewController* vc;
    
    switch (item.tag) {
        case 1:
            vc = [[LocalStore sharedStore] TelaGravacao];
            break;
            
        case 2:
            vc = [[LocalStore sharedStore] TelaBusca];
            break;
            
        case 3:
            vc = [[LocalStore sharedStore] TelaPerfil];
            break;
    }
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:vc]) {
        [[self navigationController] popToViewController:vc animated:NO];
    }
    else{
        [[self navigationController] pushViewController:vc animated:NO];
    }
}

@end
