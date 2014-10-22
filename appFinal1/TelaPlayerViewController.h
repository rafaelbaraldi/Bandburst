//
//  TelaPlayerViewController.h
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface TelaPlayerViewController : UIViewController <AVAudioPlayerDelegate>

@property AVAudioPlayer *player;

@property NSTimer *timerProgresso;

@property (strong, nonatomic) IBOutlet UILabel *lblTempoCorrente;
@property (strong, nonatomic) IBOutlet UILabel *lblTempoTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblNomeGravacao;
@property (strong, nonatomic) IBOutlet UILabel *lblCategoriaGravacao;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayGravacao;
@property (strong, nonatomic) IBOutlet UISlider *volumeGravacao;
@property (strong, nonatomic) IBOutlet UISlider *progressoGravacao;

- (IBAction)btnPlayGravacaoClick:(id)sender;
- (IBAction)volumeGravacaoClick:(id)sender;
- (IBAction)progressoGravacaoClick:(id)sender;


@end
