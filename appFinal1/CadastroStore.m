//
//  CadastroStore.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 16/05/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "CadastroStore.h"

#import "BuscaStore.h"

#import "CadastroConexao.h"

@implementation CadastroStore

+(CadastroStore*)sharedStore{
    static CadastroStore* sharedStore = nil;
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
        //instrumentos
        _instrumentos = [BuscaStore retornaListaDe:@"instrumento"];
        
        _instrumentosQueToca =[[NSMutableArray alloc] init];
        
        _instrumentosFiltrados =[[NSMutableArray alloc] init];
        [_instrumentosFiltrados addObjectsFromArray:_instrumentos];
        
        //estilos
        _estilos = [BuscaStore retornaListaDe:@"estilo"];
        
        _estilosQueToca =[[NSMutableArray alloc] init];
        
        _estilosFiltrados =[[NSMutableArray alloc] init];
        [_estilosFiltrados addObjectsFromArray:_estilos];
        
        //horaios
        _horariosQueToca = [[NSMutableArray alloc]init];
        
    }
    return self;
}

+(NSString*)cadastrar:(Usuario*)usuario{
    
    NSDictionary *jsonUsuario = [NSDictionary dictionaryWithObjectsAndKeys:
                                 usuario.observacoes, @"observacoes",
                                 usuario.estilos, @"estilos",
                                 usuario.instrumentos, @"instrumentos",
                                 usuario.horarios, @"horarios",                                 
                                 usuario.bairro, @"bairro",
                                 usuario.cidade, @"cidade",
                                 usuario.sexo, @"sexo",
                                 usuario.senha, @"senha",
                                 usuario.email, @"email",
                                 usuario.nome, @"nome" , nil];
    
    NSData *jsonCadastrar = [NSJSONSerialization dataWithJSONObject:jsonUsuario options:NSJSONWritingPrettyPrinted error:nil];
    
//    NSString* newStr = [[NSString alloc] initWithData:jsonCadastrar encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",newStr);

    NSString* cadastrou = [CadastroConexao cadastrar:jsonCadastrar];
    
    return cadastrou;
}

+(NSString *)validaCadastro:(Usuario *)usuario{
    
    NSString *valida;
    
    if([usuario.nome length] == 0){
        valida = @"seu NOME";
        return valida;
    }
    if([usuario.email length] == 0){
        valida = @"seu EMAIL";
        return valida;
    }
    if([usuario.senha length] == 0){
        valida = @"sua SENHA";
        return valida;
    }
    if([usuario.cidade length] == 0){
        valida = @"sua CIDADE";
        return valida;
    }
    if([usuario.bairro length] == 0){
        valida = @"seu BAIRRO";
        return valida;
    }
    if([usuario.instrumentos length] == 0){
        valida = @"seus INSTRUMENTOS";
        return valida;
    }
    if([usuario.estilos length] == 0){
        valida = @"seus ESTILOS";
        return valida;
    }
    if([usuario.horarios length] == 0){
        valida = @"seus HORÁRIOS disponíveis para ensaio";
        return valida;
    }
    
    return valida;
}

+(NSString*)validaEmail:(NSString *)email{
    
    NSString *resposta =[CadastroConexao validarEmail:email];
    
    if ([resposta length] > 0) {
        return @"erro";
    }
    else{
        return resposta;
    }
}

@end


