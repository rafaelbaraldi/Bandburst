//
//  TelaHorariosViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 16/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaHorariosViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionHorario;

@property NSArray *horarios;

@end
