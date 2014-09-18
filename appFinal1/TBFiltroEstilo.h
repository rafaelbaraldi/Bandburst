//
//  TBFiltroEstilo.h
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBFiltroEstilo : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSMutableArray* todosEstilos;
@property (weak, nonatomic) IBOutlet UISearchBar *searchEstilos;
@property (weak, nonatomic) IBOutlet UITableView *tbEstilos;

@end
