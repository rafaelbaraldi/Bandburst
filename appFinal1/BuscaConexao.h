//
//  BuscaConexao.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 23/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuscaConexao : NSObject

+(NSDictionary*)retornaListaDe:(NSString*) tabela;

+(NSDictionary*)buscaUsuario:(NSString*)identificador;
+(NSDictionary*)buscaUsuario:(NSString *)instrumento estilo:(NSString*)estilo cidade:(NSString*)cidade horario:(NSString*)horario;

+(NSString*)seguirAmigo:(NSString*)idAmigo acao:(NSString*)acao;

@end
