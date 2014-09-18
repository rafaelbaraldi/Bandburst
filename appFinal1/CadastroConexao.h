//
//  CadastroConexao.h
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Usuario.h"

@interface CadastroConexao : NSObject

+(NSString*)cadastrar:(NSData*)jsonCadastro;

+(void)uploadFoto:(UIImage*)foto;

+(NSString*)validarEmail:(NSString*)email;

@end
