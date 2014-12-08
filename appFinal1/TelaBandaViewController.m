//
//  TelaBandaViewController.m
//  appFinal1
//
//  Created by RAFAEL CARDOSO DA SILVA on 07/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaBandaViewController.h"

#import "BandaStore.h"
#import "LocalStore.h"
#import "TPMensagem.h"

#import "TelaInfosBandaViewController.h"

@interface TelaBandaViewController ()

@end

@implementation TelaBandaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    //Carrega banda Atual
    _banda = [BandaStore buscaBanda:[[BandaStore sharedStore] idBandaSelecionada]];
    
    //Recarrega as Mensagens da tela
    [_tbMensagens reloadData];
    
    //Navigation Controller
    [[self navigationItem] setTitle:_banda.nome];
    
//    [self carregaTituloNavigationBarCustom];
}

//-(void)carregaTituloNavigationBarCustom{
//    
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
//    [button setTitle:_banda.nome forState:UIControlStateNormal];
//    [button setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dadosBanda) forControlEvents:UIControlEventTouchUpInside];
//    [button sizeToFit];
//    
//    [[self navigationItem] setTitleView:button];
//}
//
//-(void)dadosBanda{
//    [[self navigationController] pushViewController:[[TelaInfosBandaViewController alloc] initWithNibName:@"TelaInfosBandaViewController" bundle:nil] animated:YES];
//}

//- (void) hideKeyboard {
//    [_txtMensagem resignFirstResponder];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_txtMensagem resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_banda.mensagens count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)txtMensagemSend:(id)sender {
    [sender resignFirstResponder];
    
    //Send msg
    [BandaStore enviaMensagem:[sender text] idBanda:_banda.identificador idUsuario:[[LocalStore sharedStore] usuarioAtual].identificador];
    
    [sender setText:@""];
    
    [self recarregaMensagens];
}

-(void)recarregaMensagens{
    [_banda setMensagens:[BandaStore buscaMensagensBanda:_banda.identificador]];
    
    [_tbMensagens reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mensagemCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mensagemCell"];
    }
    
    NSString *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]).mensagem;
    
//    cell.textLabel.text = msg;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:11];
    
    //Texto
    UIView *returnView =  [self viewText:msg];
//    returnView.backgroundColor = [UIColor clearColor];
//    returnView.frame = CGRectMake(0, 0, 300, 60);

    //Balao
//    UIImage *bubble = [UIImage imageNamed:@"mensagem"];
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    
//    returnView.frame= CGRectMake(9.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
//    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f );
    
//    [cell addSubview:bubbleImageView];
    [cell addSubview:returnView];
    
    return cell;
}

-(UIView*)viewText:(NSString*)text{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:11];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
         NSFontAttributeName: [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:11]
     }];

    CGRect rect = [attributedText boundingRectWithSize:(CGSize){320, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    CGSize size = rect.size;

    label.frame = CGRectMake(0, 0, size.width, size.height);
    
    label.layer.borderWidth = 2;
    label.layer.borderColor = [UIColor redColor].CGColor;
    
    return label;
}



@end
