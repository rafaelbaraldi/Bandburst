//
//  TelaCadastroFotoViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 17/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaCadastroFotoViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnAdicionarFoto;
@property (weak, nonatomic) IBOutlet UIButton *btnContinuar;

@property UIActionSheet *menu;
@property UIImageView *fotoSelecionada;
@property UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)btnAdicionarFotoClick:(id)sender;
- (IBAction)btnContinuarClick:(id)sender;

@end
