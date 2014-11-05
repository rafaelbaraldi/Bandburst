//
//  CadastroConexao.m
//  appFinal1
//
//  Created by Rafael Cardoso on 14/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "CadastroConexao.h"

#import "Usuario.h"
#import "LocalStore.h"
#import "CadastroStore.h"

@implementation CadastroConexao

+(void)uploadFoto:(UIImage*)foto{

    NSString *url = @"http://54.207.112.185/appMusica/cadastroFoto.php";

    NSData *postData = UIImagePNGRepresentation(foto);
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.png\"\r\n", [[LocalStore sharedStore] usuarioAtual].identificador] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:postData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@ -- %@",s, [[LocalStore sharedStore] usuarioAtual].identificador);
}

+(NSString*)cadastrar:(NSData*)jsonCadastro{
    
    NSString *url = @"http://54.207.112.185/appMusica/cadastroUsuario.php";
    
    NSString *strJson = [[NSString alloc] initWithData:jsonCadastro encoding:NSUTF8StringEncoding];

    NSData *jsonData = [strJson dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:jsonData];
    
    NSURLResponse *response;    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    return s;
}

+(NSString*)atualizar:(NSData*)jsonCadastro{
    
    NSString *url = @"http://54.207.112.185/appMusica/atualizaUsuario.php";
    
    NSString *strJson = [[NSString alloc] initWithData:jsonCadastro encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [strJson dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:jsonData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    return s;
}

+(NSString*)validarEmail:(NSString*)email{
    
    NSString *url = @"http://54.207.112.185/appMusica/validarEmail.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@", email];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return s;
}


@end
