//
//  TPUsuario.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 27/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPUsuario : NSObject

@property NSString *identificador;

@property NSString *nome;
@property NSString *sexo;
@property NSString *cidade;
@property NSString *bairro;
@property NSString *atribuicoes;
@property NSString *email;
@property NSString *senha;
@property NSMutableArray *estilos;
@property NSMutableArray *instrumentos;
@property NSMutableArray *horarios;

@end
