//
//  TelaPlayerViewController.m
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaPlayerViewController.h"

#import "LocalStore.h"
#import "GravacaoStore.h"

@interface TelaPlayerViewController ()

@end

@implementation TelaPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Navigation Controller
        [[self navigationItem] setTitle:@"Gravação"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //Carrega Layout
    [self carregaLayout];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega musica
    [self carregaMusica];
    [self btnPlayGravacaoClick:nil];
    
    //Zera os LBL tempos
    _lblTempoCorrente.text = @"00:00:00";
    _lblTempoTotal.text = @"00:00:00";
    
    _progressoGravacao.value = 0;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //Stop
    [_player stop];
}

-(void)carregaLayout{
    
    _lblNomeGravacao.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:18.0];
    _lblCategoriaGravacao.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:14.0];
    _lblTempoTotal.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:10.0];
    _lblTempoCorrente.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:10.0];
    
    //Slider Progresso da Gravação
    [_progressoGravacao setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
}

-(NSString*)carregaNomeMusica:(NSString*)url{
    
    NSString* nomeMusica =  url;
    
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    nomeMusica = [nomeMusica substringFromIndex:[nomeMusica rangeOfString:@"/"].location + 1];
    
    nomeMusica = [nomeMusica substringToIndex:nomeMusica.length-4];
    
    return nomeMusica;
}

-(void)carregaMusica{
    
    //Carrega o Player
    if (![[GravacaoStore sharedStore] streaming]) {
        
        _lblNomeGravacao.text = ((Musica*)[[GravacaoStore sharedStore] gravacao]).nome;
        _lblCategoriaGravacao.text = ((Musica*)[[GravacaoStore sharedStore] gravacao]).categoria;
        
        NSURL* url = [[NSURL alloc] initFileURLWithPath:((Musica*)[[GravacaoStore sharedStore] gravacao]).url];
        
//        NSLog(@"%@", url);
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }
    else{
        
        _lblNomeGravacao.text = [self carregaNomeMusica:((TPMusica*)[[GravacaoStore sharedStore] gravacaoStreaming]).url];
        _lblCategoriaGravacao.text = @"";
        
        NSString *urlStreaming = [[[GravacaoStore sharedStore] gravacaoStreaming].url stringByReplacingOccurrencesOfString:@" " withString:[NSString stringWithFormat:@"%%20"]];
        
        NSURL *url = [[NSURL alloc] initWithString:urlStreaming];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _player = [[AVAudioPlayer alloc]initWithData:data error:nil];
    }
    
    _player.volume = 2.9;
    _player.delegate = self;
}

- (IBAction)btnPlayGravacaoClick:(id)sender {
    
    if (! [_player isPlaying]) {
        
        //Coloca imagem de Pause
        [_btnPlayGravacao setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        //Inicica Player
        [_player prepareToPlay];
        [_player play];
        
        //Carrega Tempo
        _timerProgresso = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(atualizaProgresso) userInfo:nil repeats:YES];
    }
    else{
        
        //Para audio
        [_player pause];
        
        //Coloca imagem de Pause
        [_btnPlayGravacao setBackgroundImage:[UIImage imageNamed:@"playing.png"] forState:UIControlStateNormal];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //Stop
    [_player stop];
    
    //Fecha Nstimer do update
    [_timerProgresso invalidate];
    
    //Coloca imagem de Play
    [_btnPlayGravacao setBackgroundImage:[UIImage imageNamed:@"playing.png"] forState:UIControlStateNormal];
    
    //Zera Progresso
    _progressoGravacao.value = 0;
    
    //Zera os LBL tempos
    _lblTempoCorrente.text = @"00:00:00";
    
    //Tempo total
    int duration = _player.duration;
    int minuto = duration/60;
    int segundo = ((int)duration)%60;
    int decimodesegundo = (int)((duration - segundo - minuto*60)*100);
    [_lblTempoTotal setText:[NSString stringWithFormat:@"-%02d:%02d:%02d", minuto, segundo, decimodesegundo]];
}

-(void)atualizaProgresso{

    if([_player isPlaying]){
        Float64 currentTime = _player.currentTime;
        Float64 duration = _player.duration;
        Float64 progress = currentTime / duration;

        //Progress
        _progressoGravacao.value = progress;

        //Tempo Corrente
        int minuto = currentTime/60;
        int segundo = ((int) currentTime)%60;
        int decimodesegundo = (int)((currentTime - segundo - minuto*60)*100);
        [_lblTempoCorrente setText:[NSString stringWithFormat:@"%02d:%02d:%02d", minuto, segundo, decimodesegundo]];

        //Tempo total
        minuto = (duration-currentTime)/60;
        segundo = ((int) (duration-currentTime))%60;
        decimodesegundo = (int)(((duration-currentTime) - segundo - minuto*60)*100);
        [_lblTempoTotal setText:[NSString stringWithFormat:@"-%02d:%02d:%02d", minuto, segundo, decimodesegundo]];
    }
}

- (IBAction)volumeGravacaoClick:(id)sender {
    
    _player.volume = ((UISlider*)sender).value * 5;
}

- (IBAction)progressoGravacaoClick:(id)sender {
    
    [_player pause];
    [_player setCurrentTime:_player.duration * ((UISlider*)sender).value];
    [_player play];
}
@end
