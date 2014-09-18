//
//  LayoutCustom.m
//  appFinal1
//
//  Created by Rafael Cardoso on 22/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "LayoutCustom.h"

@implementation LayoutCustom

+(UIImageView*)botaoCollectionViewCellDefatult:(UICollectionViewCell*)cell{
    
    [(UIImageView*)[cell viewWithTag:1] removeFromSuperview];
    
    UIImageView *botao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [[botao layer] setCornerRadius:5];
    [[botao layer] setBorderColor:[UIColor blackColor].CGColor];
    [[botao layer] setBorderWidth:2.5f];
    
    return botao;
}

+(UIImageView*)botaoCollectionViewCellSelecionado{
    
    UIImageView *botaoSelecionado = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    botaoSelecionado.image = [UIImage imageNamed:@"selecionado.png"];
    [[botaoSelecionado layer] setCornerRadius:5];
    [[botaoSelecionado layer] setBorderColor:[UIColor blackColor].CGColor];
    [[botaoSelecionado layer] setBorderWidth:2.5f];
    botaoSelecionado.tag = 1;
    
    return botaoSelecionado;
}

@end
