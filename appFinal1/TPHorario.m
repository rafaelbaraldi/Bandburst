//
//  TPHorario.m
//  appFinal1
//
//  Created by Rafael Cardoso on 30/07/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TPHorario.h"

@implementation TPHorario

+(NSString*)horariosEmTexto:(NSMutableArray*)horarios{
    
    NSString *txtHorario = @"";
    int i = 1;
    for(int j = 0; j < [horarios count]; j = i){

        TPHorario *tp = [horarios objectAtIndex:j];
        
        //Primeira letra Maiuscula
        NSString *dia = tp.dia;
        NSString *folded = [[dia substringToIndex:1] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt-BR"]];
        dia = [[folded uppercaseString] stringByAppendingString:[dia substringFromIndex:1]];
        
        //Salva o dia
        txtHorario = [NSString stringWithFormat:@"%@%@:",txtHorario, dia];
    
        NSString *txtPeriodo = [self nomeDoPeriodo:tp.periodo];
        
        if(j == i){
            i++;
        }
        if (i == [horarios count]) {
            txtHorario = [NSString stringWithFormat:@"%@ %@ \n", txtHorario, txtPeriodo];
            break;
        }
        while ([tp.dia isEqualToString:((TPHorario*)[horarios objectAtIndex:i]).dia]) {
            NSString *periodo = ((TPHorario*)[horarios objectAtIndex:i]).periodo;
            
            //Salva o periodo
            txtPeriodo = [NSString stringWithFormat:@"%@ - %@", txtPeriodo, [self nomeDoPeriodo:periodo]];
            i++;
            
            if (i == [horarios count]) {
                break;
            }
        }
        
        txtHorario = [NSString stringWithFormat:@"%@ %@ \n", txtHorario, txtPeriodo];
    }
    
    return txtHorario;
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

+(int)qtdHorario{
    
    
}

@end
