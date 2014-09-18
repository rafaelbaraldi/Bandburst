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

@interface CoreAudioViewController : UIViewController <UITabBarDelegate> {
    
    AVAudioRecorder *recorder;
    NSURL *urlPlay;
    AVAudioPlayer *player;
}

@property BOOL gravando;
@property NSMutableArray* musicas;

@property (weak, nonatomic) IBOutlet UITextField *txtNome;
@property (weak, nonatomic) IBOutlet UITextField *txtCategoria;
@property (weak, nonatomic) IBOutlet UIButton *btnGravar;
@property (strong, nonatomic) IBOutlet UIButton *btnTocar;
@property (strong, nonatomic) IBOutlet UITabBarItem *gravarItem;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)gravar:(id)sender;
- (IBAction)playGravacao:(id)sender;
- (IBAction)txtCategoriaSair:(id)sender;
- (IBAction)txtNomeSair:(id)sender;

@end
