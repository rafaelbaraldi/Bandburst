//
//  TelaHorariosViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 16/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaHorariosViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UILabel *lblHorarios;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHorario;

@property NSArray *horarios;
- (IBAction)exibeLog:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblSegunda;
@property (weak, nonatomic) IBOutlet UILabel *lblTerca;
@property (weak, nonatomic) IBOutlet UILabel *lblQuarta;
@property (weak, nonatomic) IBOutlet UILabel *lblQuinta;
@property (weak, nonatomic) IBOutlet UILabel *lblSexta;
@property (weak, nonatomic) IBOutlet UILabel *lblSabado;
@property (weak, nonatomic) IBOutlet UILabel *lblDomingo;

@end
