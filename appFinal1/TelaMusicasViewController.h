//
//  TelaMusicasViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 08/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaMusicasViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSMutableArray *musicas;
@property NSMutableArray *categorias;
@property NSMutableArray *musicasPorCategoria;

@property NSIndexPath* indexMusica;

@end
