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
    
    NSString *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]).mensagem;
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mensagemCell"];
    }
    else {
        UILabel *texto = (UILabel *)[cell viewWithTag:1];
        UIImageView *bubble = (UIImageView *)[cell viewWithTag:2];
        if ([texto superview]) {
            [texto removeFromSuperview];
        }
        
        if ([bubble superview]) {
            [bubble removeFromSuperview];
        }
    }
    
    //Texto
    UILabel *returnView =  [self viewText:msg];
    returnView.backgroundColor = [UIColor clearColor];
    returnView.tag = 1;
    
    //Balao
    UIImage *bubble;
    BOOL msgSelf = NO;
    if([((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]).idUsuario isEqualToString:[[LocalStore sharedStore] usuarioAtual].identificador]){
        bubble = [UIImage imageNamed:@"mensagem_self.png"];
        msgSelf = YES;
    }
    else{
        bubble = [UIImage imageNamed:@"mensagem.png"];
    }
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    bubbleImageView.backgroundColor = [UIColor whiteColor];
    bubbleImageView.tag = 2;
    
    if(msgSelf){
        returnView.frame = CGRectMake(287 - returnView.frame.size.width, 12, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(275 - returnView.frame.size.width, 0, returnView.frame.size.width + 24, returnView.frame.size.height + 24);
    }
    else{
        returnView.frame = CGRectMake(32, 12, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(20, 0, returnView.frame.size.width + 24, returnView.frame.size.height + 24);
    }
    
    [cell addSubview:bubbleImageView];
    [cell addSubview:returnView];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]).mensagem;
    UIView *returnView =  [self viewText:msg];
    
    return returnView.frame.size.height + 15 + 24;
}

-(UILabel*)viewText:(NSString*)text{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:12]}];

    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];

    label.frame = CGRectMake(0, 0, ceil(rect.size.width), ceil(rect.size.height));
    
    return label;
}



@end
