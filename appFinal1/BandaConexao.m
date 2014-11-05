//
//  BandaConexao.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "BandaConexao.h"
#import "LocalStore.h"

@implementation BandaConexao

+(NSDictionary*)buscaIdAmigos:(NSString*)identificador{
    NSString *url = @"http://54.207.112.185/appMusica/buscaIdAmigos.php";
    
    NSString *post = [NSString stringWithFormat:@"id=%@", identificador];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

+(NSDictionary*)buscaBanda:(NSString*)identificador{
    NSString *url = @"http://54.207.112.185/appMusica/buscaBanda.php";
    
    NSString *post = [NSString stringWithFormat:@"id=%@", identificador];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

+(NSDictionary*)buscaMensagensBanda:(NSString*)identificador{
    NSString *url = @"http://54.207.112.185/appMusica/buscaMensagensBanda.php";
    
    NSString *post = [NSString stringWithFormat:@"id=%@", identificador];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

+(NSDictionary*)buscaMusicasBanda:(NSString*)identificador{
    NSString *url = @"http://54.207.112.185/appMusica/buscaMusicasBanda.php";
    
    NSString *post = [NSString stringWithFormat:@"id=%@", identificador];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

+(NSString*)cadastraBanda:(NSData*)jsonCadastro{
    NSString *url = @"http://54.207.112.185/appMusica/cadastroBanda.php";
    
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


+(NSString*)enviaMensagem:(NSString*)mensagem idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario{
    NSString *url = @"http://54.207.112.185/appMusica/enviaMensagem.php";
    
    NSString *post = [NSString stringWithFormat:@"idBanda=%@&idUsuario=%@&mensagem=%@", idBanda, idUsuario, mensagem];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    return s;
}

+(NSString*)enviaMusica:(NSString*)nomeMusica urlMusica:(NSString*)urlMusica idBanda:(NSString*)idBanda idUsuario:(NSString*)idUsuario{
    NSString *url = [NSString stringWithFormat:@"http://54.207.112.185/appMusica/salvaMusica.php?idBanda=%@&idUsuario=%@&", idBanda, idUsuario];
    
    NSData *postData = [NSData dataWithContentsOfFile:urlMusica];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.mp3\"\r\n", nomeMusica] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:postData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return s;
}

@end
