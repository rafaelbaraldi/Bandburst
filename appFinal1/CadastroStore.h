//
//  CadastroStore.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 16/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TelaCadastroViewController.h"

#import "Usuario.h"

@interface CadastroStore : NSObject

@property NSString *nomeFotoPerfil;

@property BOOL cadastro;

@property NSMutableArray *instrumentos;
@property NSMutableArray *instrumentosQueToca;
@property NSMutableArray *instrumentosFiltrados;

@property NSMutableArray *estilos;
@property NSMutableArray *estilosQueToca;
@property NSMutableArray *estilosFiltrados;

@property NSMutableArray *horariosQueToca;

@property TelaCadastroViewController *viewTela;

+(CadastroStore*)sharedStore;

+(NSString *)validaCadastro:(Usuario*)usuario;

+(NSString *)validaEmail:(NSString*)email;

+(NSString*)cadastrar:(Usuario*)usuario atualizar:(BOOL)atualizar;

@end
