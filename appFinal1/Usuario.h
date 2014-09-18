//
//  Usuario.h
//  appFinal1
//
//  Created by Rafael Baraldi on 23/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * bairro;
@property (nonatomic, retain) NSString * cidade;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * estilos;
@property (nonatomic, retain) NSString * horarios;
@property (nonatomic, retain) NSString * instrumentos;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * observacoes;
@property (nonatomic, retain) NSString * senha;
@property (nonatomic, retain) NSString * sexo;
@property (nonatomic, retain) NSNumber * identificador;

@end
