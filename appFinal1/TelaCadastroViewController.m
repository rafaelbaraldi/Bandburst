//
//  TelaCadastroViewController.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 15/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaCadastroViewController.h"

#import "LocalStore.h"
#import "CadastroStore.h"
#import "LoginStore.h"
#import "LocalStore.h"
#import "Usuario.h"
#import "TPInstrumento.h"
#import "TPHorario.h"
#import "TBEstilosQueTocaViewController.h"

const int OBSERVACOES = 2;

@interface TelaCadastroViewController ()

@end

@implementation TelaCadastroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Cadastro"];
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (_ehEdicao) {
        [self corregaCamposEdicao];
    }
    
    [[[self navigationController] navigationBar] setTintColor:[[LocalStore sharedStore] FONTECOR]];
    
    //Usa Cadastro no singleton
    [[CadastroStore sharedStore]setViewTela:self];
    
    //Deixa a borda dos boteos arredondados
    [self arredondaBordaBotoes];
    
    //Senha
    [_txtSenha setSecureTextEntry:YES];
}

-(void)corregaCamposEdicao{
    
    TPUsuario* user = [[LocalStore sharedStore] usuarioAtual];
    
    NSMutableArray* instumentosQueToca = [[NSMutableArray alloc] init];
    for (TPInstrumento* i in user.instrumentos) {
        NSString* instumento = i.nome;
        if (i.possui) {
            instumento = [NSString stringWithFormat:@"%@1", i.nome];
        }
        [instumentosQueToca addObject:instumento];
    }
    
    NSMutableArray* horariosQueToca = [[NSMutableArray alloc] init];
    for (TPHorario* h in user.horarios) {
        [horariosQueToca addObject:[NSString stringWithFormat:@"%@%@", h.dia, h.periodo]];
    }
    
    
    [[CadastroStore sharedStore] setInstrumentosQueToca:instumentosQueToca];
    [[CadastroStore sharedStore] setEstilosQueToca:user.estilos];
    [[CadastroStore sharedStore] setHorariosQueToca:horariosQueToca];
    
    _txtNome.text = user.nome;
    _txtEmail.text = user.email;
//    _txtSenha.text = user.senha;
    _txtCidade.text = user.cidade;
    _txtBairro.text = user.bairro;
    _txtObservacoes.text = user.atribuicoes;
    
    if ([user.sexo isEqualToString:@"Masculino"]) {
        [_segGenero setSelectedSegmentIndex:0];
    }
    else{
        [_segGenero setSelectedSegmentIndex:1];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[[[self navigationController] navigationBar] topItem] setTitle:@""];
    
    [self carregaLabels];
}

