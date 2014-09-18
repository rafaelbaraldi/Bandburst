//
//  Musica.h
//  appFinal1
//
//  Created by Rafael Baraldi on 23/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Musica : NSManagedObject

@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSNumber * idUsuario;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * url;

@end
