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
        [[self navigationItem] setTitle:@"Gravação"];
        
        _player.delegate = self;
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
}

-(void)viewWillDisappear:(BOOL)animated{
    
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

-(void)carregaMusica{
    
    _lblNomeGravacao.text = ((Musica*)[[GravacaoStore sharedStore] gravacao]).nome;
    _lblCategoriaGravacao.text = ((Musica*)[[GravacaoStore sharedStore] gravacao]).categoria;
}

- (IBAction)btnPlayGravacaoClick:(id)sender {
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:((Musica*)[[GravacaoStore sharedStore] gravacao]).url];
    
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.volume = 0.5;
    [_player play];
    
    //Carrega Tempo
    _timerProgresso = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(atualizaProgresso) userInfo:nil repeats:YES];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //Fecha Nstimer do update
    [_timerProgresso invalidate];
}

-(void)atualizaProgresso{

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

- (IBAction)volumeGravacaoClick:(id)sender {
    
    _player.volume = ((UISlider*)sender).value * 10;
}

- (IBAction)progressoGravacaoClick:(id)sender {
    
    [_player pause];
    
    [_player setCurrentTime:_player.duration * ((UISlider*)sender).value];
    
    [_player play];
}
@end
