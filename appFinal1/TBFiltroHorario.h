//
//  TBFiltroHorario.h
//  appFinal1
//
//  Created by Rafael Cardoso on 24/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBFiltroHorario : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray *horarios;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHorario;

@end
