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

#import "GravacaoStore.h"

@interface CoreAudioViewController ()
@end

@implementation CoreAudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gravando = false;
        
        //Navigation Controller
        [[self navigationItem] setTitle:@"Gravar"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
//    [_audioPlot clear];
}

-(void)viewWillDisappear:(BOOL)animated{
    _tempo.text = @"00:00:00";
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)linhaGravacaEZAudio{
//    self.microphone = [EZMicrophone microphoneWithDelegate:self];
//    self.audioPlot.backgroundColor = [UIColor blackColor];
//    self.audioPlot.color           = [[LocalStore sharedStore] FONTECOR];
//    self.audioPlot.plotType        = EZPlotTypeRolling;
//    self.audioPlot.shouldFill      = YES;
//    self.audioPlot.shouldMirror    = YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];    
    
    [self linhaGravacaEZAudio];
    
    [self arredondaBordaBotoes];
    
    //Carrega todas as músicas do CoreData
    _musicas = [[NSMutableArray alloc]initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Musica"] error:nil]];

}

-(void)arredondaBordaBotoes{
    
    [[_btnGravar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    _tempo.backgroundColor = [[LocalStore sharedStore] FONTECOR];
    
    //Core da seta
    _tabBarSeta.backgroundColor = [[LocalStore sharedStore] FONTECOR];
}

-(void)carregaGravador:(NSString*)nome categoria:(NSString*)categoria{
    
    //Set configuração da Gravação
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //URL da música a gravar
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%@.%@", 0, categoria, nome]]];
    
    urlPlay = url;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

//Registar gravação no CoreData
-(void)registrarGravacao:(NSString*)nome categoria:(NSString*)categoria{
    
    _novaGravacao = [NSEntityDescription insertNewObjectForEntityForName:@"Musica" inManagedObjectContext:[[LocalStore sharedStore] context]];
    
    _novaGravacao.nome = nome;
    _novaGravacao.categoria = categoria;
    _novaGravacao.url = urlPlay.path;
    _novaGravacao.idUsuario = [NSNumber numberWithInt:[[[LocalStore sharedStore] usuarioAtual].identificador intValue]];
    [[[LocalStore sharedStore] context] save:nil];
}

-(BOOL)musicaComEsseNomeJaExisteNessaCategoria:(NSString*)nome categoria:(NSString*)categoria{
    //Carrega todas as músicas do CoreData
    _musicas = [[NSMutableArray alloc]initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Musica"] error:nil]];
    for (Musica* m in _musicas) {
        if ([m.categoria isEqualToString:categoria] && [m.nome isEqualToString:nome] && m.idUsuario.intValue == [[[LocalStore sharedStore] usuarioAtual].identificador intValue]) {
            return YES;
        }
    }
    return NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag ==1){
        if(buttonIndex == 1){
        
            NSString *txtCategoria = [alertView textFieldAtIndex:1].text;
            NSString *txtNome = [alertView textFieldAtIndex:0].text;
            
            UIAlertView *alertGravacao = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            if([txtCategoria length] > 0 && [txtNome length] > 0){
                if(![self musicaComEsseNomeJaExisteNessaCategoria:txtNome categoria:txtCategoria]){
                    
//                    [_audioPlot clear];
                    
                    //Preparava gravador
                    [self carregaGravador:txtNome categoria:txtCategoria];
                    [recorder prepareToRecord];
                    
                    //Alterar botao da gravação
                    [_btnGravar setTitle:@"Gravando" forState:UIControlStateNormal];
                    [_btnGravar setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
                    _gravando = true;
                    
                    //Salva no CoreData a gravacao
                    [self registrarGravacao:txtNome categoria:txtCategoria];
                    
                    //Inicia gravação
                    [recorder record];
                    
                    //Nao deixa o usuario sair da view
                    [self.navigationItem setHidesBackButton:YES animated:YES];
                    self.tabBarController.tabBar.hidden = YES;
                    
                    //Começa a contar o tempo
                    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(atualizaTimer) userInfo:nil repeats:YES];
                    
//                    [_microphone startFetchingAudio];
                    
                    //Time
                    _tempoGravacao = [NSDate dateWithTimeIntervalSinceNow:0];
                    _tempoInicial = [NSDate dateWithTimeIntervalSinceNow:0];
                }
                else{
                    [alertGravacao setMessage:@"Música com esse nome já existe nessa categoria. Digite outro nome."];
                    [alertGravacao show];
                }
            }
            else{
                [alertGravacao setMessage:@"Campos em branco. Preencha corretamente."];
                [alertGravacao show];
            }
        }
    }
    else if(alertView.tag == 2){
        if(buttonIndex == 1){
            
            //Set gravação para Tocar
            [[GravacaoStore sharedStore] setGravacao:_novaGravacao];
            [[GravacaoStore sharedStore] setStreaming:NO];
            
            if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaPlayer]]) {
                [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
            }
            else{
                [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaPlayer] animated:NO];
            }
        }
        else{
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

//Vamos gravar um som galera!
- (IBAction)gravar:(id)sender {
    if(_gravando){
        //Para gravação
        [recorder stop];
        
        //Altera botao da gravação
        [_btnGravar setTitle:@"Gravar" forState:UIControlStateNormal];
        [_btnGravar setImage:[UIImage imageNamed:@"gravar.png"] forState:UIControlStateNormal];
        _gravando = false;
        
//        [_microphone stopFetchingAudio];
        
        [_timer invalidate];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Gravação" message:@"Som gravado com sucesso" delegate:self cancelButtonTitle:@"Voltar" otherButtonTitles:@"Tocar Gravação", nil];
        [av setTag:2];
        [av show];
        
        //Nao deixa o usuario sair da view
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.tabBarController.tabBar.hidden = NO;
    }
    else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Gravação" message:@"Preencha os campos abaixo" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        // Alert style customization
        [[av textFieldAtIndex:1] setSecureTextEntry:NO];
        [[av textFieldAtIndex:0] setPlaceholder:@"Nome"];
        [[av textFieldAtIndex:1] setPlaceholder:@"Categoria"];
        [av setTag:1];
        [av show];
    }
}

-(void)atualizaTimer{
    _tempoGravacao = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval tempoAtual = [_tempoGravacao timeIntervalSinceDate:_tempoInicial];
    
    int minuto = tempoAtual/60;
    int segundo = ((int) tempoAtual)%60;
    int decimodesegundo = (int)((tempoAtual - segundo - minuto*60)*100);
    
    
    [_tempo setText:[NSString stringWithFormat:@"%02d:%02d:%02d", minuto, segundo, decimodesegundo]];
}

//PLay Audio da gravação
- (IBAction)playGravacao:(id)sender {
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    [player play];
}

//-(void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
//    dispatch_async(dispatch_get_main_queue(),^{
//        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
//    });
//}

@end
