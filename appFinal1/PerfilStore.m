//
//  PerfilStore.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "PerfilStore.h"
#import "PerfilConexao.h"
#import "LocalStore.h"
#import "TPBanda.h"
#import "Musica.h"

@implementation PerfilStore

+(NSString*)qtdDeAmigos{
    
    NSDictionary *json = [PerfilConexao buscaQtdDeAmigos];
    
    return [json valueForKeyPath:@"qtd"];
}

+(NSMutableArray*)retornaListaDeBandas{
    
    NSMutableArray *itens = [[NSMutableArray alloc] init];
    
    NSDictionary *json = [PerfilConexao buscaIdENomeBandas:[[[LocalStore sharedStore] usuarioAtual] identificador]];
    
    for(NSString *s in json){
        TPBanda* banda = [[TPBanda alloc] init];
        banda.identificador = [s valueForKeyPath:@"id"];
        banda.nome = [s valueForKeyPath:@"nome"];
        [itens addObject:banda];
    }
    
    return itens;
}

+(NSMutableArray*)retornaListaDeMusicas{
    
    NSMutableArray *musicas;
    
    NSFetchRequest *nsfr = [NSFetchRequest fetchRequestWithEntityName:@"Musica"];
    NSNumber *number = [[NSNumber alloc] initWithInt:[[[LocalStore sharedStore] usuarioAtual].identificador intValue]];
    NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"idUsuario == 0 || idUsuario == %@",number];
    [nsfr setPredicate:predicateID];
    
    musicas = [[NSMutableArray alloc] initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:nsfr error:nil]];
    
    return musicas;
}

+(NSMutableArray*)retornaListaDeCategorias:(NSMutableArray*)musicas{
    
    NSMutableArray *categorias = [[NSMutableArray alloc] init];
    
    for (Musica* m in musicas) {
        if(![categorias containsObject:m.categoria]){
            [categorias addObject:m.categoria];
        }
    }
    
    return categorias;
}

+(NSMutableArray*)retornaListaDeMusicasPorCategorias:(NSMutableArray*)musicas{
    
    NSMutableArray *categorias = [[NSMutableArray alloc] init];
    NSMutableArray *musicasPorCategoria = [[NSMutableArray alloc] init];
    
    for (Musica* m in musicas) {
        if(![categorias containsObject:m.categoria]){
            [categorias addObject:m.categoria];
            [musicasPorCategoria addObject:[[NSMutableArray alloc] init]];
        }
    }
    
    for (int i = 0; i < [categorias count]; i++) {
        for (Musica* m in musicas) {
            if([[categorias objectAtIndex:i] isEqualToString:m.categoria]){
                [[musicasPorCategoria objectAtIndex:i] addObject:m];
            }
        }
    }
    
    return musicasPorCategoria;
}

@end
