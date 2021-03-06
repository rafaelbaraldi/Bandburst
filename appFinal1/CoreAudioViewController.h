//
//  CoreAudioViewController.h
//  AudioPlayer
//
//  Created by RAFAEL CARDOSO DA SILVA on 14/02/14.
//  Copyright (c) 2014 RAFAEL CARDOSO DA SILVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "EZAudio/EZAudioPlotGL.h"
//#import "EZAudio/EZMicrophone.h"
#import "POVoiceHUD.h"
#import "Musica.h"


//@interface CoreAudioViewController : UIViewController <UITabBarDelegate, EZMicrophoneDelegate, UIAlertViewDelegate> {
@interface CoreAudioViewController : UIViewController <UIAlertViewDelegate, POVoiceHUDDelegate> {
    
    AVAudioRecorder *recorder;
    NSURL *urlPlay;
    AVAudioPlayer *player;
}

@property (nonatomic, retain) POVoiceHUD *voiceHud;

@property BOOL gravando;
@property NSMutableArray* musicas;

@property Musica *novaGravacao;
@property (strong, nonatomic) IBOutlet UIImageView *tabBarSeta;

@property (strong, nonatomic) IBOutlet UILabel *tempo;
@property (weak, nonatomic) IBOutlet UIButton *btnGravar;

@property NSTimer *timer;

- (IBAction)gravar:(id)sender;
- (IBAction)playGravacao:(id)sender;

//@property (strong, nonatomic) IBOutlet EZAudioPlotGL *audioPlot;

//@property EZMicrophone* microphone;

@property NSDate *tempoGravacao;
@property NSDate *tempoInicial;

@end
