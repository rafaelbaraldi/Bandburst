//
//  TelaInfosBandaViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 07/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPBanda.h"
#import "LocalStore.h"
#import "BandaStore.h"
#import "TelaInfosBandaViewController.h"

@interface TelaInfosBandaViewController : UIViewController

@property TPBanda* banda;
@property AVAudioPlayer *player;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollMembros;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollMusicas;
@property TelaInfosBandaViewController* a;

- (IBAction)btnAdicionarMusicaClick:(id)sender;

@end
