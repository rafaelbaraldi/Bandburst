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

+(void) newGRoup:(NSString*)groupName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *groupPassword = @"";
        NSString *description = @"";
        NSString *selectedCategoryID = @"";
        NSString *category = @"";
        
        ModelUser *user = [[UserManager defaultManager] getLoginedUser];
        
        [[DatabaseManager defaultManager]
         
         createGroup:groupName
         description:description
         password:groupPassword
         categoryID:selectedCategoryID
         categoryName:category
         ower:user
         avatarImage:nil
         success:^(BOOL isSuccess, NSString *errStr) {
             
             [[UserManager defaultManager] reloadUserDataWithCompletion:^(id result) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (isSuccess == YES) {
                         
//                         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationSideMenuGroupsSelected object:nil];
                         
                     }
                 });
             }];
             
         } error:^(NSString *errStr) {
         }];
        
    });
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
                                                 
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     if (isSuccess) {
                                                         [[UserManager defaultManager] reloadUserDataWithCompletion:^(id result) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                             });
                                                         }];
                                                         
                                                     }
                                                     
                                                 });
                                                 
                                             } error:^(NSString *errStr){
                                             }];
        
    });
    
    
}

+(void)logIn:(NSString *)email senha:(NSString *)senha{
    
    __block NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    DMFindOneBlock successBlock = ^(ModelUser *user){
        
        if(user){
            
            [userDefault setObject:email forKey:UserDefaultLastLoginEmail];
            [userDefault setObject:senha forKey:UserDefaultLastLoginPass];
            [userDefault synchronize];
            
//            [notificationCenter postNotificationName:NotificationLoginFinished object:user];
        }
        
    };
    
    [[DatabaseManager defaultManager] loginUserByEmail:email
                                              password:senha
                                               success:successBlock
                                                 error:nil];
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
                                                        }
                                                    });
                                                }
                                                error:^(NSString *errStr){
                                                }];
        
    });
}


@end
