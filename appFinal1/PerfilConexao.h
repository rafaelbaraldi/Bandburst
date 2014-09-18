//
//  PerfilConexao.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerfilConexao : NSObject

+(NSDictionary*)buscaIdENomeBandas:(NSString*)identificador;

+(NSDictionary*)buscaQtdDeAmigos;

@end