-(void)arredondaBordaBotoes{
    
    [[_btnEstilos layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnInstrumentos layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnHorarios layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_btnConfirmar layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_segGenero layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtNome layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtEmail layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtSenha layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtCidade layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtBairro layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    [[_txtObservacoes layer] setCornerRadius:[[LocalStore sharedStore] RAIOBORDA]];
    
    [_txtNome setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_txtEmail setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_txtSenha setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_txtCidade setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_txtBairro setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnInstrumentos titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnEstilos titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnHorarios titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_txtObservacoes setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [[_btnConfirmar titleLabel] setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    [_lblCabecalho setFont:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16]];
    
    NSDictionary* atributos = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:[[LocalStore sharedStore] FONTEFAMILIA] size:16], NSFontAttributeName, nil];
    [_segGenero setTitleTextAttributes:atributos forState:UIControlStateNormal];
    
    [[_txtNome layer]setBorderWidth:2.0f];
    [[_txtEmail layer]setBorderWidth:2.0f];
    [[_txtSenha layer]setBorderWidth:2.0f];
    [[_txtCidade layer]setBorderWidth:2.0f];
    [[_txtBairro layer]setBorderWidth:2.0f];
    [[_txtObservacoes layer]setBorderWidth:2.0f];
    
    [[_txtNome layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [[_txtEmail layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [[_txtSenha layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [[_txtCidade layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [[_txtBairro layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
    [[_txtObservacoes layer] setBorderColor:[[LocalStore sharedStore] FONTECOR].CGColor];
}

-(IBAction)btnEstilosClik:(id)sender {
    
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaTBEstilosQueToco] animated:YES];
}

-(IBAction)btnInstrumentosClick:(id)sender {
    
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaTBInstruementosQueToco] animated:YES];
}

-(void)habilitarTodasViewsTela:(BOOL)condicao{
    for (UIControl* v in self.view.subviews) {
        v.enabled = condicao;
    }
         
    for (UILabel* v in self.view.subviews) {
        v.enabled = condicao;
    }
}

-(IBAction)btnConfirmarClick:(id)sender {
    
    Usuario *usuario = [NSEntityDescription insertNewObjectForEntityForName:@"Usuario" inManagedObjectContext:[[LocalStore sharedStore] context]];
    
    usuario.nome = _txtNome.text;
    usuario.email = _txtEmail.text;
    usuario.senha = _txtSenha.text;
    usuario.sexo = [_segGenero titleForSegmentAtIndex:[_segGenero selectedSegmentIndex]];
    usuario.cidade = _txtCidade.text;
    usuario.bairro = _txtBairro.text;
    usuario.observacoes = _txtObservacoes.text;
    usuario.horarios = @"";
    usuario.instrumentos = @"";
    usuario.estilos = @"";
    
    for (NSString* s in [[CadastroStore sharedStore] instrumentosQueToca]) {
        usuario.instrumentos = [NSString stringWithFormat:@"%@, %@", usuario.instrumentos, s];
    }
    for (NSString* s in [[CadastroStore sharedStore] estilosQueToca]) {
        usuario.estilos = [NSString stringWithFormat:@"%@, %@", usuario.estilos, s];
    }
    for (NSString* s in [[CadastroStore sharedStore] horariosQueToca]) {
        usuario.horarios = [NSString stringWithFormat:@"%@, %@", usuario.horarios, s];
    }
    
    if([usuario.instrumentos length] > 0){
        usuario.instrumentos = [usuario.instrumentos substringFromIndex:2];
    }
    if([usuario.estilos length] > 0){
        usuario.estilos = [usuario.estilos substringFromIndex:2];
    }
    if([usuario.horarios length] > 0){
        usuario.horarios = [usuario.horarios substringFromIndex:2];
    }
    
    //Finalizamos um cadastro
    [self finalizaCadastro:usuario];
}

-(void)finalizaCadastro:(Usuario*)usuario{
    
    NSString *valida = [CadastroStore validaCadastro:usuario];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if([valida length] > 0){
        valida = [NSString stringWithFormat:@"Informe corretamente %@", valida];
        
        [alert setMessage:valida];
        [alert show];
    }
    else{
        NSString *cadastrou;
        if(_ehEdicao){
            cadastrou = [CadastroStore atualizar:usuario];
        }
        else{
            cadastrou = [CadastroStore cadastrar:usuario];
        }
        
        if([cadastrou rangeOfString:@"\"Duplicate entry"].location != NSNotFound){
            valida = [NSString stringWithFormat:@"Esse e-mail já está em uso"];
            
            [alert setMessage:valida];
            [alert show];
        }
        else{
            //Limpa tela após cadastras
            [self limpaTela];
            
            if(_ehEdicao){
                [LoginStore deslogar];
                
                //Realiza Login
                [LoginStore login:usuario.email senha:usuario.senha];
                
                [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaPerfil] animated:YES];
            }
            else{
                //Realiza Login
                [LoginStore login:usuario.email senha:usuario.senha];
                
                [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaCadastroFoto] animated:YES];
            }
        }
    }
}

-(void)limpaTela{
    _txtNome.text = @"";
    _txtEmail.text = @"";
    _txtSenha.text = @"";
    _txtCidade.text = @"";
    _txtBairro.text = @"";
    _txtObservacoes.text = @"";
    
    [[[CadastroStore sharedStore] instrumentosQueToca] removeAllObjects];
    [[[CadastroStore sharedStore] estilosQueToca] removeAllObjects];
    [[[CadastroStore sharedStore] horariosQueToca] removeAllObjects];
}

- (IBAction)btnHorariosClick:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaHorarios] animated:YES];
}

//Valida e-mail
- (IBAction)txtEmailDidEnd:(id)sender {
    
    if ([[CadastroStore validaEmail:_txtEmail.text] length] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERRO" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.message = @"O domínio desse e-mail é inválido. Por favor digite novamente";
        [alert show];
    }
}

//Regular Tela para digitar as opções de Observacoes
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag == OBSERVACOES){
        [self escondeTecladoObservacoes];
    }
    
    [textField resignFirstResponder];
    return YES;
}

