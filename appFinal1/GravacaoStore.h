//
//  GravacaoStore.h
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 22/10/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Musica.h"

#import "TPMusica.h"

@interface GravacaoStore : NSObject

+(GravacaoStore*)sharedStore;

@property Musica *gravacao;
@property TPMusica *gravacaoStreaming;

@property BOOL streaming;

@end
