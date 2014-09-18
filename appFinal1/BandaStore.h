//
//  BandaStore.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TPBanda.h"

@interface BandaStore : NSObject

+(BandaStore*)sharedStore;

@property NSMutableArray* membros;
@property NSString *idBandaSelecionada;

+(NSMutableArray*)retornaListaDeAmigos;
+(NSMutableArray*)buscaMensagensBanda:(NSString*)identificador;
+(NSMutableArray*)buscaMusicasBanda:(NSString*)identificador;
+(NSString*)criarBanda:(NSString*)nome membros:(NSString*)membros;

+(NSString*)enviaMensagem:(NSString*)mensagem idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario;

+(TPBanda*)buscaBanda:(NSString*)identificador;

+(NSString*)enviaMusica:(NSString*)nomeMusica urlMusica:(NSString*)urlMusica idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario;

@end