//Regular Tela para digitar as opções de Observacoes
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == OBSERVACOES){
        [self exibiTecladoObservacoes];
    }
    return YES;
}

-(void)sobeViews:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    
    CGRect rect = self.view.frame;
    if (movedUp){
        rect.origin.y -= 200;
        rect.size.height += 200;
    }
    else{
        rect.origin.y += 200;
        rect.size.height -= 200;
    }
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)exibiTecladoObservacoes{
    if (self.view.frame.origin.y >= 0){
        [self sobeViews:YES];
    }
}

-(void)escondeTecladoObservacoes{
    if (self.view.frame.origin.y >= 0){
        [self sobeViews:YES];
    }
    else if (self.view.frame.origin.y < 0){
        [self sobeViews:NO];
    }
}

-(void)carregaLabels{
    
    NSArray *auxInstrumentos = [[CadastroStore sharedStore] instrumentosQueToca];
    
    switch ([auxInstrumentos count]) {
        case 0:
            _lblInstrumentos.text = @"";
            break;

        case 1:
            _lblInstrumentos.text = [auxInstrumentos objectAtIndex:0];
            _lblInstrumentos.text = [_lblInstrumentos.text stringByReplacingOccurrencesOfString:@"1" withString:@""];
            break;
            
        case 2:
            _lblInstrumentos.text = [NSString stringWithFormat:@"%@, %@", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1]];
            _lblInstrumentos.text = [_lblInstrumentos.text stringByReplacingOccurrencesOfString:@"1" withString:@""];
            break;

        case 3:
            _lblInstrumentos.text = [NSString stringWithFormat:@"%@, %@, %@", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1], [auxInstrumentos objectAtIndex:2]];
            _lblInstrumentos.text = [_lblInstrumentos.text stringByReplacingOccurrencesOfString:@"1" withString:@""];
            break;
            
        default:
            _lblInstrumentos.text = [NSString stringWithFormat:@"%@, %@, %@...", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1], [auxInstrumentos objectAtIndex:2]];
            _lblInstrumentos.text = [_lblInstrumentos.text stringByReplacingOccurrencesOfString:@"1" withString:@""];
            break;
    }
    
    auxInstrumentos = [[CadastroStore sharedStore] estilosQueToca];
    
    switch ([auxInstrumentos count]) {
        case 0:
            _lblEstilos.text = @"";
            break;
            
        case 1:
            _lblEstilos.text = [auxInstrumentos objectAtIndex:0];
            break;
            
        case 2:
            _lblEstilos.text = [NSString stringWithFormat:@"%@, %@", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1]];
            break;
            
        case 3:
            _lblEstilos.text = [NSString stringWithFormat:@"%@, %@, %@", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1], [auxInstrumentos objectAtIndex:2]];
            break;
            
        default:
            _lblEstilos.text = [NSString stringWithFormat:@"%@, %@, %@...", [auxInstrumentos objectAtIndex:0], [auxInstrumentos objectAtIndex:1], [auxInstrumentos objectAtIndex:2]];
            break;
    }
}
@end
