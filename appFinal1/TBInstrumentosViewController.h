//
//  TBInstrumentosViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBInstrumentosViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbInstrumentos;
@property (weak, nonatomic) IBOutlet UISearchBar *searchInstrumento;

@end
