//
//  TPHorario.m
//  appFinal1
//
//  Created by Rafael Cardoso on 30/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TPHorario.h"


@implementation TPHorario

+(NSMutableArray*)getHorarios:(NSMutableArray*)horarios{
    
    NSMutableArray *rHorarios = [[NSMutableArray alloc] init];
    
    NSString *nome = @"";
    NSString *periodo = @"";
    NSString *auxDia = @"";
    
    //Percorre vetor completo
    for (TPHorario *hDia in horarios) {
        
        if(![hDia.dia isEqualToString:auxDia]){
            
            nome = hDia.dia;
            auxDia = hDia.dia;
            
            //Percorre para salvar o Periodo
            for (TPHorario *hPeriodo in horarios){
                
                if([hPeriodo.dia isEqualToString:nome]){
                    if([periodo length] == 0){
                        periodo = [self nomeDoPeriodo:hPeriodo.periodo];
                    }
                    else{
                        periodo = [NSString stringWithFormat:@"%@ - %@", periodo, [self nomeDoPeriodo:hPeriodo.periodo]];
                    }
                }
            }
            
            nome = [self deixarPrimeiroCharMaiusculo:nome];
            nome = [NSString stringWithFormat:@"%@ %@", nome, periodo];
            periodo = @"";
            
            [rHorarios addObject:nome];
        }
    }
    
    return rHorarios;
}

+(NSString *)deixarPrimeiroCharMaiusculo:(NSString*)tpDia{
    
    if([tpDia isEqualToString:@"terca"]){
        tpDia = @"terça";
    }
    else if ([tpDia isEqualToString:@"sabado"]){
        tpDia = @"sábado";
    }
    
    //Primeira letra Maiuscula
    NSString *dia = tpDia;
    NSString *folded = [[dia substringToIndex:1] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"]];
    dia = [[folded uppercaseString] stringByAppendingString:[dia substringFromIndex:1]];
    
    return dia;
}

+(NSString *)nomeDoPeriodo:(NSString*)periodo{
    
    NSString *txtPeriodo;

    if([periodo isEqualToString:@"0"]){
        txtPeriodo = @"Manhã";
    }
    if([periodo isEqualToString:@"1"]){
        txtPeriodo = @"Tarde";
    }
    if([periodo isEqualToString:@"2"]){
        txtPeriodo = @"Noite";
    }
    
    return txtPeriodo;
}

@end
