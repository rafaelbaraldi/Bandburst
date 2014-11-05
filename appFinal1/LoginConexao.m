//
//  LoginConexao.m
//  appFinal1
//
//  Created by Rafael Cardoso on 07/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "LoginConexao.h"
#import "LocalStore.h"

@implementation LoginConexao

+(NSDictionary*)login:(NSString*)email senha:(NSString*)senha{

    NSString *url = @"http://54.207.112.185/appMusica/login.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@&senha=%@", email, senha];
    
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


+(NSDictionary*)esqueciSenha:(NSString*)email{
    
    NSString *url = @"http://54.207.112.185/appMusica/esqueciasenha.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@", email];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //s = [[LocalStore sharedStore]substituiCaracteresHTML:s];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    return json;
}

@end
