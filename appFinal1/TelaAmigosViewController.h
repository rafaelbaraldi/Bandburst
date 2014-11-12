//
//  TelaAmigosViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaAmigosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIActionSheetDelegate>

@property NSMutableArray* amigos;
@property NSMutableArray* amigosFiltrados;

@property UIActionSheet *alerta;

@property NSString *idNovoAdministrador;

@property (strong, nonatomic) IBOutlet UITableView *tbAmigos;

@end
