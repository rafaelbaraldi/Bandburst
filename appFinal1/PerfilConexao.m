//
//  PerfilConexao.m
//  appFinal1
//
//  Created by RAFAEL BARALDI on 06/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "PerfilConexao.h"
#import "LocalStore.h"

@implementation PerfilConexao

+(NSDictionary*)buscaIdENomeBandas:(NSString*)identificador{
    NSString *url = @"http://54.187.203.61/appMusica/buscaIdBandas.php";
    
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

+(NSDictionary*)buscaQtdDeAmigos{
    NSString *url = @"http://54.187.203.61/appMusica/buscaQtdDeAmigos.php";
    
    NSString *post = [NSString stringWithFormat:@"id=%@", [[LocalStore sharedStore] usuarioAtual].identificador];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

@end
