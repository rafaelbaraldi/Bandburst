//
//  TelaGravacoesViewController.h
//  Bandburst
//
//  Created by RAFAEL BARALDI on 30/09/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaGravacoesViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray* categorias;
@property NSMutableArray* musicas;
@property NSMutableArray* musicasPorCategoria;

@property (strong, nonatomic) IBOutlet UIButton *btnNovaGravacao;
@property (strong, nonatomic) IBOutlet UILabel *lblGaleria;
@property (strong, nonatomic) IBOutlet UITableView *tbMusicas;

@end
