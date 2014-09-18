//
//  BuscaStore.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 23/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "BuscaStore.h"

#import "TPInstrumento.h"
#import "TPHorario.h"
#import "LocalStore.h"

#import "BuscaConexao.h"

@implementation BuscaStore

+(BuscaStore*)sharedStore{
    static BuscaStore* sharedStore = nil;
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
        _instrumento = [[NSString alloc]init];
        _estilo = [[NSString alloc]init];
        
        _instrumentosFiltrados = [[NSMutableArray alloc] init];
        _estilosFiltrados = [[NSMutableArray alloc] init];
        _horariosFiltrados = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+(NSMutableArray*)retornaListaDe:(NSString*)nome{
    
    NSMutableArray *itens = [[NSMutableArray alloc] init];
    
    NSDictionary *json = [BuscaConexao retornaListaDe:nome];
    
    NSString *ret;
    
    for(NSString *s in json){
        ret = [s valueForKeyPath:@"nome"];
        [itens addObject:ret];
    }
    
    return itens;
}

+(TPUsuario*)buscaPessoa:(NSString*)identificador{
    NSDictionary *json = [BuscaConexao buscaUsuario:identificador];
    
    TPUsuario *pessoa = [[TPUsuario alloc]init];
    pessoa.identificador = @"";
    pessoa.nome = @"";
    pessoa.sexo = @"";
    pessoa.cidade = @"";
    pessoa.bairro = @"";
    pessoa.email = @"";
    pessoa.atribuicoes = @"";
    pessoa.horarios = [[NSMutableArray alloc] init];
    pessoa.instrumentos = [[NSMutableArray alloc]init];
    pessoa.estilos = [[NSMutableArray alloc]init];
    
    for(NSString *s in json){
        if([pessoa.nome  isEqualToString:@""]){
            pessoa.identificador = [s valueForKeyPath:@"id"];
            pessoa.nome = [s valueForKeyPath:@"nome"];
            pessoa.cidade = [s valueForKeyPath:@"cidade"];
            pessoa.sexo = [s valueForKeyPath:@"sexo"];
            pessoa.email = [s valueForKeyPath:@"email"];
            pessoa.bairro = [s valueForKeyPath:@"bairro"];
            pessoa.atribuicoes = [s valueForKeyPath:@"atribuicoes"];
        }
        if (![[s valueForKeyPath:@"horario"] isEqualToString:@""]){
            NSString *horario = [s valueForKeyPath:@"horario"];
            
            TPHorario *tpHorario = [[TPHorario alloc] init];
            tpHorario.dia = [horario substringToIndex:[horario length] - 1];
            tpHorario.periodo = [horario substringFromIndex:[horario length] - 1];
            
            [pessoa.horarios addObject:tpHorario];
        }
        if (![[s valueForKeyPath:@"instrumento_musical"] isEqualToString:@""]) {
            TPInstrumento *tpInstrumento = [[TPInstrumento alloc]init];
            tpInstrumento.nome = [s valueForKeyPath:@"instrumento_musical"];
            tpInstrumento.possui = [[s valueForKeyPath:@"possui"] boolValue];
            
            [pessoa.instrumentos addObject:tpInstrumento];
        }
        if (![[s valueForKeyPath:@"estilo_musical"] isEqualToString:@""]) {
            [pessoa.estilos addObject:[s valueForKeyPath:@"estilo_musical"]];
        }
    }
    return  pessoa;
}

+(NSMutableArray*)atualizaBusca:(NSMutableArray*)usuarios cidade:(NSString*)cidade{
    [usuarios removeAllObjects];
    
    NSDictionary *json = [BuscaConexao buscaUsuario:[[BuscaStore sharedStore]instrumento] estilo:[[BuscaStore sharedStore]estilo] cidade:cidade horario:[[BuscaStore sharedStore] horario]];
    
    for(NSString *s in json){
        if(![[s valueForKey:@"identificador"] isEqualToString:[[LocalStore sharedStore] usuarioAtual].identificador]){
            TPUsuario *ret = [[TPUsuario alloc]init];
            ret.identificador = [s valueForKey:@"identificador"];
            ret.nome = [s valueForKeyPath:@"nome"];
            ret.cidade = [s valueForKeyPath:@"cidade"];
            
            [usuarios addObject:ret];
        }
    }
    
    return usuarios;
}

@end
