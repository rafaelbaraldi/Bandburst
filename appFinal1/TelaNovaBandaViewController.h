//
//  TelaNovaBandaViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaNovaBandaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtNomeDaBanda;
@property (weak, nonatomic) IBOutlet UIButton *btnCriarBanda;

- (IBAction)btnMaisMembroClick:(id)sender;
- (IBAction)btnCriarBandaClick:(id)sender;
- (IBAction)txtNomeDaBandaDone:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tbMembros;

@end
