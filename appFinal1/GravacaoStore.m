//
//  GravacaoStore.m
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "GravacaoStore.h"
#import "LocalStore.h"

@implementation GravacaoStore

+(GravacaoStore*)sharedStore{
    static GravacaoStore* sharedStore = nil;
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
        _streaming = NO;
    }
    return self;
}


+(void)removerGravacao:(Musica *)removerMusica{
    
    NSFetchRequest *nsfr = [NSFetchRequest fetchRequestWithEntityName:@"Musica"];
    NSNumber *number = [[NSNumber alloc] initWithInt:[[[LocalStore sharedStore] usuarioAtual].identificador intValue]];
    NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"idUsuario == 0 || idUsuario == %@",number];
    [nsfr setPredicate:predicateID];
    
    NSMutableArray *musicas = [[NSMutableArray alloc] initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:nsfr error:nil]];
    
    for(NSManagedObject *m in musicas){
        if([m isEqual:removerMusica]){
            [[[LocalStore sharedStore] context] deleteObject:m];
        }
    }
}


@end
