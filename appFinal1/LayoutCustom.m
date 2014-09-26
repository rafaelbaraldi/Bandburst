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
    
    UIImageView *botao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    botao.image = [UIImage imageNamed:@"uncheck.png"];
    [botao setBackgroundColor:[UIColor clearColor]];
    
    return botao;
}

+(UIImageView*)botaoCollectionViewCellSelecionado{
    
    UIImageView *botaoSelecionado = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    botaoSelecionado.image = [UIImage imageNamed:@"check.png"];
    [botaoSelecionado setBackgroundColor:[UIColor clearColor]];
    botaoSelecionado.tag = 1;
    
    return botaoSelecionado;
}

@end
