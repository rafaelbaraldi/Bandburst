//
//  PerfilStore.h
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerfilStore : NSObject

+(NSMutableArray*)retornaListaDeBandas;

+(NSMutableArray*)retornaListaDeMusicas;
+(NSMutableArray*)retornaListaDeMusicasPorCategorias:(NSMutableArray*)musicas;
+(NSMutableArray*)retornaListaDeCategorias:(NSMutableArray*)musicas;

+(NSString*)qtdDeAmigos;

@end
