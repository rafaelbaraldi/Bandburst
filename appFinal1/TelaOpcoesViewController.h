//
//  TelaOpcoesViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 01/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TelaOpcoesViewController : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAlterarFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnEncontrarAmigos;
@property (weak, nonatomic) IBOutlet UIButton *btnSair;

- (IBAction)btnAlterarFoto:(id)sender;
- (IBAction)btnEcontrarAmigos:(id)sender;
- (IBAction)btnSair:(id)sender;

@property FBProfilePictureView* fbpv;

@end
