//
//  SharedStore.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 15/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "LocalStore.h"

#import "TelaCadastroViewController.h"
#import "TelaLoginViewController.h"

@implementation LocalStore

+(LocalStore*)sharedStore{
    static LocalStore* sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedStore];
}

-(id)init{
    self = [super init];
    if(self){
        
        _RAIOBORDA = 10.0f;
        _RAIOTEXT = 14.0f;
        
        _USUARIOZERO = @"0";
        
        _URL = @"http://54.187.203.61/appMusica/";
        
        //Configs da fonte
        _FONTECOR = [UIColor colorWithRed:0.898 green:0.49 blue:0.333 alpha:1]; /* Hexadecmial #c26c23  - r:229 g:125 b:85  */
        _FONTEFAMILIA = @"QuicksandBook-Regular";
        
        [self carregaTelas];
        [self carregaContexto];
    }
    return self;
}

-(void)carregaTelas{
    
    _TelaTBInstruementosQueToco = [[TBInstrumentosQueTocaViewController alloc] initWithNibName:@"TBInstrumentosQueTocaViewController" bundle:nil];
    _TelaTBInstrumentos = [[TBInstrumentosViewController alloc] initWithNibName:@"TBInstrumentosViewController" bundle:nil];
    _TelaTBEstilos = [[TBEstilosViewController alloc] initWithNibName:@"TBEstilosViewController" bundle:nil];
    _TelaTBEstilosQueToco = [[TBEstilosQueTocaViewController alloc] initWithNibName:@"TBEstilosQueTocaViewController" bundle:nil];
    _TelaCadastro = [[TelaCadastroViewController alloc] initWithNibName:@"TelaCadastroViewController" bundle:nil];
    _TelaLogin = [[TelaLoginViewController alloc] initWithNibName:@"TelaLoginViewController" bundle:nil];
    _TelaEsqueciSenha = [[TelaEsqueciSenhaViewController alloc] initWithNibName:@"TelaEsqueciSenhaViewController" bundle:nil];
    _TelaPerfil = [[TelaPerfilViewController alloc] initWithNibName:@"TelaPerfilViewController" bundle:nil];
    _TelaBusca = [[TelaBuscaViewController alloc] initWithNibName:@"TelaBuscaViewController" bundle:nil];
    _TelaInicio = [[TelaInicioViewController alloc] initWithNibName:@"TelaInicioViewController" bundle:nil];
    _TelaHorarios = [[TelaHorariosViewController alloc] initWithNibName:@"TelaHorariosViewController" bundle:nil];
    _TelaCadastroFoto = [[TelaCadastroFotoViewController alloc] initWithNibName:@"TelaCadastroFotoViewController" bundle:nil];
    _TelaUsuarioFiltrado = [[TelaUsuarioFiltrado alloc] initWithNibName:@"TelaUsuarioFiltrado" bundle:nil];
    _TelaOpcoes = [[TelaOpcoesViewController alloc] initWithNibName:@"TelaOpcoesViewController" bundle:nil];
    _TelaGravacao = [[CoreAudioViewController alloc] initWithNibName:@"CoreAudioViewController" bundle:nil];
    _TelaNovaBanda = [[TelaNovaBandaViewController alloc] initWithNibName:@"TelaNovaBandaViewController" bundle:nil];
    _TelaAmigos = [[TelaAmigosViewController alloc] initWithNibName:@"TelaAmigosViewController" bundle:nil];
    _TelaBanda = [[TelaBandaViewController alloc] initWithNibName:@"TelaBandaViewController" bundle:nil];
    _TelaGravacoes = [[TelaGravacoesViewController alloc] initWithNibName:@"TelaGravacoesViewController" bundle:nil];
}

-(void)carregaContexto{
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _context = [_appDelegate managedObjectContext];
}

+(void)carregaCoresDoLayout{
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:239 green:29 blue:71 alpha:1]];
}


-(NSString*)substituiCaracteresHTML:(NSString*)htmlCode{
    
    NSMutableString *temp = [NSMutableString stringWithString:htmlCode];
    
    [temp replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    
    [temp replaceOccurrencesOfString:@"&Agrave;" withString:@"À" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Aacute;" withString:@"Á" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Acirc;" withString:@"Â" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Atilde;" withString:@"Ã" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Auml;" withString:@"Ä" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Aring;" withString:@"Å" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&AElig;" withString:@"Æ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ccedil;" withString:@"Ç" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Egrave;" withString:@"È" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Eacute;" withString:@"É" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ecirc;" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Euml;" withString:@"Ë" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Igrave;" withString:@"Ì" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Iacute;" withString:@"Í" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Icirc;" withString:@"Î" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Iuml;" withString:@"Ï" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ETH;" withString:@"Ð" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ntilde;" withString:@"Ñ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ograve;" withString:@"Ò" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Oacute;" withString:@"Ó" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ocirc;" withString:@"Ô" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Otilde;" withString:@"Õ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ouml;" withString:@"Ö" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Oslash;" withString:@"Ø" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ugrave;" withString:@"Ù" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Uacute;" withString:@"Ú" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Ucirc;" withString:@"Û" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Uuml;" withString:@"Ü" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&Yacute;" withString:@"Ý" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&THORN;" withString:@"Þ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&szlig;" withString:@"ß" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&agrave;" withString:@"à" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&aacute;" withString:@"á" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&acirc;" withString:@"â" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&atilde;" withString:@"ã" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&auml;" withString:@"ä" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&aring;" withString:@"å" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&aelig;" withString:@"æ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ccedil;" withString:@"ç" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&egrave;" withString:@"è" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&eacute;" withString:@"é" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ecirc;" withString:@"ê" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&euml;" withString:@"ë" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&igrave;" withString:@"ì" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&iacute;" withString:@"í" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&icirc;" withString:@"î" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&iuml;" withString:@"ï" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&eth;" withString:@"ð" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ntilde;" withString:@"ñ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ograve;" withString:@"ò" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&oacute;" withString:@"ó" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ocirc;" withString:@"ô" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&otilde;" withString:@"õ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ouml;" withString:@"ö" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&oslash;" withString:@"ø" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ugrave;" withString:@"ù" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&uacute;" withString:@"ú" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&ucirc;" withString:@"û" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&uuml;" withString:@"ü" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&yacute;" withString:@"ý" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&thorn;" withString:@"þ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&yuml;" withString:@"ÿ" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    
    
    return [NSString stringWithString:temp];
}


+(BOOL)verificaSeViewJaEstaNaPilha:(NSArray*)viewControlers proximaTela:(UIViewController*)proximaTela{
    BOOL estaNaPilha = NO;
    
    for (UIViewController* vc in viewControlers) {
        if([vc isEqual:proximaTela]){
            estaNaPilha = YES;
        }
    }
    
    return estaNaPilha;
}

+(void)setParaUsuarioZero{
    TPUsuario *usuarioZero = [[TPUsuario alloc] init];
    usuarioZero.identificador = @"0";
    usuarioZero.nome = @"Nome";
    usuarioZero.email = @"Email";
    usuarioZero.senha = @"Senha";
    usuarioZero.sexo = @"Sexo";
    usuarioZero.cidade = @"Cidade";
    usuarioZero.bairro = @"Bairro";
    usuarioZero.atribuicoes = @"Atribuições";
    usuarioZero.estilos = [[NSMutableArray alloc] init];
    usuarioZero.instrumentos = [[NSMutableArray alloc] init];
    usuarioZero.horarios = [[NSMutableArray alloc] init];
    
    [[LocalStore sharedStore] setUsuarioAtual:usuarioZero];
}
@end
