//
//  GravacaoStore.h
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Musica.h"

@interface GravacaoStore : NSObject

+(GravacaoStore*)sharedStore;

@property Musica *gravacao;

@end
