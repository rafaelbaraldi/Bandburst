//
//  LoginStore.m
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Security/Security.h>

#import "LoginStore.h"
#import "Usuario.h"
#import "LocalStore.h"
#import "BuscaStore.h"

#import "SPService.h"

@implementation LoginStore

static NSString* email = @"";
static NSString* senha = @"";

+(LoginStore*)sharedStore{
    static LoginStore* sharedStore = nil;
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

    }
    return self;
}

+(NSString*)email{
    return email;
}
+(NSString*)senha{
    return senha;
}
+(void)setEmail:(NSString *)novoEmail{
    email = novoEmail;
}
+(void)setSenha:(NSString *)novaSenha{
    senha = novaSenha;
}

+(BOOL)verificaSeEstaLogado{
    
    BOOL resposta = NO;
   
    NSUserDefaults *autenticaLogin = [NSUserDefaults standardUserDefaults];
    NSString *identificador = [autenticaLogin objectForKey:@"identificador"];
    
    if(identificador != nil){
        
        [[LocalStore sharedStore] setUsuarioAtual:[BuscaStore buscaPessoa:identificador]];
        
        NSString* email = [[LocalStore sharedStore] usuarioAtual].email;
        
        [SPService logIn:email];
        
        resposta = YES;
    }
    
    return resposta;
}

+(Usuario*)carregaUsuarioCoreData:(NSString *)identificador{
    
    Usuario *u;
    
    NSFetchRequest *nsfr = [NSFetchRequest fetchRequestWithEntityName:@"Usuario"];
    NSNumber *number = [[NSNumber alloc] initWithInt:[identificador intValue]];
    NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"identificador == %@",number];
    [nsfr setPredicate:predicateID];
    
    NSMutableArray *buscaUsuario = [[NSMutableArray alloc] initWithArray:[[[LocalStore sharedStore] context] executeFetchRequest:nsfr error:nil]];
    
    if([buscaUsuario count] <= 0){
        return nil;
    }
    else{
        u = [buscaUsuario objectAtIndex:0];
        
        return u;
    }
}

+(void)armazenaLogin:(NSDictionary*)usuario{
    
    //Cria usuario no CoreData ou atualiza os dados
    Usuario * u = [self carregaUsuarioCoreData:[usuario valueForKeyPath:@"id"]];

    if (u == nil) {
        u = [NSEntityDescription insertNewObjectForEntityForName:@"Usuario"
                                          inManagedObjectContext:[[LocalStore sharedStore] context]];
    }
    
    //Salva usuario logado no CoreData
    [u setNome:[usuario valueForKeyPath:@"-"]];
    [u setEmail:[usuario valueForKeyPath:@"-"]];
    [u setSenha:[usuario valueForKeyPath:@"-"]];
    [u setSexo:[usuario valueForKeyPath:@"-"]];
    [u setCidade:[usuario valueForKeyPath:@"-"]];
    [u setBairro:[usuario valueForKeyPath:@"-"]];
    [u setObservacoes:[usuario valueForKeyPath:@"-"]];
    
    NSNumber *number = [[NSNumber alloc] initWithInt:[[usuario valueForKey:@"id"] intValue]];
    [u setIdentificador:number];
    
    [[[LocalStore sharedStore] context]  save:nil];
    
    //Salva usuario Logado no TPUsuario
    [[LocalStore sharedStore] setUsuarioAtual:[BuscaStore buscaPessoa:[usuario valueForKeyPath:@"id"]]];
    
    //Salva id do Usuario para autenticar login
    NSUserDefaults *autenticaLogin = [NSUserDefaults standardUserDefaults];
    [autenticaLogin setObject:[u.identificador stringValue] forKey:@"identificador"];
    [autenticaLogin synchronize];    
}

+(void)deslogar{
    
    //Limpa CoreData
    NSArray *recuperaUsuario = [[[LocalStore sharedStore] context] executeFetchRequest:[NSFetchRequest
                                                                   fetchRequestWithEntityName:@"Usuario"] error:nil];
    recuperaUsuario = nil;
    
    //Remove usuarioAtual
    [LocalStore setParaUsuarioZero];
    
    //Remove autenticacao do Usuario
    NSUserDefaults *autenticaLogin = [NSUserDefaults standardUserDefaults];
    [autenticaLogin removeObjectForKey:@"identificador"];
    [autenticaLogin synchronize];
}

+(BOOL)login:(NSString*)email senha:(NSString *)senha{
    
    NSDictionary *json = [LoginConexao login:email senha:senha];
    
    if([json count] > 0){
        
        [self setEmail:email];
        [self setSenha:senha];

        //Em TPUsuario
        [self armazenaLogin:json];
        
        //Login SPIKA
        [SPService logIn:email];
        
        return true;
    }
    
    return false;
}

@end
