//
//  SPService.m
//  Bandburst
//
//  Created by Rafael Cardoso on 27/11/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "SPService.h"
#import "Usuario.h"

#import "UserManager.h"
#import "DatabaseManager.h"

#import "LocalStore.h"

@implementation SPService

+(SPService*)sharedStore{
    static SPService* sharedStore = nil;
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

+(ModelUser*)getUserLoged{
    
    return [UserManager defaultManager].getLoginedUser;
}

+(void) newGRoup:(NSString*)groupName{
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSString *groupPassword = @"";
//        NSString *description = @"";
//        NSString *selectedCategoryID = @"";
//        NSString *category = @"";
//        
//        ModelUser *user = [[UserManager defaultManager] getLoginedUser];
//        
//        [[DatabaseManager defaultManager]
//         
//         createGroup:groupName
//         description:description
//         password:groupPassword
//         categoryID:selectedCategoryID
//         categoryName:category
//         ower:user
//         avatarImage:nil
//         success:^(BOOL isSuccess, NSString *errStr) {}
//         error:^(NSString *errStr) {
//         }];
//        
//    });
}

+(void)updateUser:(Usuario*)usuario{
    
    ModelUser *user = [UserManager defaultManager].getLoginedUser;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        user.name = usuario.nome;
        user.email = usuario.email;
        user.password = usuario.senha;
        
        [[DatabaseManager defaultManager] updateUser:user
                                            oldEmail:usuario.email
                                             success:^(BOOL isSuccess, NSString *errStr){

                                                 
                                             } error:^(NSString *errStr){
                                             }];
        
    });
    
    
}

+(void)logIn:(NSString *)email{
    
//    NSDictionary *jsonUser = [self getUserSpika:email];
//    NSString *senha = [jsonUser valueForKeyPath:@"password"];
//    
//    __block NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    
//    DMFindOneBlock successBlock = ^(ModelUser *user){
//        
//        if(user){
//            [userDefault setObject:email forKey:UserDefaultLastLoginEmail];
//            [userDefault setObject:senha forKey:UserDefaultLastLoginPass];
//            [userDefault synchronize];
//        }
//    };
//    
//    DMErrorBlock errorBlock = ^(NSString *errStr){};
//    
//    [[DatabaseManager defaultManager] loginUserByEmail:email
//                                              password:senha
//                                               success:successBlock
//                                                 error:errorBlock];
//    
//   
//    [self autenticaLoginEmail:email];
}

+(void)signUp:(NSString*)email nome:(NSString*)nome senha:(NSString*)senha{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    [[DatabaseManager defaultManager] createUserByEmail:email
                                                   name:nome
                                               password:senha
                                                success:^(BOOL isSuccess, NSString *errStr){
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        if(isSuccess == YES){
                                                            
                                                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                                            [userDefault setObject:email forKey:UserDefaultLastLoginEmail];
                                                            [userDefault setObject:senha forKey:UserDefaultLastLoginPass];
                                                            [userDefault synchronize];
                                                            
                                                            [self setIdUserSpikaEmail:email];
                                                        }
                                                    });
                                                }
                                                error:^(NSString *errStr){
                                                }];
    });
}

//Salva id no Bandburst do usuario SPIKA
+(void)setIdUserSpikaEmail:(NSString*)email{
    
    NSString *url = @"http://54.207.112.185/appMusica/spikaservice/setIdSpika.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@", email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
//    NSString* s = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",s);
}


+(NSDictionary*)getUserSpika:(NSString*)email{
    
    NSString *url = @"http://54.207.112.185/appMusica/spikaservice/getUserSpika.php";
    
    NSString *post = [NSString stringWithFormat:@"email=%@", email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"context-type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:[[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]      dataUsingEncoding:NSUTF8StringEncoding]
                                options:kNilOptions error:nil];
    
    return json;
}

+(void)autenticaLoginEmail:(NSString*)email {
    
    NSDictionary *jsonUser = [self getUserSpika:email];
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithObjects:0, nil];
    
    ModelUser *user = [[ModelUser alloc] init];
    user._id = [jsonUser valueForKeyPath:@"_id"];
    user.name = [jsonUser valueForKeyPath:@"name"];
    user.email = [jsonUser valueForKeyPath:@"email"];
    user.password = [jsonUser valueForKeyPath:@"password"];
    user.gender = @"gender";
    user.birthday = 0;
    user.about = @"about";
    user.onlineStatus = @"online";
    user.contacts = contacts;
    user.iOSPushToken = @"";
    user.fileId = @"";
    user.thumbFileId = @"";
    user.favouriteGroups = 0;
    user.attachmentsOrig = 0;
    user.token = [jsonUser valueForKeyPath:@"token"];
    user.tokenTimestamp = (long)[jsonUser valueForKeyPath:@"token_timestamp"];
    user.maxContactNum = 100;
    user.maxFavoriteNum = 100;
    
    
    [[UserManager defaultManager] setLoginedUser:user];
    
}


@end
