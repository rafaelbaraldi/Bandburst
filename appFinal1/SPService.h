//
//  SPService.h
//  Bandburst
//
//  Created by Rafael Cardoso on 27/11/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Usuario.h"
#import "ModelUser.h"

@interface SPService : NSObject

+(SPService*)sharedStore;

+(void)signUp:(NSString*)email nome:(NSString*)nome senha:(NSString*)senha;

+(void)logIn:(NSString*)email;

+(void)updateUser:(Usuario*)usuario;

+(void)newGRoup:(NSString*)groupName;

+(ModelUser*)getUserLoged;

@end
