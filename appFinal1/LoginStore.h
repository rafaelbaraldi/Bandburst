//
//  LoginStore.h
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginConexao.h"

@interface LoginStore : NSObject

@property NSString* emailTemporario;

+(NSString*)email;
+(void)setEmail:(NSString*)novoEmail;

+(NSString*)senha;
+(void)setSenha:(NSString*)novaSenha;

+(LoginStore*)sharedStore;

+(BOOL)login:(NSString*)email senha:(NSString *)senha;

+(BOOL)verificaSeEstaLogado;
+(void)deslogar;
    
@end
