//
//  TelaPerfilViewController.h
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface TelaPerfilViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>{
    AVAudioPlayer* player;
}

@property NSMutableArray* categorias;
@property NSMutableArray* musicas;
@property NSMutableArray* musicasPorCategoria;

@property NSMutableArray* bandas;

- (IBAction)btnPerfilEditarClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imagePerfil;
@property (strong, nonatomic) IBOutlet UILabel *lblPerfilAtribuicoes;

@property (weak, nonatomic) IBOutlet UILabel *lblPerfilNome;
@property (weak, nonatomic) IBOutlet UILabel *lblPerfilCidade;
@property (weak, nonatomic) IBOutlet UILabel *lblPerfilBairro;
@property (weak, nonatomic) IBOutlet UIButton *btnPerfilEditar;
@property (strong, nonatomic) IBOutlet UIButton *btnCriarBanda;


@property (weak, nonatomic) IBOutlet UILabel *lblPerfilAmigos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;

@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UITabBarItem *perfilItem;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBanda;

- (IBAction)btnCriarBandaClick:(id)sender;

@end
