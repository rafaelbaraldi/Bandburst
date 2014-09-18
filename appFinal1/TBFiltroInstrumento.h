//
//  TBFiltroInstrumento.h
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBFiltroInstrumento : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSMutableArray* todosInstrumentos;
@property (weak, nonatomic) IBOutlet UISearchBar *searchInstrumento;
@property (weak, nonatomic) IBOutlet UITableView *tbInstrumentos;

@end
