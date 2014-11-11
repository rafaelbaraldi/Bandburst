//
//  BandaStore.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "BandaStore.h"
#import "BandaConexao.h"
#import "LocalStore.h"
#import "BuscaStore.h"
#import "TPMensagem.h"
#import "TPMusica.h"

@implementation BandaStore

+(BandaStore*)sharedStore{
    static BandaStore* sharedStore = nil;
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
        _membros = [[NSMutableArray alloc] init];
    }
    return self;
}

+(NSMutableArray*)retornaListaDeAmigos{
    
    NSMutableArray *itens = [[NSMutableArray alloc] init];
    
    NSDictionary *json = [BandaConexao buscaIdAmigos:[[[LocalStore sharedStore] usuarioAtual] identificador]];
    
    NSString *identificador;
    
    for(NSString *s in json){
        identificador = [s valueForKeyPath:@"id"];
        [itens addObject:[BuscaStore buscaPessoa:identificador]];
    }
    
    return itens;
}


+(NSString*)criarBanda:(NSString*)nome membros:(NSString*)membros idAdm:(NSString*)idAdm{
    NSDictionary *jsonUsuario = [NSDictionary dictionaryWithObjectsAndKeys:
                                 nome, @"nome",
                                 idAdm, @"idAdm",
                                 membros, @"membros" , nil];
    
    NSData *jsonCadastrar = [NSJSONSerialization dataWithJSONObject:jsonUsuario options:NSJSONWritingPrettyPrinted error:nil];
    
    //    NSString* newStr = [[NSString alloc] initWithData:jsonCadastrar encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",newStr);
    
    NSString* cadastrou = [BandaConexao cadastraBanda:jsonCadastrar];
    
    return cadastrou;
}

+(TPBanda*)buscaBanda:(NSString*)identificador{
    
    NSDictionary *json = [BandaConexao buscaBanda:identificador];
    
    TPBanda *banda = [[TPBanda alloc] init];
    
    banda.identificador = @"";
    banda.nome = @"";
    banda.idAdm = @"";
    banda.membros = [[NSMutableArray alloc]init];
    
    for(NSString *s in json){
        if([banda.nome  isEqualToString:@""]){
            banda.identificador = [s valueForKeyPath:@"id"];
            banda.nome = [s valueForKeyPath:@"nome"];;
            banda.idAdm = [s valueForKeyPath:@"idBanda"];
        }
        if (![[s valueForKeyPath:@"usuario_id"] isEqualToString:@""]) {
            TPUsuario* membro = [[TPUsuario alloc] init];
            membro.identificador = [s valueForKeyPath:@"usuario_id"];
            membro.nome = [s valueForKeyPath:@"nome_usuario"];
            [banda.membros addObject:membro];
        }
    }
    
    banda.mensagens = [BandaStore buscaMensagensBanda:identificador];
    banda.musicas = [BandaStore buscaMusicasBanda:identificador];
    
    return banda;
}

+(NSString*)alterarDados:(NSString*)acao dado:(NSString*)dado idBanda:(NSString*)idBanda{
    
    NSDictionary *dicBanda = [NSDictionary dictionaryWithObjectsAndKeys:
                                 acao, @"acao",
                                 idBanda, @"identificador",
                                 dado, @"dado" , nil];
    
    NSData *jsonAlterarBanda = [NSJSONSerialization dataWithJSONObject:dicBanda options:NSJSONWritingPrettyPrinted error:nil];
    
    return [BandaConexao alterarDados:jsonAlterarBanda];
}

+(NSMutableArray*)buscaMensagensBanda:(NSString*)identificador{
    NSDictionary* json = [BandaConexao buscaMensagensBanda:identificador];
    
    NSMutableArray* lista = [[NSMutableArray alloc] init];
    
    for (NSString* s in json) {
        TPMensagem* m = [[TPMensagem alloc] init];
        m.identificador = [s valueForKey:@"mensagem_id"];
        m.mensagem = [s valueForKey:@"mensagem"];
        m.idUsuario = [s valueForKey:@"usuario_id"];
        m.nomeUsuario = [s valueForKeyPath:@"usuario_nome"];
        
        [lista addObject:m];
    }
    
    return lista;
}

+(NSMutableArray*)buscaMusicasBanda:(NSString*)identificador{
    NSDictionary* json = [BandaConexao buscaMusicasBanda:identificador];
    
    NSMutableArray* lista = [[NSMutableArray alloc] init];
    
    for (NSString* s in json) {
        TPMusica* m = [[TPMusica alloc] init];
        m.identificador = [s valueForKey:@"musica_id"];
        m.url = [s valueForKey:@"musica"];
        m.idUsuario = [s valueForKey:@"usuario_id"];
        
        [lista addObject:m];
    }
    
    return lista;
}

+(NSString*)enviaMensagem:(NSString*)mensagem idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario{
    return [BandaConexao enviaMensagem:mensagem idBanda:idBanda idUsuario:idUsuario];
}

+(NSString*)enviaMusica:(NSString*)nomeMusica urlMusica:(NSString*)urlMusica idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario{
    return [BandaConexao enviaMusica:nomeMusica urlMusica:urlMusica idBanda:idBanda idUsuario:idUsuario];
}

@end
