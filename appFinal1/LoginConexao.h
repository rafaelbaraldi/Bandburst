//
//  LoginConexao.h
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginConexao : NSObject

+(NSDictionary*)login:(NSString*)email senha:(NSString*)senha;
+(NSDictionary*)esqueciSenha:(NSString*)email;

@end
