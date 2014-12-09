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
    
    TPMensagem *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]);
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mensagemCell"];
    }
    else {
        UIView *texto = (UIView *)[cell viewWithTag:1];
        UIImageView *bubble = (UIImageView *)[cell viewWithTag:2];
        if ([texto superview]) {
            [texto removeFromSuperview];
        }
        
        if ([bubble superview]) {
            [bubble removeFromSuperview];
        }
    }
    
    //Texto
    UIView *returnView = [self viewText:msg];
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
    
    TPMensagem *msg = ((TPMensagem*)[_banda.mensagens objectAtIndex:indexPath.row]);
    UIView *returnView =  [self viewText:msg];
    
    return returnView.frame.size.height + 15 + 24;
}

-(UIView*)viewText:(TPMensagem*)msg{
    
    //Texto
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = msg.mensagem;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:13];
    
    //Tamanho do texto
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:msg.mensagem attributes:@{NSFontAttributeName: [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:13]}];

    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];

    label.frame = CGRectMake(0, 2, ceil(rect.size.width), ceil(rect.size.height));
    
    
    //Tamanho do nome
    NSAttributedString *attributedNome = [[NSAttributedString alloc] initWithString:msg.nomeUsuario attributes:@{NSFontAttributeName: [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:13]}];
    
    CGRect rectNome = [attributedNome boundingRectWithSize:(CGSize){250, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    
    //Nome de qm enviou a mensagem
    UILabel *nome = [[UILabel alloc] initWithFrame:CGRectZero];
    nome.text = msg.nomeUsuario;
    nome.textColor = [[LocalStore sharedStore] FONTECOR];
    nome.font = [UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:13];
    nome.frame = CGRectMake(0, 2, ceil(rectNome.size.width), ceil(rectNome.size.height));
    
    CGRect rectView;
    //View com texto e nome
    if (rect.size.width > rectNome.size.width)
        rectView = rect;
    else
        rectView = rectNome;
        
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ceil(rect.size.width), ceil(rect.size.height))];
    
    [view addSubview:label];
    
    if(![msg.idUsuario isEqualToString:[[LocalStore sharedStore] usuarioAtual].identificador]){
        [view addSubview:nome];
        view.frame = CGRectMake(0, 0, ceil(rectView.size.width), ceil(rect.size.height) + 22);
        label.frame = CGRectMake(0, 22, ceil(rect.size.width), ceil(rect.size.height));
    }
    
    return view;
}



@end
