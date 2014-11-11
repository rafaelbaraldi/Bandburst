//
//  BandaConexao.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BandaConexao : NSObject

+(NSDictionary*)buscaIdAmigos:(NSString*)identificador;
+(NSDictionary*)buscaBanda:(NSString*)identificador;
+(NSDictionary*)buscaMensagensBanda:(NSString*)identificador;
+(NSDictionary*)buscaMusicasBanda:(NSString*)identificador;

+(NSString*)alterarDados:(NSData*)jsonAlterar;
+(NSString*)cadastraBanda:(NSData*)jsonCadastro;
+(NSString*)enviaMensagem:(NSString*)mensagem idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario;

+(NSString*)enviaMusica:(NSString*)nomeMusica urlMusica:(NSString*)urlMusica idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario;

@end
