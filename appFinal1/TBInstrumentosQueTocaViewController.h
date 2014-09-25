//
//  TBInstrumentosQueTocaViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBInstrumentosQueTocaViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbInstrumentosQueToca;

@property (strong, nonatomic) IBOutlet UILabel *lblInstrumentos;
@property (strong, nonatomic) IBOutlet UILabel *lblToco;
@property (strong, nonatomic) IBOutlet UILabel *lblTenho;

@end
