//
//  TelaFavoritadosViewController.h
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 21/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaFavoritadosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSMutableArray* amigos;
@property NSMutableArray* amigosFiltrados;

@property (strong, nonatomic) IBOutlet UITableView *tbAmigos;

@end
