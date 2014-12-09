//
//  TelaBuscaViewController.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 20/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

//#import <MoPub/MoPub.h>
#import <UIKit/UIKit.h>

@interface TelaBuscaViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>


//@property (nonatomic) MPAdView *adView;

@property NSMutableArray *usuarios;

@property CGRect frameTbUsuarios;

@property (strong, nonatomic) IBOutlet UIView *viewFiltros;

- (IBAction)btnInstrumentoClick:(id)sender;
- (IBAction)btnEstiloClick:(id)sender;
- (IBAction)btnHorariosClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnInstumento;
@property (strong, nonatomic) IBOutlet UIButton *btnEstilo;
@property (strong, nonatomic) IBOutlet UIButton *btnHorarios;

@property (strong, nonatomic) IBOutlet UITextField *txtCidade;
@property (strong, nonatomic) IBOutlet UITableView *tbUsuarios;

@property (strong, nonatomic) IBOutlet UILabel *lblMsgBusca;

//@property (strong, nonatomic) IBOutlet UITabBarItem *usuarioItem;
//@property (strong, nonatomic) IBOutlet UITabBarItem *buscarItem;
//@property (strong, nonatomic) IBOutlet UITabBarItem *gravarItem;

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UIImageView *tabBarSeta;

@end
