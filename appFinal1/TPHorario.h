//
//  TPHorario.h
//  appFinal1
//
//  Created by Rafael Cardoso on 30/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPHorario : NSObject

@property NSString *dia;
@property NSString *periodo;

+(NSString*)horariosEmTexto:(NSMutableArray*)horarios;
+(int)qtdHorario;

@end
